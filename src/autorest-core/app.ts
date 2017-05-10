#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// start of autorest-ng
// the console app starts for real here.

// this file should get 'required' by the boostrapper
require("./lib/polyfill.min.js");

import { Parse, Stringify } from "./lib/ref/yaml";
import { CreateObject, nodes } from "./lib/ref/jsonpath";
import { OutstandingTaskAwaiter } from "./lib/outstanding-task-awaiter";
import { AutoRest } from "./lib/autorest-core";
import { ShallowCopy } from "./lib/source-map/merging";
import { Message, Channel } from "./lib/message";
import { resolve as currentDirectory } from "path";
import { ChildProcess } from "child_process";
import { CreateFolderUri, MakeRelativeUri, ReadUri, ResolveUri, WriteString } from "./lib/ref/uri";
import { SpawnLegacyAutoRest } from "./interop/autorest-dotnet";
import { isLegacy, CreateConfiguration } from "./legacyCli";
import { DataStore } from "./lib/data-store/data-store";
import { RealFileSystem } from "./lib/file-system";
import { Exception, OperationCanceledException } from "./lib/exception";
import { Console } from "./lib/console";

/**
 * Legacy AutoRest
 */

function awaitable(child: ChildProcess): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    child.addListener("error", reject);
    child.addListener("exit", resolve);
  });
}

