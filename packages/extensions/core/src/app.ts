/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable no-console */
import "source-map-support/register";
import { omit } from "lodash";

// https://github.com/uxitten/polyfill/blob/master/string.polyfill.js
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padEnd
if (!String.prototype.padEnd) {
  String.prototype.padEnd = function padEnd(targetLength, padString) {
    targetLength = targetLength >> 0; // floor if number or convert non-number to 0;
    padString = String(padString || " ");
    if (this.length > targetLength) {
      return String(this);
    } else {
      targetLength = targetLength - this.length;
      if (targetLength > padString.length) {
        padString += padString.repeat(targetLength / padString.length); // append to original to ensure we are longer than needed
      }
      return String(this) + padString.slice(0, targetLength);
    }
  };
}

require("events").EventEmitter.defaultMaxListeners = 100;
process.env["ELECTRON_RUN_AS_NODE"] = "1";
delete process.env["ELECTRON_NO_ATTACH_CONSOLE"];
(<any>global).autorestVersion = require("../package.json").version;

const color: (text: string) => string = (<any>global).color ? (<any>global).color : (p) => p;

// start of autorest-ng
// the console app starts for real here.

import { CreateObject, EnhancedFileSystem, Parse, RealFileSystem } from "@azure-tools/datastore";
import {
  ClearFolder,
  CreateFolderUri,
  MakeRelativeUri,
  ReadUri,
  ResolveUri,
  WriteBinary,
  WriteString,
} from "@azure-tools/uri";
import { join, resolve as currentDirectory } from "path";
import { Help } from "./help";
import { Artifact } from "./lib/artifact";
import { AutoRest, IsOpenApiDocument, Shutdown } from "./lib/autorest-core";
import { mergeConfigurations } from "@autorest/configuration";
import { Exception } from "@autorest/common";
import { Channel, Message } from "./lib/message";
import { homedir } from "os";

let verbose = false;
let debug = false;

/**
 * Current AutoRest
 */

interface CommandLineArgs {
  configFileOrFolder?: string;
  switches: Array<any>;
  rawSwitches: any;
}

function parseArgs(autorestArgs: Array<string>): CommandLineArgs {
  const result: CommandLineArgs = {
    switches: [],
    rawSwitches: {},
  };

  for (const arg of autorestArgs) {
    const match = /^--([^=:]+)([=:](.+))?$/g.exec(arg);

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

    if (rawValue.startsWith(".")) {
      // starts with a . or .. -> this is a relative path to current directory
      rawValue = join(process.cwd(), rawValue);
    }

    if (rawValue.startsWith("~/")) {
      // starts with a ~/ this is a relative path to home directory
      rawValue = join(homedir(), rawValue.substr(1));
    }

    // quote stuff beginning with '@', YAML doesn't think unquoted strings should start with that
    rawValue = rawValue.startsWith("@") ? `'${rawValue}'` : rawValue;
    rawValue = rawValue.match(/20\d\d-\d+-\d+/) ? `'${rawValue}'` : rawValue;
    // quote numbers with decimal point, we don't have any use for non-integer numbers (while on the other hand version strings may look like decimal numbers)
    rawValue = !isNaN(parseFloat(rawValue)) && rawValue.includes(".") ? `'${rawValue}'` : rawValue;
    const value = Parse(rawValue);
    result.rawSwitches[key] = value;
    result.switches.push(CreateObject(key.split("."), value));
  }

  return result;
}

function outputMessage(instance: AutoRest, m: Message, errorCounter: () => void) {
  switch (m.Channel) {
    case Channel.Debug:
      if (debug) {
        console.log(color(m.FormattedMessage || m.Text));
      }
      break;
    case Channel.Verbose:
      if (verbose) {
        console.log(color(m.FormattedMessage || m.Text));
      }
      break;
    case Channel.Information:
      console.log(color(m.FormattedMessage || m.Text));
      break;
    case Channel.Warning:
      console.log(color(m.FormattedMessage || m.Text));
      break;
    case Channel.Error:
    case Channel.Fatal:
      errorCounter();
      console.error(color(m.FormattedMessage || m.Text));
      break;
  }
}

