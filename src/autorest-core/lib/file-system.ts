import * as a from "./async";
import { From } from "./approved-imports/linq"
import * as uri from "./approved-imports/uri"

export interface IFileSystem {
  readonly RootUri: string;
  EnumerateFiles(): AsyncIterable<string>;
  ReadFile(path: string): Promise<string>;
  WriteFile(path: string, content: string): Promise<void>;
}

export class MemoryFileSystem implements IFileSystem {
  public constructor(public RootUri: string, private files: Map<string, string>) {
  }
  public readonly Outputs: Map<string, string> = new Map<string, string>();

  async ReadFile(path: string): Promise<string> {
    if (!this.files.has(path)) {
      throw new Error(`File ${path} is not in the MemoryFileSystem`)
    }
    return <string>this.files.get(path);
  }

  async *EnumerateFiles(): AsyncIterable<string> {
    yield* this.files.keys();
  }

  async WriteFile(path: string, content: string): Promise<void> {
    this.Outputs.set(path, content);
  }
}

export class DiskFileSystem implements IFileSystem {
  public constructor(public RootUri: string) {
  }
  async *EnumerateFiles(): AsyncIterable<string> {
    return await a.readdir(this.RootUri);
  }
  async ReadFile(path: string): Promise<string> {
    return a.readFile(uri.ResolveUri(this.RootUri, path));
  }
  async WriteFile(path: string, content: string): Promise<void> {
    return a.writeFile(path, content);
  }
}

/// this stuff is to force __asyncValues to get emitted: see https://github.com/Microsoft/TypeScript/issues/14725
async function* yieldFromMap(): AsyncIterable<string> {
  yield* ["hello", "world"]
};
async function foo() {
  for await (const each of yieldFromMap()) {
  }
}