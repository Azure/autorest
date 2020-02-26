import { lookup } from 'dns';
import { Extension, ExtensionManager, Package } from '@azure-tools/extension';
import { homedir } from 'os';
import { dirname, join, resolve } from 'path';

import { Exception } from '@azure-tools/tasks';

import * as semver from 'semver';
import { isFile, mkdir, isDirectory } from '@azure-tools/async-io';
import { When } from '@azure-tools/tasks';
import { mkdtempSync, rmdirSync } from 'fs';
import { tmpdir } from 'os';
import { spawn } from 'child_process';

export const pkgVersion: string = require(`${__dirname}/../package.json`).version;
process.env['autorest.home'] = process.env['autorest.home'] || homedir();

try {
  rmdirSync(mkdtempSync(join(process.env['autorest.home'], 'temp')));
} catch {
  // hmm. the home  directory isn't writable. let's fallback to $tmp
  process.env['autorest.home'] = tmpdir();
}

export const rootFolder = join(process.env['autorest.home'], '.autorest');
const args = (<any>global).__args || {};

export const extensionManager: Promise<ExtensionManager> = ExtensionManager.Create(rootFolder);
export const oldCorePackage = '@microsoft.azure/autorest-core';
export const newCorePackage = '@autorest/core';

const basePkgVersion = semver.parse(pkgVersion.indexOf('-') > -1 ? pkgVersion.substring(0, pkgVersion.indexOf('-')) : pkgVersion);
const versionRange = `~${basePkgVersion.major}.${basePkgVersion.minor}.0`; // the version range of the core package required.

export const networkEnabled: Promise<boolean> = new Promise<boolean>((r, j) => {
  lookup('8.8.8.8', 4, (err, address, family) => {
    r(err ? false : true);
  });
});

export async function availableVersions() {
  if (await networkEnabled) {
    try {
      const vers = (await (await extensionManager).getPackageVersions(newCorePackage)).sort((b, a) => semver.compare(a, b));
      const result = new Array<string>();
      for (const ver of vers) {
        if (semver.satisfies(ver, versionRange)) {
          result.push(ver);
        }
      }
      return result;
    } catch (e) {
      console.info(`No available versions of package ${newCorePackage} found.`);
    }

  } else {
    console.info('Skipping getting available versions because network is not detected.');
  }
  return [];
}


export async function installedCores() {
  const extensions = await (await extensionManager).getInstalledExtensions();
  const result = (extensions.length > 0) ? extensions.filter(ext => (ext.name === newCorePackage || ext.name === oldCorePackage) && semver.satisfies(ext.version, versionRange)) : new Array<Extension>();
  return result.sort((a, b) => semver.compare(b.version, a.version));
}

export function resolvePathForLocalVersion(requestedVersion: string | null): string | null {
  try {
    // untildify!
    if (/^~[/|\\]/g.exec(requestedVersion)) {
      requestedVersion = join(homedir(), requestedVersion.substring(2));
    }
    return requestedVersion ? resolve(requestedVersion) : dirname(require.resolve('@autorest/core/package.json'));
  } catch (e) {
    // fallback to old-core name
    try {
      return dirname(require.resolve('@microsoft.azure/autorest-core/package.json'));
    } catch {
      // no dice
    }
  }
  return null;
}


export async function resolveEntrypoint(localPath: string | null, entrypoint: string): Promise<string | null> {
  try {
    // did they specify the package directory directly 
    if (await isDirectory(localPath)) {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const pkg = require(`${localPath}/package.json`);
      if (pkg.name === 'autorest') {
        // you've tried loading the bootstrapper not the core!
        console.error(`The location you have specified is not autorest-core, it's autorest bootstrapper: ${pkg.name}`);
        process.exit(1);
      }

      if (args.debug) {
        console.log(`Examining AutoRest core package: ${pkg.name}`);
      }

      if (pkg.name === oldCorePackage || pkg.name === newCorePackage) {
        if (args.debug) {
          console.log('Looks like a core package.');
        }
        switch (entrypoint) {
          case 'main':
          case 'main.js':
            entrypoint = pkg.main;
            break;

          case 'language-service':
          case 'language-service.js':
          case 'autorest-language-service':
            entrypoint = pkg.bin['autorest-language-service'];
            break;

          case 'autorest':
          case 'autorest-core':
          case 'app.js':
          case 'app':
            entrypoint = pkg.bin['autorest-core'] || pkg.bin['core'];
            break;

          case 'module':
            // special case: look for the main entrypoint
            // but return the module folder
            if (await isFile(`${localPath}/${pkg.main}`)) {
              if (args.debug) {
                console.log(`special case: '${localPath}/${pkg.main}' .`);
              }
              return localPath.replace(/\\/g, '/');
            }
        }
        const path = `${localPath}/${entrypoint}`;
        if (await isFile(path)) {
          if (args.debug) {
            console.log(`Using Entrypoint: '${localPath}/${entrypoint}' .`);
          }
          return path.replace(/\\/g, '/');
        }
      }
    }
  } catch {
    // no worries
  }
  return null;
}