function subscribeMessages(api: AutoRest, errorCounter: () => void) {
  api.Message.Subscribe((_, m) => {
    return outputMessage(_, m, errorCounter);
  });
}

async function autorestInit(title = "API-NAME", inputs: Array<string> = ["LIST INPUT FILES HERE"]) {
  const cwdUri = CreateFolderUri(currentDirectory());
  for (let i = 0; i < inputs.length; ++i) {
    try {
      inputs[i] = MakeRelativeUri(cwdUri, inputs[i]);
    } catch {
      // no worries
    }
  }
  console.log(
    `# ${title}
> see https://aka.ms/autorest

This is the AutoRest configuration file for the ${title}.

---
## Getting Started
To build the SDK for ${title}, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> ~autorest~

To see additional help and options, run:

> ~autorest --help~
---

## Configuration for generating APIs

...insert-some-meanigful-notes-here...

---
#### Basic Information
These are the global settings for the API.

~~~ yaml
# list all the input OpenAPI files (may be YAML, JSON, or Literate- OpenAPI markdown)
input-file:
${inputs.map((x) => "  - " + x).join("\n")}
~~~

---
#### Language-specific settings: CSharp

These settings apply only when ~--csharp~ is specified on the command line.

~~~ yaml $(csharp)
csharp:
  # override the default output folder
  output-folder: generated/csharp
~~~
`.replace(/~/g, "`"),
  );
}

let exitcode = 0;
let args: CommandLineArgs;

let cleared = false;
async function doClearFolders(protectFiles: Set<string>, clearFolders: Set<string>) {
  if (!cleared) {
    timestampDebugLog("Clearing Folders.");
    cleared = true;
    for (const folder of clearFolders) {
      try {
        await ClearFolder(
          folder,
          [...protectFiles].map((each) => ResolveUri(folder, each)),
        );
      } catch {
        // no worries
      }
    }
  }
}

