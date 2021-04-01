import { parentFolderUri, readUri } from "@azure-tools/uri";
import { IFileSystem } from "../file-system";
import { logger } from "../logger";
import { DataHandle } from "./data-handle";
import { DataSource } from "./data-source";
import { DataStore } from "./data-store";

export class ReadThroughDataSource extends DataSource {
  private uris: Array<string> = [];
  private cache: { [uri: string]: Promise<DataHandle | null> } = {};

  constructor(private store: DataStore, private fs: IFileSystem) {
    super();
  }

  get cachable(): boolean {
    // filesystem based data source can't cache
    return false;
  }

  public async read(uri: string): Promise<DataHandle | null> {
    // sync cache (inner stuff is racey!)
    if (!this.cache[uri]) {
      this.cache[uri] = (async () => {
        // probe data store
        try {
          const existingData = await this.store.Read(uri);
          this.uris.push(uri);
          return existingData;
        } catch (e) {
          // ignore .
        }

        // populate cache
        let data: string | null = null;
        try {
          data = (await this.fs.read(uri)) || (await readUri(uri));
          if (data) {
            const parent = parentFolderUri(uri) || "";
            // hack to let $(this-folder) resolve to the location...
            data = data.replace(/\$\(this-folder\)\/*/g, parent);
          }
        } catch (e) {
          logger.error("Unexpected error trying to read file", e);
        } finally {
          if (!data) {
            // eslint-disable-next-line no-unsafe-finally
            return null;
          }
        }
        const readHandle = await this.store.WriteData(uri, data, "input-file", [uri]);

        this.uris.push(uri);
        return readHandle;
      })();
    }

    return this.cache[uri];
  }

  public async enum(): Promise<Array<string>> {
    return this.uris;
  }
}
