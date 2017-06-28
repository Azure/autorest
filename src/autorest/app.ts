#!/usr/bin/env node

import * as asyncIO from "@microsoft.azure/async-io";
import { cli, enhanceConsole } from "@microsoft.azure/console";
import { Extension, ExtensionManager } from "@microsoft.azure/extension";
import { Exception, LazyPromise } from "@microsoft.azure/polyfill";
import * as dns from "dns";
import { homedir } from "os";
import { dirname, join } from "path";
import { Enumerable as IEnumerable, From, FromAsync } from "./lib/ref/linq";

import * as semver from "semver";

enhanceConsole();

const rootFolder: string = join(homedir(), ".autorest");
const dotnetFolder: string = join(homedir(), ".dotnet");

const corePackage = "autorest-core"; // autorest-core"
const minimumVersion = "^2.0.0"; // the minimum version of the core package required.
const extensionManager: Promise<ExtensionManager> = ExtensionManager.Create(rootFolder);

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
  .argv;

let currentVersion: Extension = null;
const frameworkVersion: string = null;
const preview: boolean = args.preview;
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

async function info(): Promise<string> {
  return `> __Build Information__
> Autorest :  __${pkgVersion}__
> NetCore framework :      __${frameworkVersion || "<none>"}__`;
}

const checkBootstrapper = new LazyPromise(async () => {
  if (await networkEnabled) {
    const pkg = await (await extensionManager).findPackage("autorest", preview ? "preview" : "latest");
    if (semver.gt(pkg.version, pkgVersion)) {
      console.log(`\n ## There is a new version of AutoRest available (${pkg.version}).\n > You can install the newer version with with \`npm install -g autorest@${preview ? "preview" : "latest"}\`\n`);
    }
  }
});

const availableVersions = new LazyPromise(async () => {
  if (await networkEnabled) {
    try {
      const vers = (await (await extensionManager).getPackageVersions(corePackage)).sort((b, a) => semver.compare(a, b));
      if (preview) {
        return vers;
      }
      const result = new Array<string>();
      for (const ver of vers) {
        if (!semver.prerelease(ver)) {
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
  const result = new Array<Extension>();
  for (const extension of await (await extensionManager).getInstalledExtensions()) {
    // find the autorest-core extension
    const isRelease = !semver.prerelease(extension.version);
    if (extension.name === corePackage && (preview || isRelease)) {
      result.push(extension);
    }
  }
  return result.sort((a, b) => semver.compare(b.version, a.version));
});

export function IsUri(uri: string): boolean {
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
      force = true;

      try {
        await asyncIO.rmdir(rootFolder);
      } catch (e) {
        // who cares
      }
      try {
        await asyncIO.rmdir(dotnetFolder);
      } catch (e) {
        // who cares
      }

      await asyncIO.mkdir(rootFolder);
      await asyncIO.mkdir(dotnetFolder);
    }

    await checkBootstrapper;

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

    if (showInfo) {
      let table = "|Extension Name|Version|\n|-----|-----|";
      for (const ext of await installedCores) {
        table += `\n|${ext.name}|${ext.version}|`;
      }
      console.log(table);
      process.exit(0);
    }

    currentVersion = From(await installedCores).FirstOrDefault() || null;

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
      if (await asyncIO.isFile(requestedVersion) || IsUri(requestedVersion)) {
        console.trace(`Using package from local path: '${requestedVersion}'`);
        try {
          const pkg = await (await extensionManager).findPackage(corePackage, requestedVersion);

          selectedVersion = From(await (await extensionManager).getInstalledExtensions()).FirstOrDefault(each => each.version === pkg.version);
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
      console.log(`**Installing package** ${corePackage}-${requestedVersion}\n[This will take a few moments...]`);

      const pkg = await (await extensionManager).findPackage(corePackage, requestedVersion);
      const installer = (await extensionManager).installPackage(pkg, force);
      installer.Message.Subscribe((s, m) => { console.trace(`Installer: ${m}`); });
      const extension = await installer;
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

    console.trace(`Starting ${corePackage} from ${await selectedVersion.name}`)
    require(join(await selectedVersion.modulePath, "dist/app.js"));
  } catch (exception) {
    console.log("outch");
    console.error(exception);
  }
}

main();
