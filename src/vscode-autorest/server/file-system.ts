import * as promisify from "pify";
import * as path from "path";

import { IFileSystem } from "autorest";
import { IConnection } from "vscode-languageserver";

import * as _fs from 'fs';

let fs = promisify(_fs);

export class VSCodeHybridFileSystem implements IFileSystem {
  WriteFile(path: string, content: string): Promise<void> {
    throw new Error('Method not implemented.');
  }

  private _rootUri: string;
  private _connection: IConnection;

  private async exists(dir: string): Promise<boolean> {
    try {
      let s: _fs.Stats = await fs.stat(dir);
      return s.isDirectory();
    } catch (x) {
    }
    return false;
  }

  get RootUri(): string {
    return this._rootUri;
  }

  async IsValidRoot(): Promise<boolean> {
    if (this._rootUri != null && this._rootUri !== "") {
      return this.exists(this._rootUri);
    }
    return false;
  }

  constructor(connection: IConnection, rootUri: string) {
    this._rootUri = rootUri;
  }

  // virtualizing the filesystem:
  // on startup, we can look at the filesystem pointed to by the root uri.
  // after that, we should respond to 

  async *EnumerateFiles(): AsyncIterable<string> {
    return [];
    /* if (this.IsValidRoot()) {
      if (!this._folders.has(prefix)) {
        var dir = path.join(this.RootUri, prefix);
        if( await this.exists( dir ) ) {
          // yes, there is a folder there.
          dir
        }
      }
    }
  


    if( !this._folders.has(prefix)) {
      path.join(_rootUr)
      this._folders
    }
    try {
      var x = await fs.readdir(this._rootUri)

    } catch (ex) {
      // can't get files from that!
    }*/
  }

  async ReadFile(path: string): Promise<string> {
    throw new Error('Method not implemented.');
  }
}