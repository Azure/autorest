#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// enable static modules for autorest-core
if ((<any>global).StaticVolumeSet) {
  (<any>global).StaticVolumeSet.addFileSystem(`${__dirname}/static_modules.fs`)
}

require('events').EventEmitter.defaultMaxListeners = 100;

// start of autorest-ng
// the console app starts for real here.

import { Artifact } from './lib/artifact';
import { AutoRestConfigurationImpl, MergeConfigurations } from './lib/configuration';
import { Parse, Stringify } from "./lib/ref/yaml";
import { CreateObject, nodes } from "./lib/ref/jsonpath";
import { OutstandingTaskAwaiter } from "./lib/outstanding-task-awaiter";
import { AutoRest, ConfigurationView } from './lib/autorest-core';
import { ShallowCopy } from "./lib/source-map/merging";
import { Message, Channel } from "./lib/message";
import { resolve as currentDirectory } from "path";
import { ChildProcess } from "child_process";
import { CreateFolderUri, MakeRelativeUri, ReadUri, ResolveUri, WriteString, ClearFolder } from "./lib/ref/uri";
import { isLegacy, CreateConfiguration } from "./legacyCli";
import { DataStore } from "./lib/data-store/data-store";
import { EnhancedFileSystem, RealFileSystem } from './lib/file-system';
import { Exception, OperationCanceledException } from "./lib/exception";

function awaitable(child: ChildProcess): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    child.addListener("error", reject);
    child.addListener("exit", resolve);
  });
}

async function legacyMain(autorestArgs: string[]): Promise<number> {
  // generate virtual config file
  const currentDirUri = CreateFolderUri(currentDirectory());
  const dataStore = new DataStore();
  let config: AutoRestConfigurationImpl = {};
  try {
    config = await CreateConfiguration(currentDirUri, dataStore.GetReadThroughScope(new RealFileSystem()), autorestArgs);
  } catch (e) {
    console.error("Error: You have provided legacy command line arguments (single-dash syntax) that seem broken.");
    console.error("");
    console.error(
      "While AutoRest keeps on supporting the old CLI by converting it over to the new one internally, " +
      "it does not have crazy logic determining *what* is wrong with arguments, should conversion fail. " +
      "Please try fixing your arguments or consider moving to the new CLI. " +
      "Visit https://github.com/Azure/autorest/blob/master/docs/user/cli.md for information about the new CLI.");
    console.error("");
    console.error("Internal error: " + e);
    return 1;
  }

  // autorest init
  if (autorestArgs[0] === "init") {
    const clientNameGuess = (config["override-info"] || {}).title || Parse<any>(await ReadUri((config["input-file"] as any)[0])).info.title;
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
  api.AddConfiguration(config);
  const view = await api.view;
  let outstanding: Promise<void> = Promise.resolve();
  api.GeneratedFile.Subscribe((_, file) => outstanding = outstanding.then(() => WriteString(file.uri, file.content)));
  api.ClearFolder.Subscribe((_, folder) => outstanding = outstanding.then(async () => { try { await ClearFolder(folder); } catch (e) { } }));
  subscribeMessages(api, () => { });

  // warn about `--` arguments
  for (var arg of autorestArgs) {
    if (arg.startsWith("--")) {
      view.Message({
        Channel: Channel.Warning,
        Text:
        `The parameter ${arg} looks like it was meant for the new CLI! ` +
        "Note that you have invoked the legacy CLI (by using at least one single-dash argument). " +
        "Please visit https://github.com/Azure/autorest/blob/master/docs/user/cli.md for information about the new CLI."
      });
    }
  }

  const result = await api.Process().finish;
  if (result != true) {
    throw result;
  }
  await outstanding;

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
    let rawValue = match[3] || "{}";
    // quote stuff beginning with '@', YAML doesn't think unquoted strings should start with that
    rawValue = rawValue.startsWith('@') ? `'${rawValue}'` : rawValue;
    // quote numbers with decimal point, we don't have any use for non-integer numbers (while on the other hand version strings may look like decimal numbers)
    rawValue = !isNaN(parseFloat(rawValue)) && rawValue.includes('.') ? `'${rawValue}'` : rawValue;
    const value = Parse(rawValue);
    result.switches.push(CreateObject(key.split("."), value));
  }

  return result;
}

