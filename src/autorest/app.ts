#!/usr/bin/env node

import * as asyncIO from "@microsoft.azure/async-io";
import { cli, enhanceConsole } from "@microsoft.azure/console";
import { Extension, ExtensionManager } from "@microsoft.azure/extension";
import { Exception, LazyPromise } from "@microsoft.azure/polyfill";
import * as dns from "dns";
import { homedir } from "os";
import { dirname, join } from "path";
import { Enumerable as IEnumerable, From } from "./lib/ref/linq";

import * as semver from "semver";

// DANGER!!! THIS SWALLOWS BACKSLASHES!!!
// This cost me ~1h of debugging why "console.log(join(homedir(), ".autorest"));" prints "C:\Users\jobader.autorest"... 
// Or rather left me looking in the wrong place for a file not found error on "C:\Users\jobader.autorest\x\y\z" where the problem was really in "z"
enhanceConsole();

const pkgVersion: string = require(`${__dirname}/../package.json`).version;

// heavy customization, restart from scratch
cli.reset();

console.log(`# AutoRest code generation utility.\n(C) 2017 **Microsoft Corporation.**  \nhttps://aka.ms/autorest`);
const args = cli
  .app("autorest")
  .title("AutoRest code generation utility for OpenAPI")
  .copyright("(C) 2017 **Microsoft Corporation.**")
  .usage("**\nUsage**: autorest [configuration-file.md] [...options]\n\n  See: https://aka.ms/autorest/cli for additional documentation")
  .wrap(0)
  .help("help", "`Show help information`")
  .option("quiet", {
    describe: "`suppress most output information`",
    type: "boolean",
    group: "### Output Verbosity",
  }).option("verbose", {
    describe: "`display verbose logging information`",
    type: "boolean",
    group: "### Output Verbosity",
  })
  .option("debug", {
    describe: "`display debug logging information`",
    type: "boolean",
    group: "### Output Verbosity",
  })
  .option("autorest.show-info", {
    alias: ["list-installed"],
    describe: "display information about the installed version of autorest-core",
    type: "boolean",
    group: "### Informational",
  })
  .option("autorest.list-available", {
    alias: ["list-available"],
    describe: "display available extensions",
    type: "boolean",
    group: "### Informational",
  })
  .option("reset", {
    describe: "removes all autorest extensions and downloads the latest version of the autorest-core extension",
    type: "boolean",
    group: "### Installation",
  })
  .option("preview", {
    alias: "prerelease",
    describe: "enables using autorest extensions that are not yet released",
    type: "boolean",
    group: "### Installation",
  })
  .option("latest", {
    describe: "installs the latest **autorest-core** extension",
    type: "boolean",
    group: "### Installation",
  })
  .option("force", {
    describe: "force the re-installation of the **autorest-core** extension and frameworks",
    type: "boolean",
    group: "### Installation",
  })
  .option("version", {
    describe: "use the specified version of the **autorest-core** extension",
    type: "string",
    group: "### Installation",
  })
  .option("autorest.runtimeId", {
    alias: ["runtimeId"],
    describe: "overrides the runtimeId for the dotnet framework",
    type: "boolean",
    group: "### Installation",
  })
  .option("autorest.home", {
    alias: ["home"],
    describe: `overrides the home folder where autorest and language runtimes are installed (defaults to ${homedir()}`,
    type: "string",
    group: "### Installation",
  })
  .argv;

const preview: boolean = args.preview;
const home: string = args.home || process.env["autorest.home"] || homedir();
process.env["autorest.home"] = home;
console.trace(`Autorest Home folder: ${process.env["autorest.home"]}`);
const rootFolder: string = join(home, ".autorest");
const dotnetFolder: string = join(home, ".dotnet");

const basePkgVersion = pkgVersion.indexOf("-") > -1 ? pkgVersion.substring(0, pkgVersion.indexOf("-")) : pkgVersion;
const maxPkgVersion = `${semver.major(basePkgVersion) + 1}.0.0`

