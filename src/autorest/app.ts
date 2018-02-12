#!/usr/bin/env node
// load modules from static linker filesystem.
if (process.argv.indexOf("--no-static-loader") === -1 && process.env["no-static-loader"] === undefined) {
  require('./static-loader.js').load(`${__dirname}/static_modules.fs`)
}
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

const cwd = process.cwd();

// https://github.com/uxitten/polyfill/blob/master/string.polyfill.js
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padEnd
if (!String.prototype.padEnd) {
  String.prototype.padEnd = function padEnd(targetLength, padString) {
    targetLength = targetLength >> 0; //floor if number or convert non-number to 0;
    padString = String(padString || ' ');
    if (this.length > targetLength) {
      return String(this);
    }
    else {
      targetLength = targetLength - this.length;
      if (targetLength > padString.length) {
        padString += padString.repeat(targetLength / padString.length); //append to original to ensure we are longer than needed
      }
      return String(this) + padString.slice(0, targetLength);
    }
  };
}

import { isFile } from "@microsoft.azure/async-io";
import { Exception, LazyPromise } from "@microsoft.azure/tasks";
import { networkEnabled, rootFolder, extensionManager, availableVersions, corePackage, installedCores, tryRequire, resolvePathForLocalVersion, ensureAutorestHome, selectVersion, pkgVersion } from "./autorest-as-a-service"
import { gt } from "semver";
import { join } from "path";
import { color } from "./coloring"
import chalk from "chalk"

// aliases, round one.
if (process.argv.indexOf("--no-upgrade-check") != -1) {
  process.argv.push("--skip-upgrade-check");
}

if (process.argv.indexOf("--json") !== -1) {
  process.argv.push("--message-format=json");
}

if (process.argv.indexOf("--yaml") !== -1) {
  process.argv.push("--message-format=yaml");
}

function parseArgs(autorestArgs: string[]): any {
  const result: any = {};
  for (const arg of autorestArgs) {
    const match = /^--([^=:]+)([=:](.+))?$/g.exec(arg);
    if (match) {
      const key = match[1];
      let rawValue = match[3] || "true";
      if (rawValue.startsWith('.')) {
        // starts with a . or .. -> this is a relative path to current directory
        rawValue = join(cwd, rawValue);
      }

      let value;
      try {
        value = JSON.parse(rawValue);
        // restrict allowed types (because with great type selection comes great responsibility)
        if (typeof value !== "string" && typeof value !== "boolean") {
          value = rawValue;
        }
      } catch (e) {
        value = rawValue;
      }
      result[key] = value;
    }
  }
  return result;
}

const args = parseArgs(process.argv);
(<any>global).__args = args;

// aliases
args["info"] = args["info"] || args["list-installed"];
args["preview"] = args["preview"] || args["prerelease"];

// Suppress the banner if the message-format is set to something other than regular.
if ((!args["message-format"]) || args["message-format"] === "regular") {
  console.log(chalk.green.bold.underline(`AutoRest code generation utility [version: ${chalk.white.bold(pkgVersion)}; node: ${chalk.white.bold(process.version)}]`));
  console.log(color(`(C) 2018 **Microsoft Corporation.**`));
  console.log(chalk.blue.bold.underline(`https://aka.ms/autorest`));
}

// argument tweakin'
const preview: boolean = args.preview;
args.info = (args.version === "" || args.version === true) || args.info; // show --info if they use unparameterized --version.
const listAvailable: boolean = args["list-available"] || false;
let force = args.force || false;

