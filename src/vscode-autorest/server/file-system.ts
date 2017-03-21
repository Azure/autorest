import * as promisify from "pify";
import * as path from "path";
import * as a from '../lib/ref/async'
import { IFileSystem } from "autorest";
import { IConnection, TextDocumentIdentifier } from "vscode-languageserver";

import * as _fs from 'fs';

let fs = promisify(_fs);

export class VSCodeHybridFileSystem implements IFileSystem {

  // if the RootUri is null, this means we're in a folder without a AutoRest config file at all.
  // so, if you want to work on a swagger 
  private _trackedFiles = new Map<string, TextDocumentIdentifier>();

  constructor(private connection: IConnection, public RootUri: string) {
    // track opening and closing documents 
    connection.onDidOpenTextDocument((params) => {
      this._trackedFiles.set(params.textDocument.uri, params.textDocument);
    });

    connection.onDidCloseTextDocument((params) => {
      this._trackedFiles.delete(params.textDocument.uri);
    });

    connection.onDidChangeTextDocument((params) => {
      this._trackedFiles.set(params.textDocument.uri, params.textDocument);
    });
  }

  WriteFile(path: string, content: string): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async IsValidRoot(): Promise<boolean> {
    return this.RootUri && this.RootUri !== "" && await a.isDirectory(this.RootUri);
  }


  // virtualizing the filesystem:
  // on startup, we can look at the filesystem pointed to by the root uri.
  // after that, we should respond to 

  async *EnumerateFiles(): AsyncIterable<string> {
    if (await this.IsValidRoot()) {
      yield* await a.readdir(this.RootUri);

      // if there are any documents open in VSCode, we should 
    }
  }

  async ReadFile(path: string): Promise<string> {
    throw new Error('Method not implemented.');
  }
}