const corePackage = "@microsoft.azure/autorest-core"; // autorest-core"
const versionRange = preview ? `>=${basePkgVersion}-any <${maxPkgVersion}` : `>=${basePkgVersion} <${maxPkgVersion}`; // the version range of the core package required.
const extensionManager: Promise<ExtensionManager> = ExtensionManager.Create(rootFolder);

let currentVersion: Extension = null;
const frameworkVersion: string = null;

let requestedVersion: string = args.version || "latest-installed";
const showInfo: boolean = args.autorest["show-info"] || false;
const listAvailable: boolean = args.autorest["list-available"] || false;
let force = args.force || false;

// get network status
const networkEnabled: Promise<boolean> = new Promise<boolean>((r, j) => {
  dns.lookup("8.8.8.8", 4, (err, address, family) => {
    r(err ? false : true);
  });
});

const checkBootstrapper = new LazyPromise(async () => {
  if (await networkEnabled) {
    try {
      const pkg = await (await extensionManager).findPackage("autorest", preview ? "preview" : "latest");
      if (semver.gt(pkg.version, pkgVersion)) {
        console.log(`\n ## There is a new version of AutoRest available (${pkg.version}).\n > You can install the newer version with with \`npm install -g autorest@${preview ? "preview" : "latest"}\`\n`);
      }
    } catch (e) {
      // no message then.
    }
  }
});

const availableVersions = new LazyPromise(async () => {
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
      console.trace(`No available versions of package ${corePackage} found.`);
    }

  } else {
    console.trace(`Skipping getting available versions because network is not detected.`);
  }
  return [];
});

const installedCores = new LazyPromise(async () => {
  let result = new Array<Extension>();
  let table = "";
  const extensions = await (await extensionManager).getInstalledExtensions();
  if (extensions.length > 0) {
    for (const extension of extensions) {
      // find the autorest-core extension
      const isRelease = !semver.prerelease(extension.version);
      table += `\n|${extension.name}|${extension.version}|${isRelease}|`;
      if (extension.name === corePackage && (preview || isRelease)) {
        result.push(extension);
      }
    }
    if (table) {
      console.trace("# Showing All Installed Extensions\n\n|Extension Name|Version|isRelease|\n|-----|-----|----|" + table + "\n\n.");
    }

    if (result.length === 0) {
      // no stable, but there are preview. return that set.
      result = extensions.filter(ext => ext.name === corePackage);
    }
  }
  return result.sort((a, b) => semver.compare(b.version, a.version));
});

