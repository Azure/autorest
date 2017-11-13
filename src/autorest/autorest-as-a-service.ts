
import { lookup } from "dns";
import { Extension, ExtensionManager } from "@microsoft.azure/extension";
import { homedir } from "os";
import { dirname, join, resolve } from "path";
import { Enumerable as IEnumerable, From } from "linq-es2015";
import { Exception, LazyPromise } from "@microsoft.azure/tasks";

import * as semver from "semver";
import { isFile, mkdir, isDirectory } from "@microsoft.azure/async-io";

export const pkgVersion: string = require(`${__dirname}/../package.json`).version;
const home: string = process.env["autorest.home"] || homedir();
process.env["autorest.home"] = home;

export const rootFolder: string = join(home, ".autorest");

export const extensionManager: Promise<ExtensionManager> = ExtensionManager.Create(rootFolder);
export const corePackage = "@microsoft.azure/autorest-core"; // autorest-core"
const basePkgVersion = pkgVersion.indexOf("-") > -1 ? pkgVersion.substring(0, pkgVersion.indexOf("-")) : pkgVersion;
const versionRange = `^${basePkgVersion}`; // the version range of the core package required.

export const networkEnabled: Promise<boolean> = new Promise<boolean>((r, j) => {
  lookup("8.8.8.8", 4, (err, address, family) => {
    r(err ? false : true);
  });
});

export async function availableVersions() {
  if (await networkEnabled) {
    try {
      const vers = (await (await extensionManager).getPackageVersions(corePackage)).sort((b, a) => semver.compare(a, b));
      const result = new Array<string>();
      for (const ver of vers) {
        if (semver.satisfies(ver, versionRange)) {
          result.push(ver);
        }
      }
      return result;
    } catch (e) {
      console.info(`No available versions of package ${corePackage} found.`);
    }

  } else {
    console.info(`Skipping getting available versions because network is not detected.`);
  }
  return [];
};


export async function installedCores() {
  const extensions = await (await extensionManager).getInstalledExtensions();
  const result = (extensions.length > 0) ? extensions.filter(ext => ext.name === corePackage && semver.satisfies(ext.version, versionRange)) : new Array<Extension>();
  return result.sort((a, b) => semver.compare(b.version, a.version));
};

export function resolvePathForLocalVersion(requestedVersion: string | null): string | null {
  try {
    return requestedVersion ? resolve(requestedVersion) : dirname(require.resolve("@microsoft.azure/autorest-core/package.json"));
  } catch (e) {

  }
  return null;
}

export async function tryRequire(localPath: string | null, entrypoint: string): Promise<any> {
  try {
    return require(await resolveEntrypoint(localPath, entrypoint))
  } catch{ }
  return null;
}

export async function resolveEntrypoint(localPath: string | null, entrypoint: string): Promise<string | null> {
  try {
    // did they specify the package directory directly 
    if (await isDirectory(localPath)) {
      const pkg = require(`${localPath}/package.json`);

      if (pkg.name === corePackage) {
        switch (entrypoint) {
          case 'main':
          case 'main.js':
            entrypoint = pkg.main;
            break;

          case 'language-service':
          case 'language-service.js':
          case 'autorest-language-service':
            entrypoint = pkg.bin["autorest-language-service"];
            break;

          case 'autorest':
          case 'autorest-core':
          case 'app.js':
          case 'app':
            entrypoint = pkg.bin["autorest-core"];
            break;

          case 'module':
            // special case: look for the main entrypoint
            // but return the module folder
            if (await isFile(`${localPath}/${pkg.main}`)) {
              return localPath;
            }
        }
        const path = `${localPath}/${entrypoint}`;
        if (await isFile(path)) {
          return path;
        }
      }
    }
  } catch (e) {
  }
  return null;
}

export async function ensureAutorestHome() {
  await mkdir(rootFolder);
}

export async function selectVersion(requestedVersion: string, force: boolean, minimumVersion?: string) {
  const installedVersions = await installedCores();
  let currentVersion = From(installedVersions).FirstOrDefault() || null;

  // the consumer can say I want the latest-installed, but at least XXX.XXX
  if (minimumVersion && currentVersion && !semver.satisfies(currentVersion.version, minimumVersion)) {
    currentVersion = null;
  }

  if (currentVersion) {
    console.trace(`The most recent installed version is ${currentVersion.version}`);

    if (requestedVersion === "latest-installed" || (requestedVersion === 'latest' && false == await networkEnabled)) {
      console.trace(`requesting current version '${currentVersion.version}'`);
      requestedVersion = currentVersion.version;
    }
  } else {
    console.trace(`No ${corePackage} is installed.`);
  }

  let selectedVersion = From(installedVersions).FirstOrDefault(each => semver.satisfies(each.version, requestedVersion));

  // is the requested version installed?
  if (!selectedVersion || force) {
    if (!force) {
      console.trace(`${requestedVersion} was not satisfied directly by a previous installation.`);
    }

    // if it's not a file, and the network isn't available, we can't continue.
    if (!await isFile(requestedVersion) && !(await networkEnabled)) {
      // no network enabled.
      throw new Exception(`Network access is not available, requested version '${requestedVersion}' is not installed. `);
    }

    // after this point, latest-installed must mean latest.
    if (requestedVersion === 'latest-installed') {
      requestedVersion = 'latest';
    }

    // if they have requested 'latest' -- they really mean latest with same major version number
    if (requestedVersion === 'latest') {
      requestedVersion = versionRange;
    }

    const pkg = await (await extensionManager).findPackage(corePackage, requestedVersion);
    if (pkg) {
      console.trace(`Selected package: ${pkg.name}@${pkg.version} => ${pkg.resolvedInfo.rawSpec} `);
    } else {
      throw new Exception(`Unable to find a valid AutoRest Core package for '${requestedVersion}'.`);
    }

    // pkg.version == the actual version 
    // check if it's installed already.
    selectedVersion = await (await extensionManager).getInstalledExtension(corePackage, pkg.version);

    if (!selectedVersion || force) {
      // this will throw if there is an issue with installing the extension.
      console.trace(`**Installing package** ${corePackage}@${pkg.version}\n[This will take a few moments...]`);

      selectedVersion = await (await extensionManager).installPackage(pkg, force, 5 * 60 * 1000, installer => installer.Message.Subscribe((s, m) => { console.trace(`Installer: ${m}`); }));
      console.trace(`Extension location: ${selectedVersion.packageJsonPath}`);
    } else {
      console.trace(`AutoRest Core ${pkg.version} is available at ${selectedVersion.modulePath}`);
    }
  }
  return selectedVersion;
}