async function currentMain(autorestArgs: Array<string>): Promise<number> {
  if (autorestArgs[0] === "init") {
    await autorestInit();
    return 0;
  }

  // add probes for readme.*.md files when a standalone arg is given.
  const more = new Array<string>();
  for (const each of autorestArgs) {
    const match = /^--([^=:]+)([=:](.+))?$/g.exec(each);
    if (match && !match[3]) {
      // it's a solitary --foo (ie, no specified value) argument
      more.push(`--try-require=readme.${match[1]}.md`);
    }
  }

  // parse the args from the command line
  args = parseArgs([...autorestArgs, ...more]);

  if (!args.rawSwitches["message-format"] || args.rawSwitches["message-format"] === "regular") {
    console.log(color(`> Loading AutoRest core      '${__dirname}' (${(<any>global).autorestVersion})`));
  }
  verbose = verbose || args.rawSwitches["verbose"];
  debug = debug || args.rawSwitches["debug"];

  // identify where we are starting from.
  const currentDirUri = CreateFolderUri(currentDirectory());

  if (args.rawSwitches["help"]) {
    // if they are asking for help, feed a false file to config so we don't load a user's configuration
    args.configFileOrFolder = "invalid.filename.md";
  }

  const githubToken = mergeConfigurations(...args.switches)["github-auth-token"] ?? process.env.GITHUB_AUTH_TOKEN;
  // get an instance of AutoRest and add the command line switches to the configuration.
  const api = new AutoRest(
    new EnhancedFileSystem(githubToken),
    ResolveUri(currentDirUri, args.configFileOrFolder || "."),
  );
  api.AddConfiguration(args.switches);

  // listen for output messages and file writes
  subscribeMessages(api, () => exitcode++);
  const artifacts: Array<Artifact> = [];
  const clearFolders = new Set<string>();
  const protectFiles = new Set<string>();
  let fastMode = false;
  const tasks = new Array<Promise<void>>();

  const context = await api.view;

  api.GeneratedFile.Subscribe((_, artifact) => {
    if (context.config.help) {
      artifacts.push(artifact);
      return;
    }

    protectFiles.add(artifact.uri);
    tasks.push(
      artifact.type === "binary-file"
        ? WriteBinary(artifact.uri, artifact.content)
        : WriteString(artifact.uri, artifact.content),
    );
  });
  api.Message.Subscribe((_, message) => {
    if (message.Channel === Channel.Protect && message.Details) {
      protectFiles.add(message.Details);
    }
  });
  api.ClearFolder.Subscribe((_, folder) => clearFolders.add(folder));

  // maybe a resource schema batch process
  if (context.config["resource-schema-batch"]) {
    return resourceSchemaBatch(api);
  }
  fastMode = !!context.config["fast-mode"];

  if (context.config["batch"]) {
    await batch(api);
  } else {
    const result = await api.Process().finish;
    if (result !== true) {
      throw result;
    }
  }

  if (context.config.help) {
    // no fs operations on --help! Instead, format and print artifacts to console.
    // - print boilerplate help
    console.log("");
    console.log("");
    console.log(color("**Usage**: autorest `[configuration-file.md] [...options]`"));
    console.log("");
    console.log(color("  See: https://aka.ms/autorest/cli for additional documentation"));
    // - sort artifacts by name (then content, just for stability)
    const helpArtifacts = artifacts.sort((a, b) =>
      a.uri === b.uri ? (a.content > b.content ? 1 : -1) : a.uri > b.uri ? 1 : -1,
    );
    // - format and print
    for (const helpArtifact of helpArtifacts) {
      const help: Help = Parse(helpArtifact.content, (message, index) =>
        console.error(color(`!Parsing error at **${helpArtifact.uri}**:__${index}: ${message}__`)),
      );
      if (!help) {
        continue;
      }
      const activatedBySuffix = help.activationScope ? ` (activated by --${help.activationScope})` : "";
      console.log("");
      console.log(color(`### ${help.categoryFriendlyName}${activatedBySuffix}`));
      if (help.description) {
        console.log(color(help.description));
      }
      console.log("");
      for (const settingHelp of help.settings) {
        const keyPart = `--${settingHelp.key}`;
        const typePart = settingHelp.type ? `=<${settingHelp.type}>` : " "; // `[=<boolean>]`;
        const settingPart = `${keyPart}\`${typePart}\``;
        // if (!settingHelp.required) {
        //   settingPart = `[${settingPart}]`;
        // }
        console.log(color(`  ${settingPart.padEnd(30)}  **${settingHelp.description}**`));
      }
    }
  } else {
    // perform file system operations.
    await doClearFolders(protectFiles, clearFolders);

    timestampDebugLog("Writing Outputs.");
    await Promise.all(tasks);

    for (const artifact of artifacts) {
      await (artifact.type === "binary-file"
        ? WriteBinary(artifact.uri, artifact.content)
        : WriteString(artifact.uri, artifact.content));
    }
  }
  timestampLog("Generation Complete");
  // return the exit code to the caller.
  return exitcode;
}

