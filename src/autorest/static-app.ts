#!/usr/bin/env node
import { StaticVolumeSet } from './static-fs'

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

// continue with original startup
require("./app");