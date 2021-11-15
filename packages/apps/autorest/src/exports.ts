/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable @typescript-eslint/triple-slash-reference */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
/// <reference path="../definitions/core.d.ts" />
/// <reference path="../definitions/vscode.d.ts" />

// everything else.
import { resolve } from "path";

import { IAutorestLogger } from "@autorest/common";
import { GenerationResults, IFileSystem, AutoRest as IAutoRest } from "autorest-core";
import { LanguageClient } from "vscode-languageclient";

// exports the public AutoRest definitions
import { runCoreWithRequire, resolveEntrypoint, ensureAutorestHome, selectVersion } from "./autorest-as-a-service";
export { Message, Artifact, GenerationResults, IFileSystem } from "autorest-core";

// This is needed currently in autorest-as-service when starting @autorest/core out of proc for @autorest/core version older than 3.6.0
export { color } from "@autorest/common";

/**
 * The Channel that a message is registered with.
 */
export enum Channel {
  /** Information is considered the mildest of responses; not necesarily actionable. */
  Information = <any>"information",

  /** Warnings are considered important for best practices, but not catastrophic in nature. */
  Warning = <any>"warning",

  /** Errors are considered blocking issues that block a successful operation.  */
  Error = <any>"error",

  /** Debug messages are designed for the developer to communicate internal autorest implementation details. */
  Debug = <any>"debug",

  /** Verbose messages give the user additional clarity on the process. */
  Verbose = <any>"verbose",

  /** Catastrophic failure, likely abending the process.  */
  Fatal = <any>"fatal",

  /** Hint messages offer guidance or support without forcing action. */
  Hint = <any>"hint",

  /** File represents a file output from an extension. Details are a Artifact and are required.  */
  File = <any>"file",

  /** content represents an update/creation of a configuration file. The final uri will be in the same folder as the primary config file. */
  Configuration = <any>"configuration",

  /** Protect is a path to not remove during a clear-output-folder.  */
  Protect = <any>"protect",
}

export enum DocumentType {
  OpenAPI2 = <any>"OpenAPI2",
  OpenAPI3 = <any>"OpenAPI3",
  LiterateConfiguration = <any>"LiterateConfiguration",
  Unknown = <any>"Unknown",
}

let resolveAutoRest: (value?: IAutoRest | PromiseLike<IAutoRest>) => void;
let rejectAutoRest: (reason?: any) => void;

// export the selected implementation of the AutoRest interface.
export declare type AutoRest = IAutoRest;
export const AutoRest: Promise<IAutoRest> = new Promise((r, j) => {
  resolveAutoRest = r;
  rejectAutoRest = j;
});

let coreModule: any = undefined;
let busy = false;
let modulePath: string | undefined = undefined;

/**
 * Returns the command-line application entrypoint for autorest-core, bootstrapping the core if necessary
 *
 * If initialize has already been called, then it returns the version that was initialized, regardless of parameters
 *
 * @param requestedVersion an npm package reference for the version requested @see {@link https://docs.npmjs.com/cli/install#description}
 *
 * @param minimumVersion - a semver string representing the lowest autorest-core version that is considered acceptable.
 *
 * @see {@link initialize}
 * */
export async function getApplicationEntrypoint(
  logger: IAutorestLogger,
  requestedVersion = "latest-installed",
  minimumVersion?: string,
): Promise<string | undefined> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    // eslint-disable-next-line @typescript-eslint/no-use-before-define
    await initialize(logger, requestedVersion, minimumVersion);
  }
  return resolveEntrypoint(modulePath!, "app");
}

/**
 * Initializes the AutoRest-core module, bootstrapping the core from npm if required.
 *
 * @param requestedVersion an npm package reference for the version requested @see {@link https://docs.npmjs.com/cli/install#description}
 *
 * a) a folder containing a program described by a package.json file
 * b) a gzipped tarball containing (a)
 * c) a url that resolves to (b)
 * d) a <name>@<version> that is published on the registry {@link https://docs.npmjs.com/misc/registry}) with (c)
 * e) a <name>@<tag> (see npm-dist-tag) that points to (d)
 * f) a <name> that has a "latest" tag satisfying (e)
 * g) a <git remote url> that resolves to (a)
 *
 * @param minimumVersion - a semver string representing the lowest autorest-core version that is considered acceptable.
 */
