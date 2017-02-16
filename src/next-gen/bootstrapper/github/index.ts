import * as https from 'https';
import {Enumerable as IEnumerable, From} from 'linq-es2015';
import { parse as parseUrl } from 'url';
import {Utility} from '../utility'

export class Asset { 
    url:string;
    id:number;
    name:string;
    label: string;
    content_type: string;
    state: string;
    size: number;
    download_count: number;
    created_at: string;
    updated_at:string;
    browser_download_url:string;
}

async function Rest(url:string): Promise<any> {
    return new Promise<string>( (resolve, reject) => {
        var u = parseUrl(url);
        var req = https.request({
            host:u.host,
            method:"GET",
            protocol:u.protocol,
            headers: {"user-agent": "autorest", "Authorization": `token ${Utility.Id}`
         },
            path:u.path,        
            }, (res)=> {
            res.setEncoding('utf-8');
            var responseString = '';

            res.on('data', (data) => {
                responseString += data;
            });

            res.on('end', ()=> {
                resolve(JSON.parse(responseString));
            });

            res.on('error', (err) => {
                console.log(err);
                reject(err);
            }) 
        });
        req.end();
    });
}

export class Releases {

   static async GetAssets(tag:string):Promise<IEnumerable<Asset>> {
    var response = await Rest( `https://api.github.com/repos/azure/autorest/releases/tags/${tag}`);
    return From(<Array<Asset>>response.assets);
  }

  static async List():Promise<IEnumerable<string>> {
    var items = From<any>( await Rest( `https://api.github.com/repos/azure/autorest/releases`) );
    return items.Select( each => each.name );
  }


}