function IsUri(uri: string): boolean {
  return /^([a-z0-9+.-]+):(?:\/\/(?:((?:[a-z0-9-._~!$&'()*+,;=:]|%[0-9A-F]{2})*)@)?((?:[a-z0-9-._~!$&'()*+,;=]|%[0-9A-F]{2})*)(?::(\d*))?(\/(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?|(\/?(?:[a-z0-9-._~!$&'()*+,;=:@]|%[0-9A-F]{2})+(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?)(?:\?((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?(?:#((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?$/i.test(uri);
}

async function main() {

  if (args.help) {
    process.exit(0);
  }

  console.info(`Network Enabled: ${await networkEnabled}`);

  try {
    await asyncIO.mkdir(rootFolder);
    await asyncIO.mkdir(dotnetFolder);

    if (args.reset) {
      console.trace(`Resetting autorest extension folder '${rootFolder}' and  '${dotnetFolder}'`);
      (await extensionManager).reset();
    }

    // wait for the bootstrapper check to finish.
    await checkBootstrapper;

    // did they ask for what is available?
    if (listAvailable) {
      let table = "";
      let max = 10;
      for (const v of await availableVersions) {
        max--;

        if (preview || !semver.prerelease(v)) {
          table += `\n|${corePackage}|${v}|`;
        }
        if (!max) {
          break;
        }
      }

      if (table) {
        console.log("|Extension Name|Version|\n|-----|-----|" + table);
      }
    }

    // 
    if (showInfo) {
      let table = "|Extension Name|Version|\n|-----|-----|";
      for (const ext of await installedCores) {
        table += `\n|${ext.name}|${ext.version}|`;
      }
      console.log(table);
      process.exit(0);
    }

    currentVersion = From(await installedCores).FirstOrDefault() || null;

    if (currentVersion) {
      console.trace(`The most recent installed version is ${currentVersion.version}`);
    } else {
      console.trace(`No ${corePackage} is installed.`);
    }

    if (currentVersion && requestedVersion === "latest-installed") {
      requestedVersion = currentVersion.version;
    }

    let selectedVersion = From(await installedCores).FirstOrDefault(each => each.version === requestedVersion);
    // is the requested version installed?
    while (!selectedVersion || force) {
      // nope -- let's try to get the version requested
      console.trace(`Requested version '${requestedVersion}' is not yet installed.`);

      if (!(await networkEnabled)) {
        // no network enabled.
        throw new Exception(`Network access is not available, requested version '${requestedVersion}' is not installed. `);
      }

      // monikers for the latest version in the list
      if (requestedVersion === "latest" || requestedVersion === "latest-installed") {
        requestedVersion = From(await availableVersions).FirstOrDefault();
      }

      // maybe they passed a path.
      if (await asyncIO.exists(requestedVersion) || IsUri(requestedVersion)) {
        console.trace(`Using package from local path: '${requestedVersion}'`);
        try {
          const pkg = await (await extensionManager).findPackage(corePackage, requestedVersion);

          selectedVersion = From(await (await extensionManager).getInstalledExtensions()).FirstOrDefault(each => each.name === pkg.name && each.version === pkg.version);
          if (selectedVersion) {
            console.trace(`Is Installed allready`);
            break;
          }
          console.trace(`Package Info:'${pkg.version}' `);
        } catch (e) {
          // doesn't appear installed or anything, we'll let it get installed.
        }

      } else {
        requestedVersion = From(await availableVersions).FirstOrDefault(each => semver.satisfies(each, requestedVersion));
      }

      if (!requestedVersion) {
        throw new Exception(`The requested version '${requestedVersion}' is not available.`);
      }

      // this will throw if there is an issue with installing the extension.
      console.log(`**Installing package** ${corePackage}@${requestedVersion}\n[This will take a few moments...]`);

      const pkg = await (await extensionManager).findPackage(corePackage, requestedVersion);
      const extension = await (await extensionManager).installPackage(pkg, force, 5 * 60 * 1000, installer => installer.Message.Subscribe((s, m) => { console.trace(`Installer: ${m}`); }));
      console.trace(`Extension location: ${extension.packageJsonPath}`);

      // select the newly installed version.
      selectedVersion = extension;
      break;
    }

    const RemoveArgs = From<string>(["--version", "--list-installed", "--list-available", "--reset", "--latest", "--latest-release", "--runtime-id"]);
    // Remove bootstrapper args from cmdline
    process.argv = From<string>(process.argv).Where(each => !RemoveArgs.Any(i => each === i || each.startsWith(`${i}=`) || each.startsWith(`${i}:`))).ToArray();

    // use this to make the core aware that this run may be legal even without any inputs
    // this is a valid scenario for "preparation calls" to autorest like `autorest --reset` or `autorest --latest`
    if (args.reset || args.latest) {
      // if there is *any* other argument left, that's an indicator that the core is supposed to do something
      process.argv.push("--allow-no-input");
    }

    console.trace(`Starting ${corePackage} from ${await selectedVersion.location}`);
    require(join(await selectedVersion.modulePath, "dist/app.js"));
  } catch (exception) {
    console.log("Failure:");
    console.error(exception);
  }
}

main();