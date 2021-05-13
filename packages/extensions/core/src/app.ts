/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable no-console */
import "source-map-support/register";
import { omit } from "lodash";
import { configureLibrariesLogger } from "@autorest/common";
import { EventEmitter } from "events";
import { AutorestCliArgs, parseAutorestCliArgs } from "@autorest/configuration";
EventEmitter.defaultMaxListeners = 100;
process.env["ELECTRON_RUN_AS_NODE"] = "1";
delete process.env["ELECTRON_NO_ATTACH_CONSOLE"];

const color: (text: string) => string = (<any>global).color ? (<any>global).color : (p) => p;

// start of autorest-ng
// the console app starts for real here.

import { EnhancedFileSystem, Parse, RealFileSystem } from "@azure-tools/datastore";
import {
  clearFolder,
  createFolderUri,
  makeRelativeUri,
  readUri,
  resolveUri,
  writeBinary,
  writeString,
} from "@azure-tools/uri";
import { resolve as currentDirectory } from "path";
import { Help } from "./help";
import { Artifact } from "./lib/artifact";
import { AutoRest, IsOpenApiDocument, Shutdown } from "./lib/autorest-core";
import { Exception } from "@autorest/common";
import { Channel, Message } from "./lib/message";
import { VERSION } from "./lib/constants";
import { AutorestCoreLogger } from "./lib/context/logger";

let verbose = false;
let debug = false;

// TODO remove this when redesigning the logger integration. This is a hack to reuse the logic of the AutorestCoreLogger
// https://github.com/Azure/autorest/issues/4024
class RootLogger extends AutorestCoreLogger {
  public constructor() {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    super({} as any, null!, null!);
  }

  public log(message: Message) {
    outputMessage(message, () => {});
  }
}

function outputMessage(m: Message, errorCounter: () => void) {
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
    return outputMessage(m, errorCounter);
  });
}

async function autorestInit(title = "API-NAME", inputs: Array<string> = ["LIST INPUT FILES HERE"]) {
  const cwdUri = createFolderUri(currentDirectory());
  for (let i = 0; i < inputs.length; ++i) {
    try {
      inputs[i] = makeRelativeUri(cwdUri, inputs[i]);
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

let cleared = false;
async function doClearFolders(protectFiles: Set<string>, clearFolders: Set<string>) {
  if (!cleared) {
    timestampDebugLog("Clearing Folders.");
    cleared = true;
    for (const folder of clearFolders) {
      try {
        await clearFolder(
          folder,
          [...protectFiles].map((each) => resolveUri(folder, each)),
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
  const more = [];
  for (const each of autorestArgs) {
    const match = /^--([^=:]+)([=:](.+))?$/g.exec(each);
    if (match && !match[3]) {
      // it's a solitary --foo (ie, no specified value) argument
      more.push(`--try-require=readme.${match[1]}.md`);
    }
  }

  // We need to check if verbose logging should be enabled before parsing the args.
  verbose = verbose || autorestArgs.indexOf("--verbose") !== -1;

  const logger = new RootLogger();
  const args = parseAutorestCliArgs([...autorestArgs, ...more], { logger });

  if (!args.options["message-format"] || args.options["message-format"] === "regular") {
    console.log(color(`> Loading AutoRest core      '${__dirname}' (${VERSION})`));
  }
  verbose = verbose || (args.options["verbose"] ?? false);
  debug = debug || (args.options["debug"] ?? false);

  // Only show library logs if in verbose or debug mode.
  if (verbose || debug) {
    configureLibrariesLogger("verbose", console.log);
  }

  // identify where we are starting from.
  const currentDirUri = createFolderUri(currentDirectory());

  if (args.options["help"]) {
    // if they are asking for help, feed a false file to config so we don't load a user's configuration
    args.configFileOrFolder = "invalid.filename.md";
  }

  const githubToken = args.options["github-auth-token"] ?? process.env.GITHUB_AUTH_TOKEN;
  // get an instance of AutoRest and add the command line switches to the configuration.
  const api = new AutoRest(
    new EnhancedFileSystem(githubToken),
    resolveUri(currentDirUri, args.configFileOrFolder ?? "."),
  );
  api.AddConfiguration(args.options);

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
        ? writeBinary(artifact.uri, artifact.content)
        : writeString(artifact.uri, artifact.content),
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
    await batch(api, args);
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
        ? writeBinary(artifact.uri, artifact.content)
        : writeString(artifact.uri, artifact.content));
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
      const path = resolveUri(config.configFileFolderUri, eachFile);
      const content = await readUri(path);
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
              file.type === "binary-file" ? writeBinary(file.uri, file.content) : writeString(file.uri, file.content),
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
              file.type === "binary-file" ? writeBinary(file.uri, file.content) : writeString(file.uri, content),
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

async function batch(api: AutoRest, args: AutorestCliArgs): Promise<void> {
  const config = await api.view;
  const batchTaskConfigReference: any = {};
  api.AddConfiguration(batchTaskConfigReference);
  for (const batchTaskConfig of config.GetEntry(<any>"batch")) {
    const isjson = args.options["message-format"] === "json" || args.options["message-format"] === "yaml";
    if (!isjson) {
      outputMessage(
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
