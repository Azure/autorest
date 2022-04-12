/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable no-console */
import "source-map-support/register";
import { join, resolve as currentDirectory } from "path";
import {
  configureLibrariesLogger,
  color,
  ConsoleLogger,
  FilterLogger,
  AutorestSyncLogger,
  Exception,
  IAutorestLogger,
  AutorestLogger,
} from "@autorest/common";
import { AutorestCliArgs, parseAutorestCliArgs, getLogLevel } from "@autorest/configuration";
import { EnhancedFileSystem, RealFileSystem } from "@azure-tools/datastore";
import {
  clearFolder,
  createFolderUri,
  makeRelativeUri,
  readUri,
  resolveUri,
  writeBinary,
  writeString,
} from "@azure-tools/uri";
import { omit } from "lodash";
import { ArtifactWriter } from "./artifact-writer";
import { printAutorestHelp } from "./commands";
import { Artifact } from "./lib/artifact";
import { AutoRest, IsOpenApiDocument, Shutdown } from "./lib/autorest-core";
import { VERSION } from "./lib/constants";

let verbose = false;
let debug = false;

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

let cleared = false;
async function doClearFolders(protectFiles: Set<string>, clearFolders: Set<string>, logger: IAutorestLogger) {
  if (!cleared) {
    logger.debug("Clearing Folders.");
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

async function currentMain(
  logger: AutorestLogger,
  loggerSink: IAutorestLogger,
  args: AutorestCliArgs,
): Promise<number> {
  if (!args.options["message-format"] || args.options["message-format"] === "regular") {
    logger.info(`> Loading AutoRest core      '${__dirname}' (${VERSION})`);
  }
  verbose = verbose || (args.options["verbose"] ?? false);
  debug = debug || (args.options["debug"] ?? false);

  // Only show library logs if in verbose or debug mode.
  if (verbose || debug) {
    configureLibrariesLogger("verbose", (...x) => logger.debug(x.join(" ")));
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
    loggerSink,
    new EnhancedFileSystem(githubToken),
    resolveUri(currentDirUri, args.configFileOrFolder ?? "."),
  );
  api.AddConfiguration(args.options);

  // listen for output messages and file writes
  const artifacts: Array<Artifact> = [];
  const clearFolders = new Set<string>();
  const protectFiles = new Set<string>();
  const context = await api.view;
  const artifactWriter = new ArtifactWriter(context.config);

  api.GeneratedFile.Subscribe((_, artifact) => {
    if (context.config.help) {
      artifacts.push(artifact);
      return;
    }

    protectFiles.add(artifact.uri);
    artifactWriter.writeArtifact(artifact);
  });

  api.ProtectFile.Subscribe((_, filename) => {
    protectFiles.add(filename);
  });
  api.ClearFolder.Subscribe((_, folder) => clearFolders.add(folder));

  // maybe a resource schema batch process
  if (context.config["resource-schema-batch"]) {
    return resourceSchemaBatch(api, logger);
  }

  if (context.config["batch"]) {
    await batch(api, logger);
  } else {
    const result = await api.Process().finish;
    if (result !== true) {
      throw result;
    }
  }

  if (context.config.help) {
    printAutorestHelp(artifacts);
  } else {
    // perform file system operations.
    await doClearFolders(protectFiles, clearFolders, logger);

    logger.debug("Writing Outputs.");
    await artifactWriter.wait();
  }
  printCompleteSummary(logger, artifactWriter);
  // return the exit code to the caller.
  return 0;
}

function printCompleteSummary(logger: IAutorestLogger, artifactWriter: ArtifactWriter) {
  const runtime = Math.round(process.uptime() * 100) / 100;
  logger.info(`Autorest completed in ${runtime}s. ${artifactWriter.stats.writeCompleted} files generated.`);
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

async function resourceSchemaBatch(api: AutoRest, logger: IAutorestLogger): Promise<number> {
  // get the configuration
  const outputs = new Map<string, string>();
  const schemas = new Array<string>();

  let outstanding: Promise<void> = Promise.resolve();

  let exitCode = 0;
  // ask for the view without
  const config = await api.RegenerateView();
  for (const batchContext of config.getNestedConfiguration("resource-schema-batch")) {
    // really, there should be only one
    for (const eachFile of batchContext.config["input-file"] ?? []) {
      const path = resolveUri(config.configFileFolderUri, eachFile);
      const content = await readUri(path);
      if (!(await IsOpenApiDocument(content))) {
        exitCode++;
        console.error(color(`!File ${path} is not a OpenAPI file.`));
        continue;
      }

      // Create the autorest instance for that item
      const instance = new AutoRest(logger, new RealFileSystem(), config.configFileFolderUri);
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

      // set configuration for that item
      instance.AddConfiguration(omit(batchContext, "input-file"));
      instance.AddConfiguration({ "input-file": eachFile });

      logger.info(`Running autorest for *${path}* `);

      // ok, kick off the process for that one.
      await instance.Process().finish.then(async (result) => {
        if (result !== true) {
          exitCode++;
          throw result;
        }
      });
    }
  }

  await outstanding;

  return exitCode;
}

async function batch(api: AutoRest, logger: IAutorestLogger): Promise<void> {
  const config = await api.view;
  const batchTaskConfigReference: any = {};
  api.AddConfiguration(batchTaskConfigReference);
  for (const batchTaskConfig of config.GetEntry(<any>"batch")) {
    logger.info(`Processing batch task - ${JSON.stringify(batchTaskConfig)} .`);
    // update batch task config section
    for (const key of Object.keys(batchTaskConfigReference)) {
      delete batchTaskConfigReference[key];
    }
    Object.assign(batchTaskConfigReference, batchTaskConfig);
    api.Invalidate();

    const result = await api.Process().finish;
    if (result !== true) {
      logger.trackError({
        code: "Batch/Error",
        message: `Failure during batch task - ${JSON.stringify(batchTaskConfig)}  -- ${result}`,
      });
      throw result;
    }
  }
}

async function main() {
  const argv = process.argv.slice(2);
  if (argv[0] === "init") {
    await autorestInit();
    return;
  }

  const args = await getCliArgs(argv);
  if (args === undefined) {
    // eslint-disable-next-line no-process-exit
    process.exit(1);
  }

  const loggerSink = new ConsoleLogger({ format: args.options["message-format"] });
  const logger = new AutorestSyncLogger({
    sinks: [loggerSink],
    processors: [new FilterLogger({ level: getLogLevel(args.options) })],
  });

  let exitCode = 0;
  try {
    return await currentMain(logger, loggerSink, args);
  } catch (e) {
    exitCode = 1;
    // be very careful about the following check:
    // - doing the inversion (instanceof Error) doesn't reliably work since that seems to return false on Errors marshalled from safeEval
    if (e instanceof Exception) {
      logger.log({ level: "error", message: e.message });
      exitCode = e.exitCode;
    }
    if (e !== false) {
      logger.log({ level: "error", message: `!${e}` });
    }
    logger.log({
      level: "error",
      message:
        "Autorest completed with an error. If you think the error message is unclear, or is a bug, please declare an issues at https://github.com/Azure/autorest/issues with the error message you are seeing.",
    });
  } finally {
    try {
      logger.debug("Shutting Down.");
      await Shutdown();
    } catch {
      logger.debug("Shutting Down: (trouble?)");
    } finally {
      logger.debug("Exiting.");
      // eslint-disable-next-line no-process-exit
      process.exit(exitCode);
    }
  }
}

async function getCliArgs(argv: string[]) {
  // add probes for readme.*.md files when a standalone arg is given.
  const more = [];
  for (const each of argv) {
    const match = /^--([^=:]+)([=:](.+))?$/g.exec(each);
    if (match && !match[3]) {
      // it's a solitary --foo (ie, no specified value) argument
      more.push(`--try-require=readme.${match[1]}.md`);
    }
  }

  // We need to check if verbose logging should be enabled before parsing the args.
  verbose = verbose || argv.indexOf("--verbose") !== -1;

  return parseAutorestCliArgs([...argv, ...more]);
}

// Run
void main();

process.on("exit", () => {
  void Shutdown();
});
