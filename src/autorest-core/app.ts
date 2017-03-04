#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// start of autorest-ng
// the console app starts for real here.

// this file should get 'required' by the boostrapper

import { resolve as currentDirectory } from "path";
import { existsSync } from "fs";
import { ChildProcess } from "child_process";
import { createFileUri, resolveUri } from "./lib/approved-imports/uri";
import { spawnLegacyAutoRest } from "./interop/autorest-dotnet";
import { isLegacy } from "./legacyCli";
import { AutoRestConfigurationSwitches } from "./lib/configuration/configuration";
import { run } from "./index";


/**
 * Legacy AutoRest
 */

function awaitable(child: ChildProcess): Promise<number> {
  return new Promise((resolve, reject) => {
    child.addListener("error", reject);
    child.addListener("exit", resolve);
  });
}

async function legacyMain(autorestArgs: string[]): Promise<void> {
  const autorestExe = spawnLegacyAutoRest(autorestArgs);
  autorestExe.stdout.pipe(process.stdout);
  autorestExe.stderr.pipe(process.stderr);
  const exitCode = await awaitable(autorestExe);
  process.exit(exitCode);
}


/**
 * Current AutoRest
 */

type CommandLineArgs = { configFile?: string, switches: AutoRestConfigurationSwitches };

const defaultConfigurationFileName = "readme.md";

function parseArgs(autorestArgs: string[]): CommandLineArgs {
  const result: CommandLineArgs = {
    switches: {}
  };

  for (const arg of autorestArgs) {
    const match = /^--([^=]+)(=([^=]+))?$/g.exec(arg);

    // configuration file?
    if (match === null) {
      if (result.configFile) {
        throw new Error(`Found multiple configuration file arguments: '${result.configFile}', '${arg}'`);
      }
      result.configFile = arg;
      continue;
    }

    // switch
    const key = match[1];
    const value = match[3];
    if (result.switches[key] !== undefined) {
      throw new Error(`Multiple definitions of switch '${key}': '${result.switches[key]}', 'value'`);
    }
    result.switches[key] = value === undefined ? null : value;
  }

  // default configuration file
  if (!result.configFile && existsSync(defaultConfigurationFileName)) {
    result.configFile = defaultConfigurationFileName;
  }

  return result;
}

async function currentMain(autorestArgs: string[]): Promise<void> {
  const args = parseArgs(autorestArgs);
  if (!args.configFile) {
    throw new Error(`No configuration file specified and default ('${defaultConfigurationFileName}') not found`);
  }

  // resolve configuration file
  const currentDirUri = createFileUri(currentDirectory()) + "/";
  const configFileUri = resolveUri(currentDirUri, args.configFile);

  // dispatch
  await run(configFileUri, async () => { });
}


/**
 * Entry point
 */

async function main() {
  try {
    const autorestArgs = process.argv.slice(2);
    if (isLegacy(autorestArgs)) {
      await legacyMain(autorestArgs);
    } else {
      await currentMain(autorestArgs);
    }
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
}

main();