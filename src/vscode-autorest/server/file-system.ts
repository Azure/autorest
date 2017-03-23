import { ManipulateObject } from '../../autorest-core/lib/pipeline/object-manipulator';
import * as a from '../lib/ref/async'
import { IFileSystem, AutoRest, EventEmitter, IEvent } from "autorest";
import { IConnection, TextDocumentIdentifier, TextDocumentChangeEvent, TextDocuments } from "vscode-languageserver";
import { File, AutoRestManager } from "./autorest-manager"
import { From } from "../lib/ref/linq"
import { ResolveUri, FileUriToPath } from "../lib/ref/uri";

export class DocumentContext extends EventEmitter implements IFileSystem {
  private _autoRest: AutoRest | null;
  private _readyToRun: NodeJS.Timer | null = null;
  private _fileSubscriptions = new Map<File, () => void>();
  public cancel: () => void | null = null;

  private get autorest(): AutoRest {
    return this._autoRest || (this._autoRest = new AutoRest(this));
  }

  constructor(public Manager: AutoRestManager, public RootUri: string, public configurationFile?: string) {
    super();
  }

  public Track(file: File) {
    if (!this._fileSubscriptions.has(file)) {
      this._fileSubscriptions.set(file, file.Changed.Subscribe((f, isnull) => this.Activate()));
    }
  }

  public Activate(): Promise<void> {
    return new Promise<void>((r, j) => {
      // tell autorest that it's view needs to be re-created.
      this.autorest.Invalidate()

      // if autorest is about to restart the work, stop that
      // so we can push it out a bit more.
      if (this._readyToRun) {
        clearTimeout(this._readyToRun);
        this._readyToRun = null;
      }

      // queue up the AutoRest restart
      this._readyToRun = setTimeout(() => {
        // clear the 
        for (let each of this._fileSubscriptions.keys()) {
          each.ClearDiagnostics();
        }

        var process = this.autorest.Process();
        process.finish.then(r());
        this.cancel = process.cancel;

      }, 25);

    });
  }

  async *EnumerateFileUris(folderUri: string): AsyncIterable<string> {
    if (folderUri && folderUri.startsWith("file:")) {
      yield* From(await a.readdir(FileUriToPath(folderUri))).Select(f => ResolveUri(folderUri, f));
    }
  }

  async ReadFile(fileUri: string): Promise<string> {
    let file = (await this.Manager.AcquireTrackedFile(fileUri));
    if (this._autoRest) {
      // track this because it looks like we're being asked for the file during process()
      this.Track(file);
    }
    return file.content;
  }
}