function shallowMerge(existing: any, more: any) {
  if (existing && more) {
    for (const key of Object.getOwnPropertyNames(more)) {
      const value = more[key];
      if (value !== undefined) {
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
  const result = new Array<any>();
  if (schema.resourceDefinitions) {
    for (const name of Object.getOwnPropertyNames(schema.resourceDefinitions)) {
      result.push(
        `{ "$ref": "https://schema.management.azure.com/schemas/${apiversion}/${namespace}.json#/resourceDefinitions/${name}" }, `,
      );
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
  for (const batchContext of config.getNestedConfiguration("resource-schema-batch")) {
    // really, there should be only one
    for (const eachFile of batchContext.config["input-file"] ?? []) {
      const path = ResolveUri(config.configFileFolderUri, eachFile);
      const content = await ReadUri(path);
      if (!(await IsOpenApiDocument(content))) {
        exitcode++;
        console.error(color(`!File ${path} is not a OpenAPI file.`));
        continue;
      }

      // Create the autorest instance for that item
      const instance = new AutoRest(new RealFileSystem(), config.configFileFolderUri);
      instance.GeneratedFile.Subscribe((_, file) => {
        if (file.uri.endsWith(".json")) {
          const more = JSON.parse(file.content);
          if (!outputs.has(file.uri)) {
            outputs.set(file.uri, file.content);
            outstanding = outstanding.then(() =>
              file.type === "binary-file" ? WriteBinary(file.uri, file.content) : WriteString(file.uri, file.content),
            );
            schemas.push(...getRds(more, file.uri));
            return;
          } else {
            const existing = JSON.parse(<string>outputs.get(file.uri));

            schemas.push(...getRds(more, file.uri));
            existing.resourceDefinitions = shallowMerge(existing.resourceDefinitions, more.resourceDefinitions);
            existing.definitions = shallowMerge(existing.definitions, more.definitions);
            const content = JSON.stringify(existing, null, 2);
            outputs.set(file.uri, content);
            outstanding = outstanding.then(() =>
              file.type === "binary-file" ? WriteBinary(file.uri, file.content) : WriteString(file.uri, content),
            );
          }
        }
      });
      subscribeMessages(instance, () => exitcode++);

      // set configuration for that item
      instance.AddConfiguration(omit(batchContext, "input-file"));
      instance.AddConfiguration({ "input-file": eachFile });

      console.log(`Running autorest for *${path}* `);

      // ok, kick off the process for that one.
      await instance.Process().finish.then(async (result) => {
        if (result !== true) {
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
  for (const batchTaskConfig of config.GetEntry(<any>"batch")) {
    const isjson = args.rawSwitches["message-format"] === "json" || args.rawSwitches["message-format"] === "yaml";
    if (!isjson) {
      outputMessage(
        api,
        {
          Channel: Channel.Information,
          Text: `Processing batch task - ${JSON.stringify(batchTaskConfig)} .`,
        },
        () => {},
      );
    }
    // update batch task config section
    for (const key of Object.keys(batchTaskConfigReference)) {
      delete batchTaskConfigReference[key];
    }
    Object.assign(batchTaskConfigReference, batchTaskConfig);
    api.Invalidate();

    const result = await api.Process().finish;
    if (result !== true) {
      outputMessage(
        api,
        {
          Channel: Channel.Error,
          Text: `Failure during batch task - ${JSON.stringify(batchTaskConfig)} -- ${result}.`,
        },
        () => {},
      );
      throw result;
    }
  }
}

/**
 * Entry point
 */
async function mainImpl(): Promise<number> {
  let autorestArgs: Array<string> = [];
  const exitcode = 0;

  try {
    autorestArgs = process.argv.slice(2);

    return await currentMain(autorestArgs);
  } catch (e) {
    // be very careful about the following check:
    // - doing the inversion (instanceof Error) doesn't reliably work since that seems to return false on Errors marshalled from safeEval
    if (e instanceof Exception) {
      console.log(e.message);
      return e.exitCode;
    }
    if (e !== false) {
      console.error(color(`!${e}`));
    }
  }
  return 1;
}

function timestampLog(content: string) {
  console.log(color(`[${Math.floor(process.uptime() * 100) / 100} s] ${content}`));
}
function timestampDebugLog(content: string) {
  if (debug) {
    console.log(color(`[${Math.floor(process.uptime() * 100) / 100} s] ${content}`));
  }
}

async function main() {
  let exitcode = 0;
  try {
    exitcode = await mainImpl();
  } catch {
    exitcode = 102;
  } finally {
    try {
      timestampDebugLog("Shutting Down.");
      await Shutdown();
    } catch {
      timestampDebugLog("Shutting Down: (trouble?)");
    } finally {
      timestampDebugLog("Exiting.");
      // eslint-disable-next-line no-process-exit
      process.exit(exitcode);
    }
  }
}

void main();

process.on("exit", () => {
  void Shutdown();
});

async function showHelp(): Promise<void> {
  await currentMain(["--help"]);
}
