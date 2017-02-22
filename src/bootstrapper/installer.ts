
// identify the platform
// common locations
// check for minimums
// options (minimum version)
// 
// 
import * as request from 'request'
import * as fs from 'fs'
import { parse as parseUrl } from 'url';
import { existsSync } from 'fs';
import * as shell from 'shelljs'
import { homedir, tmpdir } from 'os';
import { join } from 'path';
import * as semver from 'semver'
import { Enumerable as IEnumerable, From } from 'linq-es2015';
import { Utility } from './utility'
import { Asset, Github } from './github'
import * as tgz from 'tar.gz2'
import * as https from 'https';
import * as unzip from 'unzipper'

import * as StreamSink from 'streamsink';

export class Installer {
  private static ensureExists(dir: string) {
    if (!existsSync(dir)) {
      shell.mkdir("-p", dir);
    }
    return dir;
  }

  public static get RootFolder(): string {
    return this.ensureExists(join(homedir(), '.autorest'));
  }
  public static get FrameworkFolder(): string {
    return this.ensureExists(join(this.RootFolder, 'frameworks'));
  }
  public static get PluginsFolder(): string {
    return join(this.RootFolder, 'plugins')
  }
  public static get AutorestFolder(): string {
    return this.ensureExists(join(this.PluginsFolder, 'autorest'));
  }
  public static get LatestAutorestVersion(): string {
    return this.InstalledAutorestVersions.FirstOrDefault();
  }
  public static get InstalledAutorestVersions(): IEnumerable<string> {
    return this.GetVersionsInFolder(this.AutorestFolder) || From([]);
  }
  public static get InstalledFrameworkVersions(): IEnumerable<string> {
    return this.GetVersionsInFolder(`${this.FrameworkFolder}/shared/Microsoft.NETCore.App`) || From([]);
  }

  public static get LatestFrameworkVersion(): string {
    return this.InstalledFrameworkVersions.FirstOrDefault();
  }

  public static get dotnet(): string {
    return "";
  }

  public static async InstallFramework() {
    const pi = await Utility.PlatformInformation();
    const fwks = await Github.GetAssets('dotnet-runtime-1.0.3');
    const runtime = fwks.FirstOrDefault(each => each.name.startsWith(`dotnet-${pi.runtimeId}.1.0.3`));

    if (runtime == null) {
      throw `Unable to find framework for ${pi.runtimeId}`
    }

    return new Promise<string>((resolve, reject) => {
      console.log(`Downloading ${runtime.browser_download_url} to ${this.FrameworkFolder}`);
      let download = request.get(runtime.browser_download_url, {
        strictSSL: true,
        headers: {
          'user-agent': 'autorest-installer',
          "Authorization": `token ${Utility.Id}`
        }
      });

      let unpack: any = null;

      if (runtime.name.endsWith('.zip')) {
        unpack = download.pipe(unzip.Extract({ path: this.FrameworkFolder }))
      }
      else {
        unpack = download.pipe(tgz().createWriteStream(this.FrameworkFolder))
      }
      unpack.on('close', resolve);
      unpack.on('error', reject);
    });
  }

  public static async InstallAutoRest(version: string) {
    const asset = (await Github.GetAssets(`v${version}`)).FirstOrDefault();

    if (asset == null) {
      throw `Unable to find asset for version '${version}'`
    }

    const targetFolder = join(this.AutorestFolder, version);

    return new Promise<string>((resolve, reject) => {
      console.log(`Downloading ${asset.browser_download_url} to ${targetFolder}`);
      let download = request.get(asset.browser_download_url, {
        strictSSL: true,
        headers: {
          'user-agent': 'autorest-installer',
          "Authorization": `token ${Utility.Id}`
        }
      });

      let unpack: any = null;

      if (asset.name.endsWith('.zip')) {
        unpack = download.pipe(unzip.Extract({ path: targetFolder }))
      }
      else {
        unpack = download.pipe(tgz().createWriteStream(targetFolder))
      }
      unpack.on('close', resolve);
      unpack.on('error', reject);
    });
  }

  private static GetVersionsInFolder(path: string): IEnumerable<string> {
    return existsSync(path) ? From(shell.ls(path))
      .Select(each => semver.valid(each))
      .Where(each => each != null)
      .OrderBy(each => each, semver.rcompare) : From([]);
  }
}
