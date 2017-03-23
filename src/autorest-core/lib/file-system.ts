import { FileUriToPath } from "./ref/uri";
import { WriteString } from "./ref/writefs";
import * as a from "./async";
import { From } from "./ref/linq";
import { ResolveUri, ReadUri } from "./ref/uri";

export interface IFileSystem {
  EnumerateFileUris(folderUri: string): AsyncIterable<string>;
  ReadFile(uri: string): Promise<string>;
  WriteFile(uri: string, content: string): Promise<void>;
}

export class MemoryFileSystem implements IFileSystem {
  public constructor(private files: Map<string, string>) {
  }
  public readonly Outputs: Map<string, string> = new Map<string, string>();

  async ReadFile(uri: string): Promise<string> {
    if (!this.files.has(uri)) {
      throw new Error(`File ${uri} is not in the MemoryFileSystem`);
    }
    return <string>this.files.get(uri);
  }

  async *EnumerateFileUris(folderUri: string): AsyncIterable<string> {
    yield* From(this.files.keys()).Where(uri => {
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

  async *EnumerateFileUris(folderUri: string): AsyncIterable<string> {
    if (folderUri.startsWith("file:")) {
      yield* From(await a.readdir(FileUriToPath(folderUri))).Select(f => ResolveUri(folderUri, f));
    }
  }
  async ReadFile(uri: string): Promise<string> {
    return ReadUri(uri);
  }
  async WriteFile(uri: string, content: string): Promise<void> {
    return WriteString(uri, content);
  }
}

/// this stuff is to force __asyncValues to get emitted: see https://github.com/Microsoft/TypeScript/issues/14725
async function* yieldFromMap(): AsyncIterable<string> {
  yield* ["hello", "world"];
};
async function foo() {
  for await (const each of yieldFromMap()) {
  }
}