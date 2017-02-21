import * as https from 'https';
import { Enumerable as IEnumerable, From } from 'linq-es2015';
import { parse as parseUrl } from 'url';
import { Utility } from './utility'
import * as request from 'request'

export class Asset {
  url: string;
  id: number;
  name: string;
  label: string;
  content_type: string;
  state: string;
  size: number;
  download_count: number;
  created_at: string;
  updated_at: string;
  browser_download_url: string;
}

export class Author {
  login: string;
  id: number;
  avatar_url: string;
  gravatar_id: string;
  url: string;
  html_url: string;
  followers_url: string;
  following_url: string;
  gists_url: string;
  starred_url: string;
  subscriptions_url: string;
  organizations_url: string;
  repos_url: string;
  events_url: string;
  received_events_url: string;
  type: string;
  site_admin: boolean;
}

export class Release {
  url: string;
  html_url: string;
  assets_url: string;
  upload_url: string;
  tarball_url: string;
  zipball_url: string;
  id: number;
  tag_name: string;
  target_commitish: string;
  name: string;
  body: string;
  draft: boolean;
  prerelease: boolean;
  created_at: string;
  published_at: string;
  author: Author;
}

async function Rest(url: string): Promise<any> {
  return new Promise<string>((resolve, reject) => {
    let stream = request.get(url, {
      strictSSL: true,
      headers: {
        'user-agent': 'autorest-installer',
        "Authorization": `token ${Utility.Id}`
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
      console.log(err);
      reject(err);
    });
  });
}

export class Github {
  static async GetAssets(tag: string): Promise<IEnumerable<Asset>> {
    var response = await Rest(`https://api.github.com/repos/azure/autorest/releases/tags/${tag}`);
    return From(<Array<Asset>>response.assets);
  }

  static async List(): Promise<IEnumerable<Release>> {
    return From<Release>(await Rest(`https://api.github.com/repos/azure/autorest/releases`));
  }

}