export async function runCoreOutOfProc(localPath: string | null, entrypoint: string): Promise<any> {
  try {
    const ep = await resolveEntrypoint(localPath, entrypoint);
    if (ep) {
      // Creates the nodejs command to load the target core 
      // - copies the argv parameters
      // - loads our static loader (so the newer loader is used, and we can get to 'chalk' in our static fs) 
      // - loads the js file with coloring (core expects a global function called 'color' )
      // - loads the actual entrypoint that we expect is there. 
      const cmd = `
        process.argv = ${ JSON.stringify(process.argv)};
        if (require('fs').existsSync('${__dirname}/static-loader.js')) { require('${__dirname}/static-loader.js').load('${__dirname}/static_modules.fs'); }
        const { color } = require('${__dirname}/coloring');
        require('${ep}')
      `.replace(/"/g, '\'').replace(/(\\(?![']))+/g, '/');

      const p = spawn(process.execPath, ['-e', cmd], { stdio: ['inherit', 'inherit', 'inherit',] });
      p.on('close', (code, signal) => {
        process.exit(code);
      });
      // set up a promise to wait for the event to fire
      await When(p, 'exit', 'close');
      process.exit(0);
    }
  } catch (E) {
    console.log(E);
  }
  return null;
}

export async function tryRequire(localPath: string | null, entrypoint: string): Promise<any> {
  try {
    const ep = await resolveEntrypoint(localPath, entrypoint);
    if (ep) {
      return require(ep);
    }
  } catch (E) {
    console.log(E);
  }
  return null;
}

export async function ensureAutorestHome() {
  await mkdir(rootFolder);
}

export async function selectVersion(requestedVersion: string, force: boolean, minimumVersion?: string) {
  const installedVersions = await installedCores();
  let currentVersion = installedVersions[0] || null;

  // the consumer can say I want the latest-installed, but at least XXX.XXX
  if (minimumVersion && currentVersion && !semver.satisfies(currentVersion.version, minimumVersion)) {
    currentVersion = null;
  }

  if (currentVersion) {

    if (args.debug) {
      console.log(`The most recent installed version is ${currentVersion.version}`);
    }

    if (requestedVersion === 'latest-installed' || (requestedVersion === 'latest' && false == await networkEnabled)) {
      if (args.debug) {
        console.log(`requesting current version '${currentVersion.version}'`);
      }
      requestedVersion = currentVersion.version;
    }
  } else {
    if (args.debug) {
      console.log(`No ${newCorePackage} (or ${oldCorePackage}) is installed.`);
    }
  }

  let selectedVersion: any = null;
  // take the highest version that satisfies the version range.
  for (const each of installedVersions.sort((a, b) => semver.compare(a?.version, b?.version))) {
    if (semver.satisfies(each.version, requestedVersion)) {
      selectedVersion = each;
    }
  }

  // is the requested version installed?
  if (!selectedVersion || force) {
    if (!force) {
      if (args.debug) {
        console.log(`${requestedVersion} was not satisfied directly by a previous installation.`);
      }
    }

    // if it's not a file, and the network isn't available, we can't continue.
    if (!await isFile(requestedVersion) && !(await networkEnabled)) {
      // no network enabled.
      throw new Exception(`Network access is not available, requested version '${requestedVersion}' is not installed. `);
    }

    // after this point, latest-installed must mean latest.
    if (requestedVersion === 'latest-installed') {
      requestedVersion = 'latest';
    }

    // if they have requested 'latest' -- they really mean latest with same major version number
    if (requestedVersion === 'latest') {
      requestedVersion = versionRange;
    }
    let corePackageName = newCorePackage;

    let pkg: Package;
    try {
      // try the package 
      pkg = await (await extensionManager).findPackage(newCorePackage, requestedVersion);
    } catch {
      // try a prerelease version from github.
      try {
        const rv = requestedVersion.replace(/^[~|^]/g, '');
        pkg = await (await extensionManager).findPackage('core', `https://github.com/Azure/autorest/releases/download/autorest-core-${rv}/autorest-core-${rv}.tgz`);
      } catch {
        // fallback to old package name
        try {
          pkg = await (await extensionManager).findPackage(oldCorePackage, requestedVersion);
        } catch {
          // no package found!
        }
      }
      if (!pkg) {
        throw new Exception(`Unable to find a valid AutoRest core package '${newCorePackage}' @ '${requestedVersion}'.`);
      }
      corePackageName = oldCorePackage;
    }
    if (pkg) {
      if (args.debug) {
        console.log(`Selected package: ${pkg.resolvedInfo.rawSpec} => ${pkg.name}@${pkg.version}`);
      }
    }

    // pkg.version == the actual version 
    // check if it's installed already.
    selectedVersion = await (await extensionManager).getInstalledExtension(corePackageName, pkg.version);

    if (!selectedVersion || force) {
      // this will throw if there is an issue with installing the extension.
      if (args.debug) {
        console.log(`**Installing package** ${corePackageName}@${pkg.version}\n[This will take a few moments...]`);
      }

      selectedVersion = await (await extensionManager).installPackage(pkg, force, 5 * 60 * 1000, installer => installer.Message.Subscribe((s, m) => { if (args.debug) console.log(`Installer: ${m}`); }));
      if (args.debug) {
        console.log(`Extension location: ${selectedVersion.packageJsonPath}`);
      }
    } else {
      if (args.debug) {
        console.log(`AutoRest Core ${pkg.version} is available at ${selectedVersion.modulePath}`);
      }
    }
  }
  return selectedVersion;
}