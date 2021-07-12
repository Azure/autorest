import { QuickDataSource, DataSource, DataHandle, DataSink } from "@azure-tools/datastore";

import { tmpdir } from "os";
import { join } from "path";
import { isDirectory, readdir, mkdir, writeFile, readFile } from "@azure-tools/async-io";
import { createHash } from "crypto";

const md5 = (content: any) => createHash("md5").update(JSON.stringify(content)).digest("hex");

let cacheFolder: string | undefined;
async function getCacheFolder() {
  if (!cacheFolder) {
    cacheFolder = join(tmpdir(), "autorest-cache");
    if (!(await isDirectory(cacheFolder))) {
      await mkdir(cacheFolder);
    }
  }
  return cacheFolder;
}

export async function writeCache(key: string, dataSource: DataSource) {
  // write the contents out to the cache under the key given
  const all = <any>[];
  const folder = join(await getCacheFolder(), key);

  for (const each of await dataSource.Enum()) {
    const content = await dataSource.Read(each);
    if (content) {
      if (!(await isDirectory(folder))) {
        await mkdir(folder);
      }
      all.push(writeFile(join(folder, md5(each)), await content.serialize()));
    }
  }
  await Promise.all(all);
}

export async function readCache(key: string | undefined, sink: DataSink): Promise<DataSource> {
  if (key) {
    // check for the temp file that correlates to the key
    const folder = join(await getCacheFolder(), key);
    if (await isDirectory(folder)) {
      const handles = new Array<DataHandle>();

      if (await isDirectory(folder)) {
        for (const each of await readdir(folder)) {
          const item = JSON.parse(await readFile(join(folder, each)));
          const dh = await sink.writeData(item.key, item.content, item.identity, item.artifactType);
          handles.push(dh);
        }
      }
      return new QuickDataSource(handles, {});
    }
  }
  return new QuickDataSource([], {});
}

export async function isCached(key?: string) {
  if (key) {
    // check for the temp file that correlates to the key
    const folder = join(await getCacheFolder(), key);
    if (await isDirectory(folder)) {
      return true;
    }
  }
  return false;
}
