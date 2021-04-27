/* eslint-disable no-process-exit */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable no-console */
import "source-map-support/register";

declare const isDebuggerEnabled: boolean;
const cwd = process.cwd();

import chalk from "chalk";
import { newCorePackage, ensureAutorestHome, tryRequire, runCoreOutOfProc } from "./autorest-as-a-service";
import { color } from "./coloring";
import { parseAutorestArgs } from "./args";
import { resetAutorest, showAvailableCoreVersions, showInstalledExtensions } from "./commands";
import { clearTempData } from "./actions";
import { resolveCoreVersion } from "./core-version-utils";
import { VERSION } from "./constants";

const launchCore = isDebuggerEnabled ? tryRequire : runCoreOutOfProc;

// aliases, round one.
if (process.argv.indexOf("--no-upgrade-check") !== -1) {
  process.argv.push("--skip-upgrade-check");
}

if (process.argv.indexOf("--json") !== -1) {
  process.argv.push("--message-format=json");
}

if (process.argv.indexOf("--yaml") !== -1) {
  process.argv.push("--message-format=yaml");
}

const args = parseAutorestArgs(process.argv);
(<any>global).__args = args;

// aliases
args["info"] = args["info"] || args["list-installed"];
args["preview"] = args["preview"] || args["prerelease"];
if (args["v3"] && !args["version"]) {
  // --v3 without --version infers --version:^3.2.0 +
  args["version"] = "^3.2.0";
}

// Suppress the banner if the message-format is set to something other than regular.
if (!args["message-format"] || args["message-format"] === "regular") {
  console.log(
    chalk.green.bold.underline(
      `AutoRest code generation utility [cli version: ${chalk.white.bold(VERSION)}; node: ${chalk.white.bold(
        process.version,
      )}, max-memory: ${
        Math.round(require("v8").getHeapStatistics().heap_size_limit / (1024 * 1024)) & 0xffffffff00
      } MB]`,
    ),
  );
  console.log(color("(C) 2018 **Microsoft Corporation.**"));
  console.log(chalk.blue.bold.underline("https://aka.ms/autorest"));
}

// argument tweakin'
args.info = args.version === "" || (args.version as any) === true || args.info; // show --info if they use unparameterized --version.
const listAvailable: boolean = args["list-available"] || false;

/** Main Entrypoint for AutoRest Bootstrapper */
async function main() {
  try {
    // did they ask for what is available?
    if (listAvailable) {
      process.exit(await showAvailableCoreVersions(args));
    }

    // show what we have.
    if (args.info) {
      process.exit(await showInstalledExtensions(args));
    }

    try {
      /* make sure we have a .autorest folder */
      await ensureAutorestHome();

      if (args.reset || args["clear-temp"]) {
        // clear out all the temp-data too
        await clearTempData();
      }

      // if we have an autorest home folder, --reset may mean something.
      // if it's not there, --reset won't do anything.
      if (args.reset) {
        process.exit(await resetAutorest(args));
      }
    } catch {
      // We have a chance to fail again later if this proves problematic.
    }

    const coreVersionPath = await resolveCoreVersion(args);

    // let's strip the extra stuff from the command line before we require the core module.
    const newArgs: string[] = [];

    for (const each of process.argv) {
      let keep = true;
      for (const discard of [
        "--version",
        "--list-installed",
        "--list-available",
        "--reset",
        "--latest",
        "--latest-release",
        "--runtime-id",
      ]) {
        if (each === discard || each.startsWith(`${discard}=`) || each.startsWith(`${discard}:`)) {
          keep = false;
        }
      }
      if (keep) {
        newArgs.push(each);
      }
    }

    // use this to make the core aware that this run may be legal even without any inputs
    // this is a valid scenario for "preparation calls" to autorest like `autorest --reset` or `autorest --latest`
    if (args.reset || args.latest || args.version == "latest") {
      // if there is *any* other argument left, that's an indicator that the core is supposed to do something
      newArgs.push("--allow-no-input");
    }

    process.argv = newArgs;

    if (args.debug) {
      console.log(`Starting ${newCorePackage} from ${coreVersionPath}`);
    }

    // reset the working folder to the correct place.
    process.chdir(cwd);

    const result = await launchCore(coreVersionPath, "app.js");
    if (!result) {
      throw new Error(`Unable to start AutoRest Core from ${coreVersionPath}`);
    }
  } catch (exception) {
    console.log(chalk.redBright("Failure:"));
    console.error(chalk.bold(exception));
    console.error(chalk.bold((<Error>exception).stack));
    process.exit(1);
  }
}

void main();
