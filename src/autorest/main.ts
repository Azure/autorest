/// <reference path="interfaces/autorest-core.d.ts" />

// load static module: ${__dirname }/static_modules.fs
require('./static-loader.js').load(`${__dirname}/static_modules.fs`)

// everything else.
import { networkEnabled, rootFolder, extensionManager, availableVersions, corePackage, installedCores, tryRequire, resolveEntrypoint, resolvePathForLocalVersion, ensureAutorestHome, selectVersion, pkgVersion } from "./autorest-as-a-service"
import { DocumentPatterns } from 'autorest-core/main';
import { resolve } from 'path';

import { LanguageClient } from "vscode-languageclient"

// exports the public AutoRest definitions
export { IFileSystem, Message } from 'autorest-core/main';

// the local class definition of the AutoRest Interface and the EventEmitter signatures
import { AutoRest as IAutoRest, Channel as IChannel, IFileSystem } from 'autorest-core/main';

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
}

let resolve_autorest: (value?: typeof IAutoRest | PromiseLike<typeof IAutoRest>) => void;
let reject_autorest: (reason?: any) => void;

// export the selected implementation of the AutoRest interface.
export declare type AutoRest = IAutoRest;
export const AutoRest: Promise<typeof IAutoRest> = new Promise((r, j) => {
  resolve_autorest = r;
  reject_autorest = j;
});

let coreModule: any = undefined;
let busy = false;
let modulePath: string | undefined = undefined;

/**
 * Returns the language service entrypoint for autorest-core, bootstrapping the core if necessary
 * 
 * If initialize has already been called, then it returns the version that was initialized, regardless of parameters
 * 
 * @param requestedVersion an npm package reference for the version requested @see {@link https://docs.npmjs.com/cli/install#description}
 *
 * @param minimumVersion - a semver string representing the lowest autorest- core version that is considered acceptable. 
 *
 * @see { @link initialize }
 */
export async function getLanguageServiceEntrypoint(requestedVersion: string = "latest-installed", minimumVersion?: string): Promise<string> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize(requestedVersion, minimumVersion);
  }
  return resolveEntrypoint(modulePath, "language-service");
}

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
export async function getApplicationEntrypoint(requestedVersion: string = "latest-installed", minimumVersion?: string): Promise<string> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize(requestedVersion, minimumVersion);
  }
  return resolveEntrypoint(modulePath, "app");
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
export async function initialize(requestedVersion: string = "latest-installed", minimumVersion?: string) {
  if (modulePath) {
    return;
  }
  if (busy) {
    throw new Error("initialize is already in progress.")
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
    let selectedVersion = await selectVersion(requestedVersion, false, minimumVersion);
    modulePath = await resolveEntrypoint(await selectedVersion.modulePath, "module");
    if (!modulePath) {
      reject_autorest(new Error(`Unable to start AutoRest Core from ${requestedVersion}/${await selectedVersion.modulePath}`));
      throw new Error(`Unable to start AutoRest Core from ${requestedVersion}/${await selectedVersion.modulePath}`);
    }
  } finally {
    busy = false;
  }
}

async function ensureCoreLoaded(): Promise<typeof IAutoRest> {

  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize();
  }

  if (modulePath && !coreModule) {
    // get the library entrypoint
    coreModule = tryRequire(modulePath, "main");

    // assign the type to the Async Class Identity
    resolve_autorest(coreModule.AutoRest)
  }

  // wait for class definition
  return <any>(await AutoRest);
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
export async function create(fileSystem?: IFileSystem, configFileOrFolderUri?: string): Promise<AutoRest> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize();
  }

  if (modulePath && !coreModule) {
    // get the library entrypoint
    coreModule = tryRequire(modulePath, "main");

    // assign the type to the Async Class Identity
    resolve_autorest(coreModule.AutoRest)
  }

  // wait for class definition
  const CAutoRest = <any>(await AutoRest);

  // return new instance of the AutoRest interface.
  return new CAutoRest(fileSystem, configFileOrFolderUri);
}

export async function IsSwaggerFile(content: string): Promise<boolean> {
  return await (await ensureCoreLoaded()).IsSwaggerFile(content);
}

/**
 * The results from calling the 'generate' method via the {@link AutoRestLanguageService/generate}
 * 
 */
