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
import { Npm } from './npmjs';
import { rm } from 'shelljs'
import * as chalk from 'chalk'
import { Console } from './console'
import * as fs from 'fs'

class App {
  private static listAvailable: number = cli['list-available'] ? (Number.isInteger(cli['list-available']) ? cli['list-available'] : 10) : 0;
  private static listInstalled: number = cli['list-installed'] ? (Number.isInteger(cli['list-installed']) ? cli['list-installed'] : 10) : 0;

  private static version: string = cli.version || cli.latest ? 'latest' : cli['latest-release'] ? 'latest-release' : null;
  private static reset: boolean = cli.reset || false;

  private static help: string = cli.help || cli.h || false;
  private static done: boolean = false;

  private static networkEnabled: boolean = true;
  private static pkgVersion: string = require(`${__dirname}/package.json`).version;

  private static currentVersion: string = null;
  private static frameworkVersion: string = null;

  private static get BuildInfo(): string {
    return `> __Build Information__
> Bootstrapper :        __${this.pkgVersion}__
> NetCore framework :   __${this.frameworkVersion || '<none>'}__
> AutoRest core :       __${this.currentVersion || '<none>'}__`;
  }

  private static async GetReleases(): Promise<IEnumerable<Release>> {
    return (await Github.List()).Where(each => semver.valid(each.name, false) != null);
  }

  private static async CheckBootstrapperVersion() {
    if (this.networkEnabled) {
      return Npm.LatestRelease().then(npmversion => {
        if (semver.gt(npmversion, this.pkgVersion)) {
          Console.Log(chalk.yellow.bold(`\nThere is a new version of AutoRest available (${npmversion}).\nInstall with 'npm install autorest -g '.\n`));
        }
      });
    }
  }

  private static ShowHelp() {
    Console.Log(`${this.BuildInfo}

## __Output Verbosity__
  *--verbose*            show verbose output information
  *--debug*              show internal debug information
  *--quiet*              suppress output

## __Versions__
  *--list-installed*     show all installed versions of AutoRest tools
  *--list-available=__nn__*  lists the last nn releases available from github
                        (defaults to 10)

## __Installation__
  *--version=*__version__    uses __version__ of AutoRest, installing if necessary.
                        for __version__ you can  
                        use a version label (see *--list-available*) or
                          __latest__         - get latest nightly build
                          __latest-release__ - get latest release version
  *--reset*              remove all installed versions of AutoRest tools
                        and install the latest (override with *--version*)
                        

## __Using AutoRest__`);
  }

  private static async ListAvailable() {
    if (this.networkEnabled) {
      const releases = (await this.GetReleases()).Take(this.listAvailable);
      let text = `## Last __${this.listAvailable}__ releases available online:`;
      for (let each of releases) {
        text += `\n> ${each.name}`;
      }
      Console.Log(text);
      this.done = true;
    } else {
      Console.Exit('**Unable to check online, network is not available**');
    }
  }

  private static async ListInstalled() {
    if (Installer.LatestAutorestVersion) {
      let text = `## Installed versions of AutoRest :`
      for (let each of await Installer.InstalledAutorestVersions) {
        text += `\n> ${each}`;
      }
      Console.Log(text);
    } else {
      Console.Log('**No AutoRest versions are installed**');
    }
    this.done = true;
  }

  static async main(networkEnabled: boolean) {
    try {
      this.networkEnabled = networkEnabled;
      Console.Debug(`Network Enabled: ${this.networkEnabled}`);

      // Remove bootstrapper args from cmdline
      // process.argv = From<string>(process.argv).Where(each => From<string>(["version", "list-installed", "list-available", "reset", "help"]).Any(i => each == `--${i}`)).ToArray();

      if (this.reset) {
        rm('-rf', Installer.RootFolder);
      }

      // check if we're up to date with the bootstrapper
      let waitable = this.CheckBootstrapperVersion();

      // see what we've got installed.
      this.currentVersion = Installer.LatestAutorestVersion;
      this.frameworkVersion = Installer.LatestFrameworkVersion;

      Console.Log(`# AutoRest`);
      // asking for help
      if (this.help) {
        this.ShowHelp();
        // remove other arguments and send -help o 
        process.argv.length = 2;
        process.argv.push('--help');
      }

      if (this.listAvailable || this.listInstalled) {
        Console.Log(this.BuildInfo);
      }

      if (this.listAvailable) {
        this.ListAvailable();
      }

      if (this.listInstalled) {
        this.ListInstalled();
      }

      // if the command is not to take action, quit peacefully now.
      if (this.done) {
        await waitable;
        process.exit(0);
      }

      // figure out which version to install/use
      if (this.version == null) {
        if (this.currentVersion != null) {
          // take the current one installed
          this.version = this.currentVersion;
          Console.Verbose(`Requested '${this.currentVersion}' version`);
        } else {
          // or, grab the latest version
          this.version = 'latest';
        }
      }

      // if necessary, go get the package we need.
      if (this.networkEnabled) {
        if (this.version.startsWith('latest')) {
          // find out the latest version
          let releases = await this.GetReleases();

          if (this.version == 'latest-release') {
            Console.Verbose('Requested "latest-release" version');
            releases = releases.Where(each => each.prerelease == false);
          } else {
            Console.Verbose('Requested "latest" available version');
          }

          // the desired version is the latest one in the set.
          const selectedVersion = releases.FirstOrDefault();
          if (selectedVersion == null) {
            Console.Exit(`Unable to find a release matching '${this.version}'.`)
          }
          this.version = selectedVersion.name;
        }
      } else {
        // no network, fall back to the latest installed version
        if (this.currentVersion == null) {
          Console.Exit('No network access, and no currently installed versions of AutoRest.');
        }
        this.version = this.currentVersion;

        Console.Verbose(`No network access, falling back to version ${this.version}`);
      }

      // check if that is a valid version to use
      if (!semver.valid(this.version, false)) {
        // it's not.
        Console.Exit(`AutoRest Version :'${this.version}' is not a valid version.`);
      }

      await waitable;

      const installs = new Array<Promise<any>>();

      // ensure that the framework is Installed
      if (Installer.LatestFrameworkVersion == null) {
        Console.Verbose(`Dotnet Framework not installed. Attempting to install it.`);
        installs.push(Installer.InstallFramework().then(txt => {
          if (Installer.LatestFrameworkVersion == null) {
            Console.Exit(`Unable to install dotnet framework (required)`);
          }
        }));
      }

      // check if it's installed
      if (!Installer.InstalledAutorestVersions.Any(each => each == this.version)) {
        Console.Verbose(`AutoRest version '${this.version}' not installed.`);

        installs.push(this.GetReleases().then(releases => {
          if (!releases.Any(each => each.name == this.version)) {
            Console.Exit(`AutoRest version '${this.version}' is not found in the releases feed.`);
          }
          Console.Verbose(`Attempting to install it.`);
          // install that version
          try {
            return Installer.InstallAutoRest(this.version);
          } catch (exception) {
            Console.Exit(`Unable to install AutoRest version '${this.version}'`);
          }
        }));
      }

      await Promise.all(installs);

      // call autorest-core in the target folder
      if (process.argv.length > 2) {
        Console.Debug(process.argv);
        require(join(Installer.AutorestFolder, this.version, 'node_modules', 'autorest-core', 'app.js'));
      } else {
        Console.Log('Use --help to get help information.');
      }
    } catch (exception) {
      Console.Log(exception);
    }
  }
}
// quickly check for network connectivity, and then jump to main.
dns.lookup('8.8.8.8', 4, (err, address, family) => {
  App.main(err == null);
});