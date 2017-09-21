import { StaticVolumeSet } from './static-fs'
import { gt, gte } from "semver";

if (!gte(process.versions.node, "7.10.0")) {
  console.log(`AutoRest code generation utility.\n\n The version of nodejs you are running is not sufficent.\n You must have version 7.10.0 or greater.\n\nExiting.`);
  process.exit(1);
}

export function initialize(): StaticVolumeSet {
  // only do this once, ever.
  if ((<any>global).StaticVolumeSet) {
    return (<any>global).StaticVolumeSet;
  }

  // get patchRequire
  const patchRequire = require("./fs-monkey/index.js").patchRequire;
  const patchFs = require("./fs-monkey/index.js").patchFs;

  // create the static volume set
  const staticVolume = new StaticVolumeSet(`${__dirname}/static_modules.fs`, true);

  // patch require
  patchRequire(staticVolume);

  // patch the fs too (fixes readFileSync) 
  patchFs(staticVolume);

  // cheat: add static volume instance to the global namespace so that autorest core can add to it.
  (<any>global).StaticVolumeSet = staticVolume;

  // hot-patch process.exit so that when it's called we shutdown the patcher early
  const process_exit = process.exit;
  process.exit = (n): never => {
    staticVolume.shutdown();
    return process_exit(n);
  }

  return staticVolume;
}
