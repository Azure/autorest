import { EnumerateFiles, WriteString } from "@azure-tools/uri";
import { IFileSystem, readUriWithRetries } from "./file-system";
import * as Constants from "../constants";

export class RealFileSystem implements IFileSystem {
  public constructor() {}

  public list(folderUri: string): Promise<Array<string>> {
    return EnumerateFiles(folderUri, [Constants.DefaultConfiguration]);
  }

  public async read(uri: string): Promise<string> {
    try {
      return await readUriWithRetries(uri);
    } catch (e) {
      console.error("E", Object.getOwnPropertyNames(e));
      console.error(e.code);
      console.error(e.constructor.name);
      throw e;
    }
  }

  public async write(uri: string, content: string): Promise<void> {
    return WriteString(uri, content);
  }

  /**
   * @deprecated
   */
  public async ReadFile(uri: string): Promise<string> {
    return this.read(uri);
  }

  /**
   * @deprecated
   */
  public async EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return this.list(folderUri);
  }
}
