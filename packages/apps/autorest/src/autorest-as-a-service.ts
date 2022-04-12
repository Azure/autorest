/* eslint-disable no-process-exit */
/* eslint-disable no-console */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { spawn } from "child_process";
import { lookup } from "dns";
import { mkdtempSync, rmdirSync } from "fs";
import { homedir, tmpdir } from "os";
import { join } from "path";
import { IAutorestLogger } from "@autorest/common";
import { AutorestConfiguration } from "@autorest/configuration";
import { isFile, mkdir, isDirectory } from "@azure-tools/async-io";
import { Extension, ExtensionManager, Package } from "@azure-tools/extension";
import { Exception, When } from "@azure-tools/tasks";
import * as semver from "semver";
import { AutorestArgs } from "./args";
import { VERSION } from "./constants";
import { parseMemory } from "./utils";

const inWebpack = typeof __webpack_require__ === "function";
const nodeRequire = inWebpack ? __non_webpack_require__! : require;

process.env["autorest.home"] = process.env["AUTOREST_HOME"] || process.env["autorest.home"] || homedir();

try {
  rmdirSync(mkdtempSync(join(process.env["autorest.home"], "temp")));
} catch {
  // hmm. the home  directory isn't writable. let's fallback to $tmp
  process.env["autorest.home"] = tmpdir();
}

export const rootFolder = join(process.env["autorest.home"], ".autorest");
const args: AutorestArgs = (<any>global).__args || {};

const pathToYarnCli = inWebpack ? `${__dirname}/yarn/cli.js` : undefined;

export const extensionManager: Promise<ExtensionManager> = ExtensionManager.Create(rootFolder, "yarn", pathToYarnCli);
export const oldCorePackage = "@microsoft.azure/autorest-core";
export const newCorePackage = "@autorest/core";

const basePkgVersion = semver.parse(VERSION.indexOf("-") > -1 ? VERSION.substring(0, VERSION.indexOf("-")) : VERSION)!;

/**
 * The version range of the core package required.
 * Require @autorest/core to have the same major version as autorest.
 */
const versionRange = `^${basePkgVersion.major}.0.0`;

export const networkEnabled: Promise<boolean> = new Promise<boolean>((r, j) => {
  lookup("8.8.8.8", 4, (err, address, family) => {
    r(err ? false : true);
  });
});

export async function availableVersions() {
  if (await networkEnabled) {
    try {
      const vers = (await (await extensionManager).getPackageVersions(newCorePackage)).sort((b, a) =>
        semver.compare(a, b),
      );
      return vers.filter((x) => semver.satisfies(x, versionRange));
    } catch (e) {
      console.info(`No available versions of package ${newCorePackage} found.`);
    }
  } else {
    console.info("Skipping getting available versions because network is not detected.");
  }
  return [];
}

export async function installedCores() {
  const extensions = await (await extensionManager).getInstalledExtensions();
  const result =
    extensions.length > 0
      ? extensions.filter(
          (ext) =>
            (ext.name === newCorePackage || ext.name === oldCorePackage) && semver.satisfies(ext.version, versionRange),
        )
      : [];
  return result.sort((a, b) => semver.compare(b.version, a.version));
}

export async function resolveEntrypoint(localPath: string, entrypoint: string): Promise<string | undefined> {
  try {
    // did they specify the package directory directly
    if (await isDirectory(localPath)) {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const pkg = nodeRequire(`${localPath}/package.json`);
      if (pkg.name === "autorest") {
        // you've tried loading the bootstrapper not the core!
        console.error(`The location you have specified is not autorest-core, it's autorest bootstrapper: ${pkg.name}`);
        process.exit(1);
      }

      if (args.debug) {
        console.log(`Examining AutoRest core package: ${pkg.name}`);
      }

      if (pkg.name === oldCorePackage || pkg.name === newCorePackage) {
        if (args.debug) {
          console.log("Looks like a core package.");
        }
        switch (entrypoint) {
          case "main":
          case "main.js":
            entrypoint = pkg.main;
            break;

          case "language-service":
          case "language-service.js":
          case "autorest-language-service":
            entrypoint = pkg.bin["autorest-language-service"];
            break;

          case "autorest":
          case "autorest-core":
          case "app.js":
          case "app":
            entrypoint = pkg.bin["autorest-core"] || pkg.bin["core"];
            break;

          case "module":
            // special case: look for the main entrypoint
            // but return the module folder
            if (await isFile(`${localPath}/${pkg.main}`)) {
              if (args.debug) {
                console.log(`special case: '${localPath}/${pkg.main}' .`);
              }
              return localPath.replace(/\\/g, "/");
            }
        }
        const path = `${localPath}/${entrypoint}`;
        if (await isFile(path)) {
          if (args.debug) {
            console.log(`Using Entrypoint: '${localPath}/${entrypoint}' .`);
          }
          return path.replace(/\\/g, "/");
        }
      }
    }
  } catch {
    // no worries
  }
  return undefined;
}

