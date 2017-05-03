#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// start of autorest-ng
// the console app starts for real here.

// this file should get 'required' by the boostrapper
require("./lib/polyfill.min.js");

import { Parse, Stringify } from './lib/ref/yaml';
import { CreateObject, nodes } from './lib/ref/jsonpath';
import { OutstandingTaskAwaiter } from "./lib/outstanding-task-awaiter";
import { AutoRest } from "./lib/autorest-core";
import { Message, Channel } from "./lib/message";
import { resolve as currentDirectory } from "path";
import { ChildProcess } from "child_process";
import { CreateFolderUri, MakeRelativeUri, ReadUri, ResolveUri, WriteString } from './lib/ref/uri';
import { SpawnLegacyAutoRest } from "./interop/autorest-dotnet";
import { isLegacy, CreateConfiguration } from "./legacyCli";
import { DataStore } from "./lib/data-store/data-store";
import { RealFileSystem } from "./lib/file-system";
import { Exception, OperationCanceledException } from './lib/exception';

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
    const config = await CreateConfiguration(currentDirUri, dataStore.GetReadThroughScope(x => true /*unsafe*/), autorestArgs);

    // autorest init
    if (autorestArgs[0] === "init") {
      const clientNameGuess = (config["override-info"] || {}).title || Parse<any>(await ReadUri(config["input-file"][0])).info.title;
      await autorestInit(clientNameGuess, Array.isArray(config["input-file"]) ? config["input-file"] as any : []);
      return;
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
      return;
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
      return;
    }

    config["base-folder"] = currentDirUri;
    const api = new AutoRest(new RealFileSystem());
    await api.AddConfiguration(config);
    const outstanding = new OutstandingTaskAwaiter();
    api.GeneratedFile.Subscribe((_, file) => outstanding.Await(WriteString(file.uri, file.content)));
    //api.Debug.Subscribe((_, m) => console.log(m.Text));
    //api.Verbose.Subscribe((_, m) => console.log(m.Text));
    api.Message.Subscribe((_, m) => {
      switch (m.Channel) {
        case Channel.Information:
          console.log(m.Text);
          break;
        case Channel.Warning:
          console.warn(m.Text);
          break;
        case Channel.Error:
          console.error(m.Text);
          break;
        case Channel.Fatal:
          console.error(m.Text);
          break;
      }
    });

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
    const match = /^--([^=]+)(=([^=]+))?$/g.exec(arg);

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

async function currentMain(autorestArgs: string[]): Promise<void> {
  if (autorestArgs[0] === "init") {
    await autorestInit();
    return;
  }

  const args = parseArgs(autorestArgs);
  const currentDirUri = CreateFolderUri(currentDirectory());
  const api = new AutoRest(new RealFileSystem(), ResolveUri(currentDirUri, args.configFileOrFolder || "."));
  for (const s of args.switches) {
    await api.AddConfiguration(s);
  }
  const outstanding = new OutstandingTaskAwaiter();
  api.GeneratedFile.Subscribe((_, file) => outstanding.Await(WriteString(file.uri, file.content)));
  //api.Debug.Subscribe((_, m) => console.log(m.Text));
  //api.Verbose.Subscribe((_, m) => console.log(m.Text));
  api.Message.Subscribe((_, m) => {
    switch (m.Channel) {
      case Channel.Information:
        console.log(m.Text);
        break;
      case Channel.Warning:
        console.warn(m.Text);
        break;
      case Channel.Error:
        console.error(m.Text);
        break;
      case Channel.Fatal:
        console.error(m.Text);
        break;
    }
  });
  const result = await api.Process().finish;
  if (result != true) {
    throw result;
  }
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

    // for relaxed profiling (assuming that no one calls `main` from electron... use AAAL!)
    if (require("process").versions.electron) await new Promise(_ => { });

    process.exit(0);
  } catch (e) {
    if (e instanceof Exception) {
      console.error(e.message);
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