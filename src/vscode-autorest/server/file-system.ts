import * as a from '../lib/ref/async'
import { IFileSystem, AutoRest, EventEmitter, IEvent } from "autorest";
import { IConnection, TextDocumentIdentifier, TextDocumentChangeEvent, TextDocuments } from "vscode-languageserver";
import { File } from "./autorest-manager"

export class DocumentContext extends EventEmitter implements IFileSystem {


  private _autoRest: AutoRest | null;
  private get autorest(): AutoRest {
    return this._autoRest || (this._autoRest = new AutoRest(this));
  }

  constructor(public RootUri: string) {
    super();
  }

  public ChangedFile(file: File, contentIsNull: boolean) {

  }

  public async Activate(): Promise<void> {

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

  async *EnumerateFiles(folderUri: string): AsyncIterable<string> {
    if (folderUri && folderUri != "") {
      if (await this.IsValidRoot()) {
        yield* await a.readdir(this.RootUri);
      }
    }
  }

  async ReadFile(path: string): Promise<string> {
    throw new Error('Method not implemented.');
  }
}