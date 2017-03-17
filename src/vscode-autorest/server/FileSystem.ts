import * as promisify from "pify";
import { IFileSystem } from "autorest";
import { IConnection } from "vscode-languageserver";

import * as _fs from 'fs';

let fs = promisify(_fs);

export class VSCodeHybridFileSystem implements IFileSystem {
  private _rootUri: string;
  private _connection: IConnection;

  get RootUri(): string {
    return this._rootUri;
  }

  constructor(connection: IConnection, rootUri: string) {
    this._rootUri = rootUri;
  }

  // virtualizing the filesystem:
  // on startup, we can look at the filesystem pointed to by the root uri.
  // after that, we should respond to 

  async Scan(): Promise<void> {

  }

  async *EnumerateFiles(prefix: string): AsyncIterable<string> {

    try {
      var x = await fs.readdir(this._rootUri)

    } catch (ex) {
      // can't get files from that!
    }
  }

  async ReadFile(path: string): Promise<string> {
    throw new Error('Method not implemented.');
  }
}