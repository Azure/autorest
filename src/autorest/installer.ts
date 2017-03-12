
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
import { Console } from './console';
import * as StreamSink from 'streamsink';

export class Installer {
  private static ensureExists(dir: string) {
    if (!existsSync(dir)) {
      shell.mkdir("-p", dir);
    }
    return dir;
  }

  private static GetFallbackUrl(url: string): string {
    let newurl = url.replace("https://github.com/Azure/autorest/releases/download/", "https://autorest-releases.azureedge.net");
    if (newurl == url) {
      return null;
    }
    return newurl;
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

  private static HttpGet(url: string, filename: string, targetFolder: string, resolve, reject) {
    let download = request.get(url, {
      strictSSL: true,
      headers: {
        'user-agent': 'autorest-installer',
        "Authorization": `token ${Utility.Id}`
      }
    });

    let unpack: any = null;
    if (filename.endsWith('.zip')) {
      unpack = download.pipe(unzip.Extract({ path: targetFolder }))
    }
    else {
      unpack = download.pipe(tgz().createWriteStream(targetFolder))
    }

    unpack.on('end', () => {
      setTimeout(resolve, 100);
    });

    unpack.on('error', () => {
      let newUrl = this.GetFallbackUrl(url);
      if (newUrl == null) {
        Console.Error(`Failed to download file: ${filename}`);
        return reject();
      }
      Console.Error(`Failed to download file: ${filename}, trying fallback url.`);
      this.HttpGet(newUrl, filename, targetFolder, resolve, reject);
    });
  }

  public static async InstallFramework() {
    const pi = await Utility.PlatformInformation();
    const fwks = await Github.GetAssets('dotnet-runtime-1.0.3');
    const runtime = fwks.FirstOrDefault(each => each.name.startsWith(`dotnet-${pi.runtimeId}.1.0.3`));

    if (runtime == null) {
      throw `Unable to find framework for ${pi.runtimeId}`
    }

    return new Promise<string>((resolve, reject) => {
      Console.Log(`Downloading __${runtime.browser_download_url}__ \n        to  __${this.FrameworkFolder}__`);
      this.HttpGet(runtime.browser_download_url, runtime.name, this.FrameworkFolder, resolve, reject);
    });
  }

  public static async InstallAutoRest(version: string) {
    const asset = (await Github.GetAssets(`v${version}`)).FirstOrDefault();

    if (asset == null) {
      throw `Unable to find asset for version '${version}'`
    }

    const targetFolder = join(this.AutorestFolder, version);

    return new Promise<string>((resolve, reject) => {
      Console.Log(`Downloading __${asset.browser_download_url}__ \n        to  __${targetFolder}__`);
      this.HttpGet(asset.browser_download_url, asset.name, targetFolder, resolve, reject);
    });
  }

  private static GetVersionsInFolder(path: string): IEnumerable<string> {
    return existsSync(path) ? From(shell.ls(path))
      .Select(each => semver.valid(each))
      .Where(each => each != null)
      .OrderBy(each => each, semver.rcompare) : From([]);
  }
}
