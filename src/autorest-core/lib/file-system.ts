import { FileUriToPath } from "./ref/uri";
import { WriteString } from "./ref/writefs";
import * as a from "./async";
import { From } from "./ref/linq";
import { ResolveUri, ReadUri } from "./ref/uri";

export interface IFileSystem {
  EnumerateFileUris(): AsyncIterable<string>;
  ReadFile(uri: string): Promise<string>;
  WriteFile(uri: string, content: string): Promise<void>;
}

export class MemoryFileSystem implements IFileSystem {
  public constructor(public RootUri: string, private files: Map<string, string>) {
  }
  public readonly Outputs: Map<string, string> = new Map<string, string>();

  async ReadFile(uri: string): Promise<string> {
    if (!this.files.has(uri)) {
      throw new Error(`File ${uri} is not in the MemoryFileSystem`);
    }
    return <string>this.files.get(uri);
  }

  async *EnumerateFileUris(): AsyncIterable<string> {
    yield* this.files.keys();
  }

  async WriteFile(uri: string, content: string): Promise<void> {
    this.Outputs.set(uri, content);
  }
}

export class RealFileSystem implements IFileSystem {
  public constructor(public RootUri: string) {
  }

  async *EnumerateFileUris(): AsyncIterable<string> {
    if (this.RootUri.startsWith("file:")) {
      yield* From(await a.readdir(FileUriToPath(this.RootUri))).Select(f => ResolveUri(this.RootUri, f));
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