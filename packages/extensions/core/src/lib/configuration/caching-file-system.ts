import { IFileSystem } from "@azure-tools/datastore";

export class CachingFileSystem implements IFileSystem {
  protected cache = new Map<string, string | Error>();

  constructor(protected actualFileSystem: IFileSystem) {}
  EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return this.actualFileSystem.EnumerateFileUris(folderUri);
  }
  async ReadFile(uri: string): Promise<string> {
    const content = this.cache.get(uri);
    if (content !== undefined) {
      if (typeof content === "string") {
        return content;
      }
      throw content;
    }
    try {
      const data = await this.actualFileSystem.ReadFile(uri);
      this.cache.set(uri, data);
      return data;
    } catch (E) {
      // not available, but remember that.
      this.cache.set(uri, E);
      throw E;
    }
  }
}
