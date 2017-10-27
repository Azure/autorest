// load static module: ${__dirname }/static_modules.fs
// require('./static-loader.js').load(`${__dirname}/static_modules.fs`)

// everything else.
import { networkEnabled, rootFolder, extensionManager, availableVersions, corePackage, installedCores, tryRequire, resolveEntrypoint, resolvePathForLocalVersion, ensureAutorestHome, selectVersion, pkgVersion } from "./autorest-as-a-service"
import { DocumentPatterns } from './lib/core/lib/document-type';
import { resolve } from 'path';

// exports the public AutoRest definitions
export { IFileSystem, Message } from './lib/core/main';

// the local class definition of the AutoRest Interface and the EventEmitter signatures
import { AutoRest as IAutoRest, Channel as IChannel, IFileSystem } from './lib/core/main';

export enum Channel {
  Information = <any>"information",
  Warning = <any>"warning",
  Error = <any>"error",
  Debug = <any>"debug",
  Verbose = <any>"verbose",
  Fatal = <any>"fatal",
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

export async function getLanguageServiceEntrypoint(requestedVersion: string = "latest-installed", minimumVersion?: string): Promise<string> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize(requestedVersion, minimumVersion);
  }
  return resolveEntrypoint(modulePath, "language-service");
}

export async function getApplicationEntrypoint(requestedVersion: string = "latest-installed", minimumVersion?: string): Promise<string> {
  if (!modulePath && !busy) {
    // if we haven't already got autorest-core, let's do that now with the default settings.
    await initialize(requestedVersion, minimumVersion);
  }
  return resolveEntrypoint(modulePath, "app");
}

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