async function legacyMain(autorestArgs: string[]): Promise<number> {
  if (autorestArgs.indexOf("-FANCY") !== -1) {
    // generate virtual config file
    const currentDirUri = CreateFolderUri(currentDirectory());
    const dataStore = new DataStore();
    const config = await CreateConfiguration(currentDirUri, dataStore.GetReadThroughScope(x => true /*unsafe*/), autorestArgs);

    // autorest init
    if (autorestArgs[0] === "init") {
      const clientNameGuess = (config["override-info"] || {}).title || Parse<any>(await ReadUri(config["input-file"][0])).info.title;
      await autorestInit(clientNameGuess, Array.isArray(config["input-file"]) ? config["input-file"] as any : []);
      return 0;
    }
    // autorest init-min
    if (autorestArgs[0] === "init-min") {
      console.log(`# AutoRest Configuration (auto-generated, please adjust title)

> see https://aka.ms/autorest

The following configuration was auto-generated and can be adjusted.

~~~ yaml
${Stringify(config).replace(/^---\n/, "")}
~~~

`.replace(/~/g, "`"));
      return 0;
    }
    // autorest init-cli
    if (autorestArgs[0] === "init-cli") {
      const args: string[] = [];
      for (const node of nodes(config, "$..*")) {
        const path = node.path.join(".");
        const values = node.value instanceof Array ? node.value : (typeof node.value === "object" ? [] : [node.value]);
        for (const value of values) {
          args.push(`--${path}=${value}`);
        }
      }
      console.log(args.join(" "));
      return 0;
    }

    config["base-folder"] = currentDirUri;
    const api = new AutoRest(new RealFileSystem());
    await api.AddConfiguration(config);
    const outstanding = new OutstandingTaskAwaiter();
    api.GeneratedFile.Subscribe((_, file) => outstanding.Await(WriteString(file.uri, file.content)));
    subscribeMessages(api, () => { });

    const result = await api.Process().finish;
    if (result != true) {
      throw result;
    }
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

  return 0;
}


/**
 * Current AutoRest
 */

type CommandLineArgs = { configFileOrFolder?: string, switches: any[] };

function parseArgs(autorestArgs: string[]): CommandLineArgs {
  const result: CommandLineArgs = {
    switches: []
  };

  for (const arg of autorestArgs) {
    const match = /^--([^=]+)(=(.+))?$/g.exec(arg);

    // configuration file?
    if (match === null) {
      if (result.configFileOrFolder) {
        throw new Error(`Found multiple configuration file arguments: '${result.configFileOrFolder}', '${arg}'`);
      }
      result.configFileOrFolder = arg;
      continue;
    }

    // switch
    const key = match[1];
    const value = Parse(match[3] || "{}");
    result.switches.push(CreateObject(key.split("."), value));
  }

  return result;
}

function subscribeMessages(api: AutoRest, errorCounter: () => void) {
  api.Message.Subscribe((_, m) => {
    switch (m.Channel) {
      case Channel.Information:
        console.log(m.Text);
        break;
      case Channel.Warning:
        console.warn(m.Text);
        break;
      case Channel.Error:
        errorCounter();
        console.error(m.Text);
        break;
      case Channel.Debug:
        console.log(m.Text);
        break;
      case Channel.Verbose:
        console.log(m.Text);
        break;
      case Channel.Fatal:
        errorCounter();
        console.error(m.Text);
        break;
    }
  });
}

async function autorestInit(title: string = "API-NAME", inputs: string[] = ["LIST INPUT FILES HERE"]) {
  const cwdUri = CreateFolderUri(currentDirectory());
  for (let i = 0; i < inputs.length; ++i) {
    try {
      inputs[i] = MakeRelativeUri(cwdUri, inputs[i]);
    } catch (e) { }
  }
  console.log(`# ${title}
> see https://aka.ms/autorest

This is the AutoRest configuration file for the ${title}.

---
## Getting Started 
To build the SDK for ${title}, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> ~autorest~

To see additional help and options, run:

> ~autorest --help~
---

## Configuration for generating APIs

...insert-some-meanigful-notes-here...

---
#### Basic Information 
These are the global settings for the API.

~~~ yaml
# list all the input OpenAPI files (may be YAML, JSON, or Literate- OpenAPI markdown)
input-file:
${inputs.map(x => "  - " + x).join("\n")}
~~~

---
#### Language-specific settings: CSharp

These settings apply only when ~--csharp~ is specified on the command line.

~~~ yaml $(csharp) 
csharp:
  # override the default output folder
  output-folder: generated/csharp
~~~
`.replace(/~/g, "`"));
}

let exitcode = 0;
const outstanding = new OutstandingTaskAwaiter();
let args: CommandLineArgs;

async function currentMain(autorestArgs: string[]): Promise<number> {
  if (autorestArgs[0] === "init") {
    await autorestInit();
    return 0;
  }

  // parse the args from the command line
  args = parseArgs(autorestArgs);

  // identify where we are starting from.
  const currentDirUri = CreateFolderUri(currentDirectory());

  // get an instance of AutoRest and add the command line switches to the configuration.
  const api = new AutoRest(new RealFileSystem(), ResolveUri(currentDirUri, args.configFileOrFolder || "."));
  api.AddConfiguration(args.switches);

  // listen for output messages and file writes
  subscribeMessages(api, () => exitcode++);
  api.GeneratedFile.Subscribe((_, file) => outstanding.Await(WriteString(file.uri, file.content)));
  const config = (await api.view);

  try {
    // is this a batch process?
    if (config["batch"]) {
      return await batch(api);
    }

    // maybe a merge process
    if (config["merge"]) {
      return await merge(api);
    }

    // Just regular ol' AutoRest!
    const result = await api.Process().finish;
    if (result != true) {
      throw result;
    }
  }
  finally {
    // wait for any outstanding file writes to complete before we bail.
    await outstanding.Wait();
  }

  // return the exit code to the caller.
  return exitcode;
}

async function merge(api: AutoRest): Promise<number> {
  // get the configuration
  const config = await api.view;

  for (const configFile of config.InputFileUris) {
    // let's get out of here if things are not going well.
    if (exitcode > 0) {
      break;
    }
  }
  return 0;
}

function shallowMerge(existing: any, more: any) {
  if (existing && more) {
    for (const key of Object.getOwnPropertyNames(more)) {
      const value = more[key];
      if (value !== undefined) {
        /* if (existing[key]) {
          Console.Log(`> Warning: ${key} is overwritten.`);
        } */
        existing[key] = value;
      }
    }
    return existing;
  }

  if (existing) {
    return existing;
  }
  return more;
}

function getRds(schema: any, path: string): Array<string> {
  const rx = /.*\/(.*)\/(.*).json/;

  const m = rx.exec(path) || [];
  const apiversion = m[1];
  const namespace = m[2];
  const result = [];
  if (schema.resourceDefinitions) {
    for (const name of Object.getOwnPropertyNames(schema.resourceDefinitions)) {
      result.push(`{ "$ref": "http://schema.management.azure.com/schemas/${apiversion}/${namespace}.json#/resourceDefinitions/${name}" }, `);
    }
  }
  return result;
}

async function batch(api: AutoRest): Promise<number> {
  // get the configuration
  const outputs = new Map<string, string>();
  const schemas = new Array<string>();

  const config = await api.view;
  for (const batchConfig of config.GetNestedConfiguration("batch")) { // really, there should be only one
    for (const eachFile of batchConfig["input-file"]) {
      const path = ResolveUri(config.configFileFolderUri, eachFile);
      const content = await ReadUri(path);
      if (!AutoRest.IsSwaggerFile(content)) {
        exitcode++;
        Console.Error(`File ${path} is not a OpenAPI file.`);
        continue;
      }

      // Create the autorest instance for that item
      const instance = new AutoRest(new RealFileSystem(), config.configFileFolderUri);
      instance.GeneratedFile.Subscribe((_, file) => {
        if (file.uri.endsWith(".json")) {
          const more = JSON.parse(file.content);
          if (!outputs.has(file.uri)) {
            // Console.Log(`  Writing  *${file.uri}*`);
            outputs.set(file.uri, file.content);
            outstanding.Await(WriteString(file.uri, file.content))
            schemas.push(...getRds(more, file.uri));
            return;
          } else {
            const existing = JSON.parse(<string>outputs.get(file.uri));
            // Console.Log(`  Updating *${file.uri}*`);

            schemas.push(...getRds(more, file.uri));
            existing.resourceDefinitions = shallowMerge(existing.resourceDefinitions, more.resourceDefinitions);
            existing.definitions = shallowMerge(existing.definitions, more.definitions);
            const content = JSON.stringify(existing, null, 2);
            outputs.set(file.uri, content);
            outstanding.Await(WriteString(file.uri, content));
          }
        }
      });
      subscribeMessages(instance, () => exitcode++);

      // set configuration for that item
      instance.AddConfiguration(ShallowCopy(batchConfig, "input-file"));
      instance.AddConfiguration({ "input-file": eachFile });

      const newView = await instance.view;
      // console.log(`Inputs: ${newView["input-file"]}`);

      Console.Log(`Running autorest for *${path}* `);

      // ok, kick off the process for that one.
      await instance.Process().finish.then((result) => {
        // console.log(`done: ${path}`);
        exitcode++;
        if (result != true) {
          throw result;
        }
      });
    }
  }

  await outstanding;

  return exitcode;
}


async function deprecatedBatch(api: AutoRest): Promise<number> {
  // get the configuration
  const config = await api.view;
  for (const batchConfig of config.GetNestedConfiguration("batch")) { // really, there should be only one
    for (const eachGeneration of batchConfig.GetNestedConfiguration("for-each")) {
      for (const configFile of eachGeneration["input-file"]) { // really, there should be only one here too.
        const path = ResolveUri(config.configFileFolderUri, configFile);
        const content = await ReadUri(path);
        if (!AutoRest.IsConfigurationFile(content)) {
          exitcode++;
          console.error(`File ${path} is not a AutoRest configuration file.`);
          continue;
        }

        // Create the autorest instance for that item
        const instance = new AutoRest(new RealFileSystem(), path);
        instance.GeneratedFile.Subscribe((_, file) => {
          console.log(`writing ${file.uri}`);
          return outstanding.Await(WriteString(file.uri, file.content))
        });
        subscribeMessages(instance, () => exitcode++);

        // set configuration for that item
        instance.AddConfiguration(ShallowCopy(eachGeneration, "input-file"));
        instance.AddConfiguration(ShallowCopy(batchConfig, "for-each"));

        const newView = await instance.view;
        // console.log(`Inputs: ${newView["input-file"]}`);

        console.log(`Running autorest for ${path} `);

        // ok, kick off the process for that one.

        await instance.Process().finish.then((result) => {
          console.log(`done: ${path}`);
          exitcode++;
          if (result != true) {
            throw result;
          }
        });
        break;

      }
    }
  }
  return exitcode;
}

/**
 * Entry point
 */

async function main() {
  let autorestArgs: Array<string> = [];

  try {
    let exitcode: number = 0;

    autorestArgs = process.argv.slice(2);

    // temporary: --help displays legacy AutoRest's -Help message
    if (autorestArgs.indexOf("--help") !== -1) {
      await legacyMain(["-Help"]);
      return;
    }

    if (isLegacy(autorestArgs)) {
      exitcode = await legacyMain(autorestArgs);
    } else {
      exitcode = await currentMain(autorestArgs);
    }

    // for relaxed profiling (assuming that no one calls `main` from electron... use AAAL!)
    if (require("process").versions.electron) await new Promise(_ => { });

    process.exit(0);
  } catch (e) {
    if (e instanceof Exception) {
      console.log(e.message);

      if (autorestArgs.indexOf("--debug")) {
        console.log(e);
      }
      process.exit(e.exitCode);
    }

    if (e instanceof Error) {
      console.error(e);
      process.exit(1);
    }

    console.error(e);
    process.exit(1);
  }
}

main();