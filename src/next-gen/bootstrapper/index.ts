#!/usr/bin/env node

import * as https from 'https';
import { parse as parseUrl } from 'url';
import {Asset, Releases} from './github'
import {IEnumerable, From} from 'linq-es2015';
import {Utility} from './utility'
import {Installer} from './installer'
import * as semver from 'semver'
import * as yargs from 'yargs'



async function main() {
    
    // autorest --version=1.0.1-nightly712312 
    // autorest --version=latest 
    
    // steps:
    // determine the autorest version requested
    // special cases:
        // latest           - latest version from github (prerelease or otherwise)
        // latest-release   - latest released version from github
        // <semver>         - specific version from github
        // (default)        - latest installed version (falls back to latest)

    let version:string = yargs.version
    let latestInstalled = Installer.latestAutorest
    let autorest:string = null;
    let framework:string = null;
    let v = Installer.latestAutorest;

    if( version == null || version == null) {
        if( v != null) {
            autorest = v;
        }
        version = 'latest'
    }

    if( version.startsWith('latest')) {
        // find out the latest version
        let releases= await Installer.getReleases(version != 'latest-release');

        // check if it's installed
        // install it if needed
        
    } else if ( version == 'latest-release' ) {
        // find out the latest release version
        // check if it's installed
        // install it if needed
    }

    // ensure that the requested version is installed 
    try { 
        let sv = new semver.SemVer(version, false);

    } catch (ex) {
        // no worries.

    }
    await Installer.InstallAutoRest();
    // ensure that the framework is Installed
    await Installer.InstallFramework();

    // call autorest-ng in the target folder
    

    console.log(`Installed Framework: ${Installer.latestFramework} `);
    console.log(`Installed AutoRest: ${Installer.latestAutorest} `);

    // if( !Installer.IsAutoRestInstalled) {
      //  if(!Installer.IsFrameworkInstalled ) {
        //     await Installer.InstallFramework();
//        }
//         await Installer.InstallAutoRest();
    //}
}

async function InstallLatest(release:Boolean): Promise<string> {

    return null;
}

async function Run(version:string) {

}

main();