export interface generated {
  /** the array of messages produced from the run. */
  messages: Array<string>;
  /** the collection of outputted files. 
   * 
   * Member keys are the file names 
   * Member values are the file contents 
   * 
   * To Access the files:
   * for( const filename in generated.files ) {
   *   const content = generated.files[filename];
   *   /// ... 
   * }
   */
  files: any;
}

/** This is a convenience class for accessing the requests supported by AutoRest when used as a language service */
export class AutoRestLanguageService {

  /** 
   * Represents a convenience layer on the remote language service functions (on top of LSP-defined functions)
   *
   * @constructor
   * 
   * this requires a reference to the language client so that the methods can await the onReady signal 
   * before attempting to send requests.
   */
  public constructor(private languageClient: LanguageClient) {

  }

  /**
   * Runs autorest to process a file
   * 
   * @param documentUri The OpenApi document or AutoRest configuration file to use for the generation
   * 
   * @param language The language to generate code for. (This is a convenience; it could have been expressed in the configuration)
   * 
   * @param configuration Additional configuration to pass to AutoRest -- this overrides any defaults or content in the configuration file
   * @returns async: a 'generated' object containg the output from the generation run.
   *    @see generated
   *     
   */

  public async generate(documentUri: string, language: string, configuration: any): Promise<generated> {
    // don't call before the client is ready.
    await this.languageClient.onReady();
    return await this.languageClient.sendRequest<generated>("generate", { documentUri: documentUri, language: language, configuration: configuration });
  }

  /**
   * Determines if a file is an OpenAPI document (2.0)
   * 
   * @param contentOrUri either a URL to a file on disk or http/s, or the content of a file itself.
   * @returns async:
   *     true - the file is an OpenAPI 2.0 document 
   *     false - the file was not recognized.
   */
  public async isOpenApiDocument(contentOrUri: string): Promise<boolean> {
    // don't call before the client is ready.
    await this.languageClient.onReady();

    return await this.languageClient.sendRequest<boolean>("isOpenApiDocument", { contentOrUri: contentOrUri });
  }

  /**
   * Determines if a file is an AutoRest configuration file (checks for the magic string `\n> see https://aka.ms/autorest` )
   * 
   * @param contentOrUri either a URL to a file on disk or http/s, or the content of a file itself.
   * @returns async:
   *     true - the file is an autorest configuration file
   *     false - the file was not recognized.
   */
  public async isConfigurationFile(contentOrUri: string): Promise<boolean> {
    // don't call before the client is ready.
    await this.languageClient.onReady();

    return await this.languageClient.sendRequest<boolean>("isConfigurationFile", { contentOrUri: contentOrUri });
  }

  /**
  * Returns the file as a JSON string. This can be a .YAML, .MD or .JSON file to begin with.
  * 
  * @param contentOrUri either a URL to a file on disk or http/s, or the content of a file itself.
  * @returns async: string containing the file as JSON
  */
  public async toJSON(contentOrUri: string): Promise<string> {
    // don't call before the client is ready.
    await this.languageClient.onReady();

    return await this.languageClient.sendRequest<string>("toJSON", { contentOrUri: contentOrUri });
  }

  /**
  * Finds the configuration file for a given document URI.
  * 
  * @param documentUri the URL to a file on disk or http/s.  The passed in file can be an OpenAPI file or an AutoRest configuration file.
  * @returns async: the URI to the configuration file or an empty string if no configuration could be found.
  *
  */
  public async findConfigurationFile(documentUri: string): Promise<string> {
    // don't call before the client is ready.
    await this.languageClient.onReady();

    return await this.languageClient.sendRequest<string>("findConfigurationFile", { documentUri: documentUri });
  }

  /**
  * Determines if a file is an OpenAPI document or a configuration file in one attempt.
  * 
  * @param contentOrUri either a URL to a file on disk or http/s, or the content of a file itself.
  * @returns async:
  *     true - the file is a configuration file or OpenAPI (2.0) file
  *     false - the file was not recognized.
  */
  public async isSupportedFile(languageId: string, contentOrUri: string): Promise<boolean> {
    // don't call before the client is ready.
    await this.languageClient.onReady();

    return await this.languageClient.sendRequest<boolean>("isSupportedFile", { languageId: languageId, contentOrUri: contentOrUri });
  }
}