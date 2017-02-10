
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
import {homedir, tmpdir} from 'os';
import {join} from 'path';
import * as semver from 'semver'
import {Enumerable as IEnumerable, From} from 'linq-es2015';
import {Utility} from '../utility'
import {Asset, Releases} from '../github'
import * as tgz from 'tar.gz2'
import * as https from 'https';
import * as unzip from 'unzipper'

import * as StreamSink from 'streamsink';

export class Installer {
  public static get rootFolder(): string {
    return join (homedir(),'.autorest' );
  }
  public static get framework(): string { 
    return join( this.rootFolder, 'frameworks' )
  }
  public static get app(): string { 
    return join( this.rootFolder, 'app' )
  }
  public static get autorest(): string { 
    return join( this.app, 'autorest' )
  }

  public static get latestAutorest(): string { 
    return this.GetFolders(this.autorest).FirstOrDefault();
  }

  public static get latestFramework(): string { 
    return this.GetFolders(`${this.framework}/shared/Microsoft.NETCore.App`).FirstOrDefault();
  }

  public static get dotnet() : string {
    return "";
  }
  public static getReleases():IEnumerable<string> {
    return null;
  }

  public static IsAutoRestInstalled() :Boolean {
    return this.latestAutorest != null;
  }

  public static IsFrameworkInstalled(): Boolean { 
    return this.latestFramework != null;
  }

  public static async InstallFramework() {
    if( !existsSync(this.framework) ) {
      shell.mkdir(this.framework);
    }
    const pi = await Utility.PlatformInformation();
    const fwks = await Releases.GetAssets('dotnet-runtime-1.0.3');
    const runtime = fwks.FirstOrDefault( each => each.name.startsWith( `dotnet-${pi.runtimeId}.1.0.3` ) );

    if( runtime == null ) {   
      throw `Unable to find framework for ${pi.runtimeId}`
    }
    
    return new Promise<string>((resolve, reject)=>{
      console.log(`Downloading ${runtime.browser_download_url} to ${this.framework}`);
      let download = request.get(runtime.browser_download_url,{strictSSL:true,headers:{'user-agent':'autorest-installer',"Authorization": "token 4a16a53b6f60d86e0626bf525c84767e8271c5f1"}});
      let unpack:any = null;

      if( runtime.name.endsWith('.zip' )) {
        unpack = download.pipe(unzip.Extract({ path: this.framework }))
      }
      else {
        unpack = download.pipe( tgz().createWriteStream(this.framework) )
      }
      unpack.on('close', resolve );
      unpack.on('error', reject );
      });
  }

  public static async InstallAutoRest() {
    if( !existsSync(this.autorest) ) {
      shell.mkdir(this.autorest);
    }
  }

  private static GetFolders(path:string):IEnumerable<string> {
    return existsSync(path) ? From(shell.ls(path))
      .Select( each => semver.valid(each))
      .Where( each => each!=null)
      .OrderBy( each => each, semver.rcompare) : From([]);
  }

  
}