/** Check if there is an update for the bootstrapper available. */
const checkBootstrapper = new LazyPromise(async () => {
  if (await networkEnabled && !args['skip-upgrade-check']) {
    try {
      const pkg = await (await extensionManager).findPackage("autorest", preview ? "preview" : "latest");
      if (gt(pkg.version, pkgVersion)) {
        console.log(color(`\n## There is a new version of AutoRest available (${pkg.version}).\n > You can install the newer version with with \`npm install -g autorest@${preview ? "preview" : "latest"}\`\n`));
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
    table += `\n ${chalk.cyan.bold(corePackage.padEnd(30, ' '))} ${chalk.grey.bold(v.padEnd(14, ' '))} `;
    if (!max) {
      break;
    }
  }
  if (args.json) {
    console.log(JSON.stringify(cores, null, "  "));
  } else {
    if (table) {
      console.log(`${chalk.green.bold.underline(' Extension Name'.padEnd(30, ' '))}  ${chalk.green.bold.underline('Version'.padEnd(14, ' '))}\n${table}`);
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

      table += `\n ${chalk.cyan((extension.name === corePackage ? "core" : "extension").padEnd(10))} ${chalk.cyan.bold(extension.name.padEnd(40))} ${chalk.cyan(extension.version.padEnd(12))} ${chalk.cyan(extension.location)}`;
    }
  }
  if (args.json) {
    console.log(JSON.stringify(extensions, null, "  "));
  } else {
    if (table) {
      console.log(color(`\n\n# Showing All Installed Extensions\n\n ${chalk.underline('Type'.padEnd(10))} ${chalk.underline('Extension Name'.padEnd(40))} ${chalk.underline('Version'.padEnd(12))} ${chalk.underline('Location')} ${table}\n\n`));
    } else {
      console.log(color("\n\n# Showing All Installed Extensions\n\n > No Extensions are currently installed.\n\n"));
    }
  }
  return 0;
}

/** Main Entrypoint for AutoRest Bootstrapper */
async function main() {
  try {
    // did they ask for what is available?
    if (listAvailable) {
      process.exit(await showAvailableCores());
    }

    // show what we have.
    if (args.info) {
      process.exit(await showInstalledExtensions());
    }

    try {
      /* make sure we have a .autorest folder */
      await ensureAutorestHome();

      // if we have an autorest home folder, --reset may mean something. 
      // if it's not there, --reset won't do anything. 
      if (args.reset) {
        if (args.debug) {
          console.log(`Resetting autorest extension folder '${rootFolder}'`);
        }
        try {
          await (await extensionManager).reset();
        } catch (e) {
          console.log(color("\n\n## The AutoRest extension folder appears to be locked.\nDo you have a process that is currently using AutoRest (perhaps the vscode extension?).\n\nUnable to reset the extension folder, exiting."));
          process.exit(10);
        }
      }
    }
    catch {
      // We have a chance to fail again later if this proves problematic.
    }

    let requestedVersion: string = args.version || (args.latest && "latest") || (args.preview && "preview") || "latest-installed";

    // check to see if local installed core is available.
    const localVersion = resolvePathForLocalVersion(args.version ? requestedVersion : null);

    // try to use a specified folder or one in node_modules if it is there.
    process.chdir(cwd);
    if (await tryRequire(localVersion, "app.js")) {
      return;
    }

    // if the resolved local version is actually a file, we'll try that as a package when we get there.
    if (await isFile(localVersion)) {
      // this should try to install the file.
      if (args.debug) {
        console.log(`Found local core package file: '${localVersion}'`);
      }
      requestedVersion = localVersion;
    }

    // failing that, we'll continue on and see if NPM can do something with the version.
    if (args.debug) {
      console.log(`Network Enabled: ${await networkEnabled}`);
    }

    // wait for the bootstrapper check to finish.
    await checkBootstrapper;

    // logic to resolve and optionally install a autorest core package.
    // will throw if it's not doable.
    let selectedVersion = await selectVersion(requestedVersion, force);

    // let's strip the extra stuff from the command line before we require the core module.
    const oldArgs = process.argv;
    const newArgs = new Array<string>();

    for (const each of process.argv) {
      let keep = true;
      for (const discard of ["--version", "--list-installed", "--list-available", "--reset", "--latest", "--latest-release", "--runtime-id"]) {
        if (each === discard || each.startsWith(`${discard}=`) || each.startsWith(`${discard}:`)) {
          keep = false;
        }
      }
      if (keep) {
        newArgs.push(each);
      }
    }
    process.argv = newArgs;

    // use this to make the core aware that this run may be legal even without any inputs
    // this is a valid scenario for "preparation calls" to autorest like `autorest --reset` or `autorest --latest`
    if (args.reset || args.latest || args.version == 'latest') {
      // if there is *any* other argument left, that's an indicator that the core is supposed to do something
      process.argv.push("--allow-no-input");
    }

    if (args.debug) {
      console.log(`Starting ${corePackage} from ${await selectedVersion.location}`);
    }
    process.chdir(cwd);
    const result = await tryRequire(await selectedVersion.modulePath, "app.js");

    if( !result ) {
      throw new Error(`Unable to start AutoRest Core from ${await selectedVersion.modulePath}`);
    }
    console.log(chalk.redBright(`FATAL: AutoRest exited unexpectedly after launching autorest-core module ${corePackage} from ${await selectedVersion.location}`));
  } catch (exception) {
    console.log(chalk.redBright("Failure:"));
    console.error(chalk.bold(exception));
    console.error(chalk.bold((<Error>exception).stack));
    process.exit(1);
  }
}

main();
