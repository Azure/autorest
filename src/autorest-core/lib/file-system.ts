import * as a from "./async";
import { From } from "./approved-imports/linq"

export interface IFileSystem {
  readonly RootUri: string;
  EnumerateFiles(): AsyncIterator<string>;
  ReadFile(path: string): Promise<string>;
  WriteFile(path: string, content: string): Promise<void>;
}

export class MemoryFileSystem implements IFileSystem {
  public constructor(public RootUri: string, private files: Map<string, string>) {
  }
  public readonly Outputs: Map<string, string> = new Map<string, string>();

  async *EnumerateFiles(): AsyncIterator<string> {
    return this.files.keys;
  }
  async ReadFile(path: string): Promise<string> {
    return a.readFile(path);
  }
  async WriteFile(path: string, content: string): Promise<void> {
    this.Outputs.set(path, content);
  }
}

export class DiskFileSystem implements IFileSystem {
  public constructor(public RootUri: string) {
  }
  async *EnumerateFiles(): AsyncIterator<string> {
    return await a.readdir(this.RootUri);
  }
  async ReadFile(path: string): Promise<string> {
    return a.readFile(path);
  }
  async WriteFile(path: string, content: string): Promise<void> {
    return a.writeFile(path, content);
  }
}