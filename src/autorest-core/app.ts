#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// start of autorest-ng
// the console app starts for real here.

// this file should get 'required' by the boostrapper

import { resolve as currentDirectory } from "path";
import { ChildProcess } from "child_process";
import { CreateFileUri, ResolveUri } from "./lib/ref/uri";
import { SpawnLegacyAutoRest } from "./interop/autorest-dotnet";
import { isLegacy, CreateConfiguration } from "./legacyCli";
import { AutoRestConfigurationSwitches, ConstantConfiguration, FileSystemConfiguration } from "./lib/configuration";
import { DataStore } from "./lib/data-store/data-store";
import { RunPipeline } from "./lib/pipeline/pipeline";
import { RealFileSystem } from "./lib/file-system";


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
  if (autorestArgs.indexOf("-FANCY") !== -1) {
    // generate virtual config file
    const currentDirUri = CreateFileUri(currentDirectory()) + "/";
    const configFileUri = ResolveUri(currentDirUri, "virtual-config.yaml");
    const dataStore = new DataStore();
    const config = await CreateConfiguration(currentDirUri, dataStore.CreateScope("input").AsFileScopeReadThrough(x => true /*unsafe*/), autorestArgs);
    const restultStreams = await RunPipeline(await new ConstantConfiguration(configFileUri, config).CreateView());



  }
  else {
    // exec
    const autorestExe = SpawnLegacyAutoRest(autorestArgs);
    autorestExe.stdout.pipe(process.stdout);
    autorestExe.stderr.pipe(process.stderr);
    const exitCode = await awaitable(autorestExe);
    process.exit(exitCode);
  }
}


/**
 * Current AutoRest
 */

type CommandLineArgs = { configFile?: string, switches: AutoRestConfigurationSwitches };

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

  return result;
}

async function currentMain(autorestArgs: string[]): Promise<void> {
  const args = parseArgs(autorestArgs);
  const currentDirUri = CreateFileUri(currentDirectory()) + "/";
  await RunPipeline(await new FileSystemConfiguration(new RealFileSystem(currentDirUri), args.configFile).CreateView(args.switches));
}


/**
 * Entry point
 */

async function main() {
  try {
    const autorestArgs = process.argv.slice(2);

    // temporary: --help displays legacy AutoRest's -Help message
    if (autorestArgs.indexOf("--help") !== -1) {
      await legacyMain(["-Help"]);
      return;
    }

    if (isLegacy(autorestArgs)) {
      await legacyMain(autorestArgs);
    } else {
      await currentMain(autorestArgs);
    }
    process.exit(0);
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
}

main();