export async function runCoreOutOfProc(
  localPath: string,
  entrypoint: string,
  config?: AutorestConfiguration,
): Promise<any> {
  const env = {
    ...process.env,
  };

  if (config?.memory) {
    const maxMemory = parseMemory(config.memory);
    if (maxMemory < 1024) {
      throw new Error("Cannot set memory to be less than 1GB(1024MB)");
    }
    env.NODE_OPTIONS = `${env.NODE_OPTIONS ?? ""} --max_old_space_size=${maxMemory}`;
    console.log(`Setting memory to ${maxMemory}mb for @autorest/core`);
  }
  try {
    const ep = await resolveEntrypoint(localPath, entrypoint);
    if (ep) {
      // Creates the nodejs command to load the target core
      // - copies the argv parameters
      // - loads the js file with coloring (core expects a global function called 'color' )
      //   This is needed currently for @autorest/core version older than 3.6.0(After autorest-core include the color itself.)
      // - loads the actual entrypoint that we expect is there.
      const cmd = `
        process.argv = ${JSON.stringify(process.argv)};
        const { color } = require('${__dirname}/exports');
        global.color = color;
        require('${ep}')
      `
        .replace(/"/g, "'")
        .replace(/(\\(?![']))+/g, "/");

      const p = spawn(process.execPath, ["-e", cmd], { stdio: ["inherit", "inherit", "inherit"], env });
      p.on("close", (code, signal) => {
        process.exit(code ?? -1);
      });
      // set up a promise to wait for the event to fire
      await When(p, "exit", "close");

      process.exit(0);
    }
  } catch (E) {
    console.log(E);
  }
  return null;
}

export async function runCoreWithRequire(
  localPath: string,
  entrypoint: string,
  config?: AutorestConfiguration,
): Promise<any> {
  if (config?.memory) {
    console.warn(
      "Cannot use --memory flag when running in debugging mode. Use NODE_OPTIONS env variable with flag `--max_old_space_size` to set the node max memory.",
    );
  }

  try {
    const ep = await resolveEntrypoint(localPath, entrypoint);
    if (ep) {
      return nodeRequire(ep);
    }
  } catch (E) {
    console.log(E);
  }
  return null;
}

export async function ensureAutorestHome() {
  await mkdir(rootFolder);
}

export async function selectVersion(
  logger: IAutorestLogger,
  requestedVersion: string,
  force: boolean,
  minimumVersion?: string,
): Promise<Extension> {
  const installedVersions = await installedCores();
  let currentVersion: Extension | null = installedVersions[0] || null;

  // the consumer can say I want the latest-installed, but at least XXX.XXX
  if (minimumVersion && currentVersion && !semver.satisfies(currentVersion.version, minimumVersion)) {
    currentVersion = null;
  }

  if (currentVersion) {
    logger.debug(`The most recent installed version is ${currentVersion.version}`);

    if (requestedVersion === "latest-installed" || (requestedVersion === "latest" && false == (await networkEnabled))) {
      logger.debug(`requesting current version '${currentVersion.version}'`);
      requestedVersion = currentVersion.version;
    }
  } else {
    logger.debug(`No ${newCorePackage} (or ${oldCorePackage}) is installed.`);
  }

  let selectedVersion: Extension | null = null;
  // take the highest version that satisfies the version range.
  for (const each of installedVersions.sort((a, b) => semver.compare(a?.version, b?.version))) {
    if (semver.satisfies(each.version, requestedVersion)) {
      selectedVersion = each;
    }
  }

  // is the requested version installed?
  if (!selectedVersion || force) {
    if (!force) {
      logger.debug(`${requestedVersion} was not satisfied directly by a previous installation.`);
    }

    // if it's not a file, and the network isn't available, we can't continue.
    if (!(await isFile(requestedVersion)) && !(await networkEnabled)) {
      // no network enabled.
      throw new Exception(
        `Network access is not available, requested version '${requestedVersion}' is not installed. `,
      );
    }

    // after this point, latest-installed must mean latest.
    if (requestedVersion === "latest-installed") {
      requestedVersion = "latest";
    }

    // if they have requested 'latest' -- they really mean latest with same major version number
    if (requestedVersion === "latest") {
      requestedVersion = versionRange;
    }
    let corePackageName = newCorePackage;

    let pkg: Package | undefined = undefined;
    try {
      // try the package
      pkg = await (await extensionManager).findPackage(newCorePackage, requestedVersion);
    } catch (error) {
      // try a prerelease version from github.
      try {
        const rv = requestedVersion.replace(/^[~|^]/g, "");
        pkg = await (
          await extensionManager
        ).findPackage(
          "core",
          `https://github.com/Azure/autorest/releases/download/autorest-core-${rv}/autorest-core-${rv}.tgz`,
        );
      } catch {
        // fallback to old package name
        try {
          pkg = await (await extensionManager).findPackage(oldCorePackage, requestedVersion);
        } catch {
          // no package found!
        }
      }
      if (!pkg) {
        logger.debug(`Error trying to resolve @autorest/core version ${requestedVersion}: ${error}`);
        throw new Exception(
          `Unable to find a valid AutoRest core package '${newCorePackage}' @ '${requestedVersion}'.`,
        );
      }
      corePackageName = oldCorePackage;
    }
    if (pkg) {
      if (args.debug) {
        console.log(`Selected package: ${pkg.resolvedInfo.rawSpec} => ${pkg.name}@${pkg.version}`);
      }
    }

    // pkg.version == the actual version
    // check if it's installed already.
    selectedVersion = await (await extensionManager).getInstalledExtension(corePackageName, pkg.version);

    if (!selectedVersion || force) {
      // this will throw if there is an issue with installing the extension.
      if (args.debug) {
        console.log(`**Installing package** ${corePackageName}@${pkg.version}\n[This will take a few moments...]`);
      }

      // @autorest/core install too fast and this doesn't look good right now as Yarn doesn't give info fast enough.
      // If we migrate to yarn v2 with the api we might be able to get more info and reenable that
      const progress = logger.startProgress("installing core...");
      selectedVersion = await (
        await extensionManager
      ).installPackage(pkg, force, 5 * 60 * 1000, (status) => {
        progress.update({ ...status });
      });
      progress.stop();

      if (args.debug) {
        console.log(`Extension location: ${selectedVersion.packageJsonPath}`);
      }
    } else {
      if (args.debug) {
        console.log(`AutoRest Core ${pkg.version} is available at ${selectedVersion.modulePath}`);
      }
    }
  }
  return selectedVersion;
}