function subscribeMessages(api: AutoRest, errorCounter: () => void) {
  api.Message.Subscribe((_, m) => {
    switch (m.Channel) {
      case Channel.Debug:
      case Channel.Verbose:
      case Channel.Information:
        console.log(m.FormattedMessage || m.Text);
        break;
      case Channel.Warning:
        console.warn(m.FormattedMessage || m.Text);
        break;
      case Channel.Error:
      case Channel.Fatal:
        errorCounter();
        console.error(m.FormattedMessage || m.Text);
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
  const api = new AutoRest(new EnhancedFileSystem((MergeConfigurations(...args.switches) as any)["github-auth-token"] || process.env.GITHUB_AUTH_TOKEN), ResolveUri(currentDirUri, args.configFileOrFolder || "."));
  api.AddConfiguration(args.switches);

  // listen for output messages and file writes
  subscribeMessages(api, () => exitcode++);
  const artifacts: Artifact[] = [];
  const clearFolders: string[] = [];
  api.GeneratedFile.Subscribe((_, artifact) => artifacts.push(artifact));
  api.ClearFolder.Subscribe((_, folder) => clearFolders.push(folder));

  const config = (await api.view);

  // maybe a resource schema batch process
  if (config["resource-schema-batch"]) {
    return await resourceSchemaBatch(api);
  }

  if (config["batch"]) {
    await batch(api);
  }
  else {
    const result = await api.Process().finish;
    if (result !== true) {
      throw result;
    }
  }

  // perform file system operations.
  for (const folder of clearFolders) {
    try { await ClearFolder(folder); } catch (e) { }
  }
  for (const artifact of artifacts) {
    await WriteString(artifact.uri, artifact.content);
  }

  // return the exit code to the caller.
  return exitcode;
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
      result.push(`{ "$ref": "https://schema.management.azure.com/schemas/${apiversion}/${namespace}.json#/resourceDefinitions/${name}" }, `);
    }
  }
  return result;
}

async function resourceSchemaBatch(api: AutoRest): Promise<number> {
  // get the configuration
  const outputs = new Map<string, string>();
  const schemas = new Array<string>();

  let outstanding: Promise<void> = Promise.resolve();

  // ask for the view without 
  const config = await api.RegenerateView();
  for (const batchConfig of config.GetNestedConfiguration("resource-schema-batch")) { // really, there should be only one
    for (const eachFile of batchConfig["input-file"]) {
      const path = ResolveUri(config.configFileFolderUri, eachFile);
      const content = await ReadUri(path);
      if (!AutoRest.IsSwaggerFile(content)) {
        exitcode++;
        console.error(`File ${path} is not a OpenAPI file.`);
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
            outstanding = outstanding.then(() => WriteString(file.uri, file.content))
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
            outstanding = outstanding.then(() => WriteString(file.uri, content));
          }
        }
      });
      subscribeMessages(instance, () => exitcode++);

      // set configuration for that item
      instance.AddConfiguration(ShallowCopy(batchConfig, "input-file"));
      instance.AddConfiguration({ "input-file": eachFile });

      // const newView = await instance.view;
      // console.log(`Inputs: ${newView["input-file"]}`);
      // newView.Dump()

      console.log(`Running autorest for *${path}* `);

      // ok, kick off the process for that one.
      await instance.Process().finish.then(async (result) => {
        if (result != true) {
          exitcode++;
          throw result;
        }
      });
    }
  }

  await outstanding;

  return exitcode;
}


async function batch(api: AutoRest): Promise<void> {
  const config = await api.view;
  const batchTaskConfigReference: any = {};
  api.AddConfiguration(batchTaskConfigReference);
  for (const batchTaskConfig of config.GetEntry("batch" as any)) {
    config.Message({
      Channel: Channel.Information,
      Text: `Processing batch task - ${batchTaskConfig} .`
    });

    // update batch task config section
    for (const key of Object.keys(batchTaskConfigReference)) delete batchTaskConfigReference[key];
    Object.assign(batchTaskConfigReference, batchTaskConfig);
    api.Invalidate();

    const result = await api.Process().finish;
    if (result !== true) {
      config.Message({
        Channel: Channel.Error,
        Text: `Failure during batch task - ${batchTaskConfig} -- ${result}.`
      });
      throw result;
    }
  }
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

    process.exit(exitcode);
  } catch (e) {
    // be very careful about the following check:
    // - doing the inversion (instanceof Error) doesn't reliably work since that seems to return false on Errors marshalled from safeEval
    if (e instanceof Exception) {
      if (autorestArgs.indexOf("--debug") !== -1) {
        console.log(e);
      } else {
        console.log(e.message);
      }
      process.exit(e.exitCode);
    }

    if (e !== false) {
      console.error(e);
    }
    process.exit(1);
  }
}

main();