export async function initialize(
  logger: IAutorestLogger,
  requestedVersion = "latest-installed",
  minimumVersion?: string,
) {
  if (modulePath) {
    return;
  }
  if (busy) {
    throw new Error("initialize is already in progress.");
  }

  busy = true;

  try {
    await ensureAutorestHome();

    try {
      // did they pass in a path first?
      const localVersion = resolve(requestedVersion);

      // try to use a specified folder
      modulePath = await resolveEntrypoint(localVersion, "module");

      if (modulePath) {
        return;
      }
    } catch (E) {
      // no local version
    }

    // logic to resolve and optionally install a autorest core package.
    // will throw if it's not doable.
    const selectedVersion = await selectVersion(logger, requestedVersion, false, minimumVersion);
    modulePath = await resolveEntrypoint(await selectedVersion.modulePath, "module");
    if (!modulePath) {
      rejectAutoRest(
        new Error(`Unable to start AutoRest Core from ${requestedVersion}/${await selectedVersion.modulePath}`),
      );
      throw new Error(`Unable to start AutoRest Core from ${requestedVersion}/${await selectedVersion.modulePath}`);
    }
  } finally {
    busy = false;
  }
}

/** Bootstraps the core module if it's not already done and returns the AutoRest class. */
async function ensureCoreLoaded(logger: IAutorestLogger): Promise<IAutoRest> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize(logger);
  }

  if (modulePath && !coreModule) {
    // get the library entrypoint
    coreModule = await runCoreWithRequire(modulePath, "main");

    // assign the type to the Async Class Identity
    resolveAutoRest(coreModule.AutoRest);
  }

  // wait for class definition
  return <any>await AutoRest;
}

/**
 * Creates an instance of the AutoRest engine. Will call {@link initialize} with default values to bootstrap AutoRest core if necessary.
 *
 * @param fileSystem - the {@link IFileSystem} implementation that will be used to acquire files
 *
 * Note: http:/https:/mem: schemes are handled internally in AutoRest and the IFilesystem will not call
 * the IFileSystem methods.
 *
 *
 * @param configFileOrFolderUri - a URI pointing to the folder or autorest configuration file
 */
export async function create(
  logger: IAutorestLogger,
  fileSystem?: IFileSystem,
  configFileOrFolderUri?: string,
): Promise<AutoRest> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize(logger);
  }

  if (modulePath && !coreModule) {
    // get the library entrypoint
    coreModule = await runCoreWithRequire(modulePath, "main");

    // assign the type to the Async Class Identity
    resolveAutoRest(coreModule.AutoRest);
  }

  // wait for class definition
  const CAutoRest = <any>await AutoRest;

  // return new instance of the AutoRest interface.
  return new CAutoRest(fileSystem, configFileOrFolderUri);
}

/**
 *  Given a document's content, does this represent a openapi document of some sort?
 *
 * @param content - the document content to evaluate
 */
export async function isOpenApiDocument(logger: IAutorestLogger, content: string): Promise<boolean> {
  await ensureCoreLoaded(logger);
  return coreModule.IsOpenApiDocument(content);
}

/** Determines the document type based on the content of the document
 *
 * @returns Promise<DocumentType> one of:
 *  -  DocumentType.LiterateConfiguration - contains the magic string '\n> see https://aka.ms/autorest'
 *  -  DocumentType.OpenAPI2 - $.swagger === "2.0"
 *  -  DocumentType.OpenAPI3 - $.openapi === "3.0.0"
 *  -  DocumentType.Unknown - content does not match a known document type
 *
 * @see {@link DocumentType}
 */
export async function identifyDocument(logger: IAutorestLogger, content: string): Promise<DocumentType> {
  await ensureCoreLoaded(logger);
  return await coreModule.IdentifyDocument(content);
}

/**
 * Processes a document (yaml, markdown or JSON) and returns the document as a JSON-encoded document text
 * @param content - the document content
 *
 * @returns the content as a JSON string (not a JSON DOM)
 */
export async function toJSON(logger: IAutorestLogger, content: string): Promise<string> {
  await ensureCoreLoaded(logger);
  return await coreModule.LiterateToJson(content);
}
