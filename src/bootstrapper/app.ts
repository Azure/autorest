#!/usr/bin/env node

import * as https from 'https';
import { parse as parseUrl } from 'url';
import { Asset, Release, Github } from './github'
import { Enumerable as IEnumerable, From } from 'linq-es2015';
import { Utility } from './utility'
import { Installer } from './installer'
import * as semver from 'semver'
import { argv as cli } from 'yargs'
import { join } from 'path';
import * as dns from 'dns';
import { Npm } from './npm';

class App {
  private static list: number = cli.list ? (Number.isInteger(cli.list) ? cli.list : 10) : 0;
  private static debug: boolean = cli.debug;
  private static verbose: boolean = cli.verbose;
  private static version: string = cli.version;
  private static networkEnabled: boolean = true;
  private static pkgVersion: string = "0.9.1";

  private static Log(text: string) {
    console.log(text);
  }

  private static Debug(text: string) {
    if (this.debug) {
      console.log(text);
    }
  }

  private static Verbose(text: string) {
    if (this.verbose) {
      console.log(text);
    }
  }

  private static async GetReleases(): Promise<IEnumerable<Release>> {
    return (await Github.List()).Where(each => semver.valid(each.name, false) != null);
  }

  static async main(networkEnabled: boolean) {
    this.networkEnabled = networkEnabled;
    this.Verbose(`Network Enabled: ${this.networkEnabled}`);

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

      let currentVersion = Installer.LatestAutorestVersion;

      if (this.version == null) {
        if (currentVersion != null) {
          // take the current one installed
          this.version = currentVersion;
          this.Verbose(`Requested '${currentVersion}' version`);
        } else {
          // or, grab the latest version
          this.version = 'latest';
        }
      }

      if (this.networkEnabled) {
        var npmversion = await Npm.LatestRelease();
        if (semver.gt(npmversion, this.pkgVersion)) {
          this.Log(`There is a new version of AutoRest available (${npmversion}).\nInstall with 'npm -g install autorest'.`)
        }

        if (this.list) {
          const releases = (await this.GetReleases()).Take(10);
          this.Log(`Last ${this.list} releases`)
          for (let each of releases) {
            this.Log(` ${each.name}`);
          }
        }

        if (this.version.startsWith('latest')) {
          // find out the latest version
          let releases = await this.GetReleases();

          if (this.version == 'latest-release') {
            this.Verbose("Requested 'latest-release' version");
            releases = releases.Where(each => each.prerelease == false);
          } else {
            this.Verbose("Requested 'latest' available version");
          }

          // the desired version is the latest one in the set.
          const selectedVersion = releases.FirstOrDefault();
          if (selectedVersion == null) {
            this.Log(`Unable to find a release matching '${this.version}'.`)
            // quit.
            process.exit(6);
          }
          this.version = selectedVersion.name;
        }
      } else {
        // no network, fall back to the latest installed version
        if (currentVersion == null) {
          this.Log("No network access, and no currently installed versions of AutoRest.")
          // quit.
          process.exit(2);
        }
        this.version = currentVersion;

        this.Verbose(`No network access, falling back to version ${this.version}`);
      }

      // check if that is a valid version to use
      if (!semver.valid(this.version, false)) {
        // it's not.
        this.Log(`Unknown AutoRest Version :'${this.version}'`);
        // quit.
        process.exit(1);
      }

      // ensure that the framework is Installed
      if (Installer.LatestFrameworkVersion == null) {
        this.Verbose(`Dotnet Framework not installed. Attempting to install it.`);
        await Installer.InstallFramework();
      }

      if (Installer.LatestFrameworkVersion == null) {
        this.Log(`Unable to install dotnet framework (required)`);
        // quit.
        process.exit(3);
      }

      // check if it's installed
      if (!Installer.InstalledAutorestVersions.Any(each => each == this.version)) {
        this.Verbose(`AutoRest version '${this.version}' not installed.`);

        let releases = await this.GetReleases();
        if (!releases.Any(each => each.name == this.version)) {
          this.Log(`AutoRest version '${this.version}' is not found in the releases feed.`);
          process.exit(7);
        }

        this.Verbose(`Attempting to install it.`);
        // install that version
        try {
          await Installer.InstallAutoRest(this.version);
        } catch (exception) {
          this.Log(`Unable to install AutoRest version '${this.version}'`);
          // quit.
          process.exit(4);
        }
      }

      // call autorest-app in the target folder
      require(join(Installer.AutorestFolder, this.version, "node_modules", "autorest-app", "app.js"));
      // console.log(`Installed Framework: ${Installer.LatestFrameworkVersion} `);
      // console.log(`Installed AutoRest: ${Installer.LatestAutorestVersion} `);
    } catch (exception) {
      console.log(exception);
    }
  }
}
// quickly check for network connectivity, and then jump to main.
dns.lookup('8.8.8.8', 4, (err, address, family) => {
  App.main(err == null)
});