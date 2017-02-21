#!/usr/bin/env node

import * as https from 'https';
import { parse as parseUrl } from 'url';
import { Asset, Github } from './github'
import { IEnumerable, From } from 'linq-es2015';
import { Utility } from './utility'
import { Installer } from './installer'
import * as semver from 'semver'
import { argv as cli } from 'yargs'

async function main() {
  try {
    // autorest --version=1.0.1-nightly712312 
    // autorest --version=latest 

    // steps:
    // determine the autorest version requested
    // special cases:
    // latest           - latest version from github (prerelease or otherwise)
    // latest-release   - latest released version from github
    // <semver>         - specific version from github
    // (default)        - latest installed version (falls back to latest)

    let version: string = cli.version
    let latestInstalled = Installer.LatestAutorestVersion
    let autorest: string = null;
    let framework: string = null;
    let currentVersion = Installer.LatestAutorestVersion;


    // console.log((await Installer.getReleases(version != 'latest-release')).ToArray());

    if (version == null) {
      if (currentVersion != null) {
        // take the current one installed
        version = currentVersion;
      } else {
        // or, grab the latest version
        version = 'latest'
      }
    }

    if (version.startsWith('latest')) {
      // find out the latest version
      let releases = (await Github.List()).Where(each => semver.valid(each.name, false) != null);

      if (version == 'latest-release') {
        releases = releases.Where(each => each.prerelease == false);
      }

      // the desired version is the latest one in the set.
      version = releases.FirstOrDefault().name;
    }

    // check if that is a valid version to use
    if (!semver.valid(version, false)) {
      // it's not.
      console.log(`Unknown AutoRest Version :'${version}'`)
      // quit.
      process.exit(1);
    }

    // ensure that the framework is Installed
    if (Installer.LatestFrameworkVersion == null) {
      await Installer.InstallFramework();
    }

    // check if it's installed
    if (!Installer.InstalledAutorestVersions.Any(each => each == version)) {
      // install that version
      await Installer.InstallAutoRest(version);
    }

    // call autorest-ng in the target folder

    console.log(`Installed Framework: ${Installer.LatestFrameworkVersion} `);
    console.log(`Installed AutoRest: ${Installer.LatestAutorestVersion} `);
  } catch (exception) {
    console.log(exception);
  }
}

main();
