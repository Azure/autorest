
// enable the static module loader
require("./static-loader").initialize();

// everything else.
import { networkEnabled, rootFolder, extensionManager, availableVersions, corePackage, installedCores, tryRequire, resolvePathForLocalVersion, ensureAutorestHome, selectVersion, pkgVersion } from "./autorest-as-a-service"
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

let busy = false;
let loaded = false;

export async function initialize(requestedVersion: string = "latest-installed", minimumVersion?: string) {
  if (loaded) {
    return;
  }
  if (busy) {
    throw new Error("initialize is already called.")
  }

  busy = true;

  try {
    await ensureAutorestHome();

    try {
      // did they pass in a path first?
      const localVersion = resolve(requestedVersion);

      // try to use a specified folder
      const module = await tryRequire(localVersion, "main.js")
      if (module) {
        // assign the type to the Async Class Identity
        resolve_autorest(module.AutoRest)
        loaded = true;
        return;
      }
    } catch (E) {
      // no local version
    }
    // logic to resolve and optionally install a autorest core package.
    // will throw if it's not doable.
    let selectedVersion = await selectVersion(requestedVersion, false, minimumVersion);

    const module = await tryRequire(await selectedVersion.modulePath, "main.js");
    if (!module) {
      reject_autorest(new Error(`Unable to start AutoRest Core from ${requestedVersion}/${await selectedVersion.modulePath}`));
      throw new Error(`Unable to start AutoRest Core from ${requestedVersion}/${await selectedVersion.modulePath}`);
    }

    // assign the type to the Async Class Identity
    resolve_autorest(module.AutoRest)
    loaded = true;

  } finally {
    busy = false;
  }
}

export async function create(fileSystem?: IFileSystem, configFileOrFolderUri?: string): Promise<AutoRest> {
  const CAutoRest = <any>(await AutoRest);
  return new CAutoRest(fileSystem, configFileOrFolderUri);
}
