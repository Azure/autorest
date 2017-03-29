#!/usr/bin / env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// start of autorest-ng
// the console app starts for real here.

// this file should get 'required' by the boostrapper

import { CreateObject, parse } from "./lib/ref/jsonpath";
import { OutstandingTaskAwaiter } from "./lib/outstanding-task-awaiter";
import { AutoRest } from "./lib/autorest-core";
import { resolve as currentDirectory } from "path";
import { ChildProcess } from "child_process";
import { CreateFolderUri, ResolveUri, WriteString } from "./lib/ref/uri";
import { SpawnLegacyAutoRest } from "./interop/autorest-dotnet";
import { isLegacy, CreateConfiguration } from "./legacyCli";
import { DataStore } from "./lib/data-store/data-store";
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
    const currentDirUri = CreateFolderUri(currentDirectory());
    const dataStore = new DataStore();
    const config = await CreateConfiguration(currentDirUri, dataStore.CreateScope("input").AsFileScopeReadThrough(x => true /*unsafe*/), autorestArgs);
    config["base-folder"] = currentDirUri;
    const api = new AutoRest(new RealFileSystem());
    await api.AddConfiguration(config);
    const outstanding = new OutstandingTaskAwaiter();
    api.GeneratedFile.Subscribe((_, file) => outstanding.Await(WriteString(file.uri, file.content)));
    //api.Debug.Subscribe((_, m) => console.log(m.Text));
    //api.Verbose.Subscribe((_, m) => console.log(m.Text));
    api.Information.Subscribe((_, m) => console.log(m.Text));
    api.Warning.Subscribe((_, m) => console.warn(m.Text));
    api.Error.Subscribe((_, m) => console.error(m.Text));
    api.Fatal.Subscribe((_, m) => console.error(m.Text));
    await api.Process().finish; // TODO: care about return value?
    await outstanding.Wait();
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

type CommandLineArgs = { configFile?: string, switches: any[] };

function parseArgs(autorestArgs: string[]): CommandLineArgs {
  const result: CommandLineArgs = {
    switches: []
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
    const value = match[3] || null;
    result.switches.push(CreateObject(key.split("."), value));
  }

  return result;
}

async function currentMain(autorestArgs: string[]): Promise<void> {
  const args = parseArgs(autorestArgs);
  const currentDirUri = CreateFolderUri(currentDirectory());
  const api = new AutoRest(new RealFileSystem(), ResolveUri(currentDirUri, args.configFile || "."));
  args.switches.forEach(s => api.AddConfiguration(s));
  const outstanding = new OutstandingTaskAwaiter();
  api.GeneratedFile.Subscribe((_, file) => outstanding.Await(WriteString(file.uri, file.content)));
  //api.Debug.Subscribe((_, m) => console.log(m.Text));
  //api.Verbose.Subscribe((_, m) => console.log(m.Text));
  api.Information.Subscribe((_, m) => console.log(m.Text));
  api.Warning.Subscribe((_, m) => console.warn(m.Text));
  api.Error.Subscribe((_, m) => console.error(m.Text));
  api.Fatal.Subscribe((_, m) => console.error(m.Text));
  await api.Process().finish; // TODO: care about return value?
  await outstanding.Wait();
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