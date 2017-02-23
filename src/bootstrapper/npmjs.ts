import * as https from 'https';
import { Enumerable as IEnumerable, From } from 'linq-es2015';
import { parse as parseUrl } from 'url';
import { Utility } from './utility'
import * as request from 'request'
import * as semver from "semver";
import { Console } from './console';

async function Rest(url: string): Promise<any> {
  return new Promise<string>((resolve, reject) => {
    let stream = request.get(url, {
      strictSSL: true,
      timeout: 15000,
      headers: {
        'user-agent': 'autorest-installer',
      }
    });

    let responseString = '';

    stream.on('data', (data => {
      responseString += data;
    }));

    stream.on('end', () => {
      resolve(JSON.parse(responseString));
    });

    stream.on('error', (err) => {
      Console.Error(`${err}`);
      reject(err);
    });
  });
}

export class DistTags {
  latest: string;
}

export class NodePackage {
  name: string;
  description: string;
  "dist-tags": DistTags;
  public get distTags(): DistTags {
    return this["dist-tags"];
  }
}

export class Npm {

  static async LatestRelease(): Promise<string> {
    const response = await Rest(`https://registry.npmjs.org/autorest`);
    return semver.valid((<NodePackage>response)["dist-tags"].latest);
  }

}