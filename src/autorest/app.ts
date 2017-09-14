#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as asyncIO from "@microsoft.azure/async-io";
import { cli, enhanceConsole } from "@microsoft.azure/console";
import { Extension, ExtensionManager } from "@microsoft.azure/extension";
import { Exception, LazyPromise } from "@microsoft.azure/polyfill";
import * as dns from "dns";
import { homedir } from "os";
import { dirname, join, resolve } from "path";
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
  .option("info", {
    alias: ["list-installed"],
    describe: "display information about the installed version of autorest and it's extensions",
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
  .argv;

const preview: boolean = args.preview;
const home: string = process.env["autorest.home"] || homedir();
process.env["autorest.home"] = home;
console.trace(`.autorest folder location: ${process.env["autorest.home"]}`);
const rootFolder: string = join(home, ".autorest");
const dotnetFolder: string = join(home, ".dotnet");

const basePkgVersion = pkgVersion.indexOf("-") > -1 ? pkgVersion.substring(0, pkgVersion.indexOf("-")) : pkgVersion;

const corePackage = "@microsoft.azure/autorest-core"; // autorest-core"
const versionRange = `^${basePkgVersion}`; // the version range of the core package required.
const extensionManager: Promise<ExtensionManager> = ExtensionManager.Create(rootFolder);

// show --info if they use naked --version.
args.info = (args.version === "") || args.info;

let requestedVersion: string = args.version || (args.latest && "latest") || (args.preview && "preview") || "latest-installed";
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

async function availableVersions() {
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
};

// result = extensions.filter(ext => ext.name === corePackage);

async function showAvailableCores(): Promise<number> {
  let table = "";
  let max = 10;
  for (const v of await availableVersions()) {
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
  return 0;
}

async function showInstalledExtensions(): Promise<number> {
  const extensions = await (await extensionManager).getInstalledExtensions();
  let table = "";
  if (extensions.length > 0) {
    for (const extension of extensions) {
      table += `\n|${extension.name === corePackage ? "core" : "extension"}|${extension.name}|${extension.version}|${extension.location}|`;
    }
  }
  if (table) {
    console.log("# Showing All Installed Extensions\n\n|Type|Extension Name|Version|location|\n|-----|-----|----|" + table + "\n\n");
  } else {
    console.log("# Showing All Installed Extensions\n\n > No Extensions are currently installed.\n\n");
  }
  return 0;
}

async function installedCores() {
  const extensions = await (await extensionManager).getInstalledExtensions();
  const result = (extensions.length > 0) ? extensions.filter(ext => ext.name === corePackage && semver.satisfies(ext.version, versionRange)) : new Array<Extension>();
  return result.sort((a, b) => semver.compare(b.version, a.version));
};

function IsUri(uri: string): boolean {
  return /^([a-z0-9+.-]+):(?:\/\/(?:((?:[a-z0-9-._~!$&'()*+,;=:]|%[0-9A-F]{2})*)@)?((?:[a-z0-9-._~!$&'()*+,;=]|%[0-9A-F]{2})*)(?::(\d*))?(\/(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?|(\/?(?:[a-z0-9-._~!$&'()*+,;=:@]|%[0-9A-F]{2})+(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?)(?:\?((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?(?:#((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?$/i.test(uri);
}

async function main() {

  if (args.help) {
    process.exit(0);
  }

  try {
    // check to see if local installed core is available.
    const localVersion = args.version ? resolve(requestedVersion) : dirname(require.resolve("@microsoft.azure/autorest-core/package.json"));

    // did they specify the package directory directly 
    if (await asyncIO.isDirectory(localVersion)) {
      if (require(`${localVersion}/package.json`).name === corePackage) {
        console.trace(`Using local core from: '${localVersion}'`);
        require(`${localVersion}/dist/app.js`);
        return;
      }
    }

    if (await asyncIO.isFile(localVersion)) {
      // this should try to install the file.
      console.trace(`Found local core package file: '${localVersion}'`);
      requestedVersion = localVersion;
    }
  } catch (e) {

  } // failing that, we'll continue on and see if NPM can do something with the version.

  console.trace(`Network Enabled: ${await networkEnabled}`);

  try {
    await asyncIO.mkdir(rootFolder);
    await asyncIO.mkdir(dotnetFolder);

    if (args.reset) {
      console.trace(`Resetting autorest extension folder '${rootFolder}'`);
      await (await extensionManager).reset();
    }

    // wait for the bootstrapper check to finish.
    await checkBootstrapper;

    // did they ask for what is available?
    if (listAvailable) {
      process.exit(await showAvailableCores());
    }

    // show what we have.
    if (args.info) {
      process.exit(await showInstalledExtensions());
    }

    const installedVersions = await installedCores();
    const currentVersion = From(installedVersions).FirstOrDefault() || null;

    if (currentVersion) {
      console.trace(`The most recent installed version is ${currentVersion.version}`);

      if (requestedVersion === "latest-installed" || (requestedVersion === 'latest' && false == await networkEnabled)) {
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
      if (!await asyncIO.isFile(requestedVersion) && !(await networkEnabled)) {
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
    console.error((<Error>exception).stack)
  }
}

main();


  /*
      // maybe they passed a path or uri to the package.
      if (await asyncIO.isFile(requestedVersion) || IsUri(requestedVersion)) {
        console.trace(`Using package from local or uri path: '${requestedVersion}'`);
        try {
          const pkg = await (await extensionManager).findPackage(corePackage, requestedVersion);

          selectedVersion = From(await (await extensionManager).getInstalledExtensions()).FirstOrDefault(each => each.name === pkg.name && each.version === pkg.version);
          if (selectedVersion) {
            console.trace(`Version ${selectedVersion} is currently installed.`);
            break;
          }

          // try to install and use what they provided.

          console.trace(`Package Info:'${pkg.version}' `);
        } catch (e) {
          // doesn't appear installed or anything, we'll let it get installed.
        }
      }
      // nope -- let's try to get the version requested
      console.trace(`Requested version '${requestedVersion}' is not yet installed.`);
*/
