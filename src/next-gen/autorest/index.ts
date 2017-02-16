import * as https from 'https';
import { parse as parseUrl } from 'url';
import {Asset, Releases} from '../github'
import {IEnumerable, From} from 'linq-es2015';
import {Utility} from '../utility'
import {Installer} from '../installer'

async function main() {
    console.log(`Installed Framework: ${Installer.latestFramework} `);
    console.log(`Installed AutoRest: ${Installer.latestAutorest} `);

    // if( !Installer.IsAutoRestInstalled) {
      //  if(!Installer.IsFrameworkInstalled ) {
            await Installer.InstallFramework();
//        }
        await Installer.InstallAutoRest();
    //}

}

main();
