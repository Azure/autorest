import { IFileSystem } from "./file-system";

export class CachingFileSystem implements IFileSystem {
  protected cache = new Map<string, string | Error>();
  constructor(protected actualFileSystem: IFileSystem) {}

  public list(folderUri: string): Promise<Array<string>> {
    return this.actualFileSystem.list(folderUri);
  }

  public async read(uri: string): Promise<string> {
    const content = this.cache.get(uri);
    if (content !== undefined) {
      if (typeof content === "string") {
        return content;
      }
      throw content;
    }
    try {
      const data = await this.actualFileSystem.read(uri);
      this.cache.set(uri, data);
      return data;
    } catch (E) {
      // not available, but remember that.
      this.cache.set(uri, E);
      throw E;
    }
  }

  /**
   * @deprecated
   */
  public EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return this.list(folderUri);
  }

  /**
   * @deprecated
   */
  public async ReadFile(uri: string): Promise<string> {
    return this.read(uri);
  }
}
