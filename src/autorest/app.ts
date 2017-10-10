#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
if (process.argv.indexOf("--no-static-loader") == -1) {
  require("./static-loader").initialize();
}

if (process.argv.indexOf("--no-upgrade-check") != -1) {
  process.argv.push("--skip-upgrade-check");
}

import { isFile } from "@microsoft.azure/async-io";
import { cli, enhanceConsole } from "@microsoft.azure/console";
import { Exception, LazyPromise } from "@microsoft.azure/polyfill";
import { Enumerable as IEnumerable, From } from "./lib/ref/linq";
import { networkEnabled, rootFolder, extensionManager, availableVersions, corePackage, installedCores, tryRequire, resolvePathForLocalVersion, ensureAutorestHome, selectVersion, pkgVersion } from "./autorest-as-a-service"
import { gt } from "semver";

// Caution: This may swallow backslashes.
// This cost me ~1h of debugging why "console.log(join(homedir(), ".autorest"));" prints "C:\Users\jobader.autorest"... 
// Or rather left me looking in the wrong place for a file not found error on "C:\Users\jobader.autorest\x\y\z" where the problem was really in "z"
enhanceConsole();

// heavy customization, restart from scratch
cli.reset();

// Suppress the banner if in json mode.
if (process.argv.indexOf("--json") == -1 && process.argv.indexOf("--message-format=json") == -1) {
  console.log(`# AutoRest code generation utility [version: ${pkgVersion}]\n(C) 2017 **Microsoft Corporation.**  \nhttps://aka.ms/autorest`);
}
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
  .option("json", {
    describe: "ouptut messages as json",
    type: "boolean",
    group: "### Informational",
  })
  .option("list-available", {
    describe: "display available extensions",
    type: "boolean",
    group: "### Informational",
  })
  .option("skip-upgrade-check", {
    describe: "disable check for new version of bootstrapper",
    type: "boolean",
    default: false,
    group: "### Installation",
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

// argument tweakin'
const preview: boolean = args.preview;
args.info = (args.version === "") || args.info; // show --info if they use unparameterized --version.
let requestedVersion: string = args.version || (args.latest && "latest") || (args.preview && "preview") || "latest-installed";
const listAvailable: boolean = args["list-available"] || false;
let force = args.force || false;

/** Check if there is an update for the bootstrapper available. */
const checkBootstrapper = new LazyPromise(async () => {
  if (await networkEnabled && !args['skip-upgrade-check']) {
    try {
      const pkg = await (await extensionManager).findPackage("autorest", preview ? "preview" : "latest");
      if (gt(pkg.version, pkgVersion)) {
        console.log(`\n ## There is a new version of AutoRest available (${pkg.version}).\n > You can install the newer version with with \`npm install -g autorest@${preview ? "preview" : "latest"}\`\n`);
      }
    } catch (e) {
      // no message then.
    }
  }
});

/** Shows the valid available autorest core packages. */
async function showAvailableCores(): Promise<number> {
  let table = "";
  let max = 10;
  const cores = await availableVersions();
  for (const v of cores) {
    max--;
    table += `\n|${corePackage}|${v}|`;
    if (!max) {
      break;
    }
  }
  if (args.json) {
    console.log(JSON.stringify(cores, null, "  "));
  } else {
    if (table) {
      console.log("|Extension Name|Version|\n|-----|-----|" + table);
    }
  }
  return 0;
}

/** Shows all the autorest extensions that are installed. */
async function showInstalledExtensions(): Promise<number> {
  const extensions = await (await extensionManager).getInstalledExtensions();
  let table = "";
  if (extensions.length > 0) {
    for (const extension of extensions) {
      table += `\n|${extension.name === corePackage ? "core" : "extension"}|${extension.name}|${extension.version}|${extension.location}|`;
    }
  }
  if (args.json) {
    console.log(JSON.stringify(extensions, null, "  "));
  } else {
    if (table) {
      console.log("# Showing All Installed Extensions\n\n|Type|Extension Name|Version|location|\n|-----|-----|----|" + table + "\n\n");
    } else {
      console.log("# Showing All Installed Extensions\n\n > No Extensions are currently installed.\n\n");
    }
  }
  return 0;
}

/** Main Entrypoint for AutoRest Bootstrapper */
async function main() {

  if (args.json) {
    process.argv.push("--message-format=json");
  }

  // did they ask for what is available?
  if (listAvailable) {
    process.exit(await showAvailableCores());
  }

  // show what we have.
  if (args.info) {
    process.exit(await showInstalledExtensions());
  }

  if (args.help) {
    // yargs will print the help. We can leave now.
    process.exit(0);
  }

  // check to see if local installed core is available.
  const localVersion = resolvePathForLocalVersion(args.version && args.version !== '' ? requestedVersion : null);

  // try to use a specified folder or one in node_modules if it is there.
  if (await tryRequire(localVersion, "app.js")) {
    return;
  }

  // if the resolved local version is actually a file, we'll try that as a package when we get there.
  if (await isFile(localVersion)) {
    // this should try to install the file.
    console.trace(`Found local core package file: '${localVersion}'`);
    requestedVersion = localVersion;
  }

  // failing that, we'll continue on and see if NPM can do something with the version.
  console.trace(`Network Enabled: ${await networkEnabled}`);

  try {
    /* make sure we have a .autorest folder */
    await ensureAutorestHome();

    if (args.reset) {
      console.trace(`Resetting autorest extension folder '${rootFolder}'`);
      await (await extensionManager).reset();
    }

    // wait for the bootstrapper check to finish.
    await checkBootstrapper;


    // logic to resolve and optionally install a autorest core package.
    // will throw if it's not doable.
    let selectedVersion = await selectVersion(requestedVersion, force);

    // let's strip the extra stuff from the command line before we require the core module.
    const RemoveArgs = From<string>(["--version", "--list-installed", "--list-available", "--reset", "--latest", "--latest-release", "--runtime-id"]);
    // Remove bootstrapper args from cmdline
    process.argv = From<string>(process.argv).Where(each => !RemoveArgs.Any(i => each === i || each.startsWith(`${i}=`) || each.startsWith(`${i}:`))).ToArray();

    // use this to make the core aware that this run may be legal even without any inputs
    // this is a valid scenario for "preparation calls" to autorest like `autorest --reset` or `autorest --latest`
    if (args.reset || args.latest || args.version == 'latest') {
      // if there is *any* other argument left, that's an indicator that the core is supposed to do something
      process.argv.push("--allow-no-input");
    }

    console.trace(`Starting ${corePackage} from ${await selectedVersion.location}`);
    if (!tryRequire(await selectedVersion.modulePath, "app.js")) {
      throw new Error(`Unable to start AutoRest Core from ${await selectedVersion.modulePath}`);
    }
  } catch (exception) {
    console.log("Failure:");
    console.error(exception);
    console.error((<Error>exception).stack);
    process.exit(1);
  }
}

main();
