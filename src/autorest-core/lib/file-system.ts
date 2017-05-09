import { EnumerateFiles, ExistsUri } from './ref/uri';
import { From } from "./ref/linq";
import * as a from "./ref/async";
import { ResolveUri, ReadUri, WriteString } from "./ref/uri";
import * as Constants from "./constants";

export interface IFileSystem {
  EnumerateFileUris(folderUri: string): AsyncIterable<string>;
  ReadFile(uri: string): Promise<string>;
}

export class MemoryFileSystem implements IFileSystem {
  public static readonly DefaultVirtualRootUri = "file:///";
  private filesByUri: Map<string, string>;

  public constructor(files: Map<string, string>) {
    this.filesByUri = new Map<string, string>(
      From(files.entries()).Select(entry => [
        ResolveUri(MemoryFileSystem.DefaultVirtualRootUri, entry[0]),
        entry[1]
      ] as [string, string]));
  }
  public readonly Outputs: Map<string, string> = new Map<string, string>();

  async ReadFile(uri: string): Promise<string> {
    if (!this.filesByUri.has(uri)) {
      throw new Error(`File ${uri} is not in the MemoryFileSystem`);
    }
    return <string>this.filesByUri.get(uri);
  }

  async *EnumerateFileUris(folderUri: string = MemoryFileSystem.DefaultVirtualRootUri): AsyncIterable<string> {
    yield* From(this.filesByUri.keys()).Where(uri => {
      // in folder?
      if (!uri.startsWith(folderUri)) {
        return false;
      }

      // not in subfolder?
      return uri.substr(folderUri.length).indexOf("/") === -1;
    });
  }

  async WriteFile(uri: string, content: string): Promise<void> {
    this.Outputs.set(uri, content);
  }
}

export class RealFileSystem implements IFileSystem {
  public constructor() {
  }

  EnumerateFileUris(folderUri: string): AsyncIterable<string> {
    return EnumerateFiles(folderUri, [
      Constants.DefaultConfiguratiion
    ]);
  }
  async ReadFile(uri: string): Promise<string> {
    return ReadUri(uri);
  }
  async WriteFile(uri: string, content: string): Promise<void> {
    return WriteString(uri, content);
  }
}