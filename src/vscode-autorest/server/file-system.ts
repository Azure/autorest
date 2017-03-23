import { normalizeUnits } from 'moment';
import { ManipulateObject } from '../../autorest-core/lib/pipeline/object-manipulator';
import * as a from '../lib/ref/async'
import { IFileSystem, AutoRest, EventEmitter, IEvent } from "autorest";
import { IConnection, TextDocumentIdentifier, TextDocumentChangeEvent, TextDocuments } from "vscode-languageserver";
import { File, AutoRestManager } from "./autorest-manager"
import { From } from "../lib/ref/linq"
import { CreateFileUri, FileUriToPath, NormalizeUri, ResolveUri } from '../lib/ref/uri';

export class DocumentContext extends EventEmitter implements IFileSystem {
  private _autoRest: AutoRest | null;
  private _readyToRun: NodeJS.Timer | null = null;
  private _fileSubscriptions = new Map<File, () => void>();
  public cancel: () => void = () => { };

  private get autorest(): AutoRest {
    if (!this._autoRest) {
      this._autoRest = new AutoRest(this);
      this.Manager.listenForResults(this._autoRest);
      this._autoRest.Finished.Subscribe((autorest, success) => {
        this.Manager.log(`AutoRest Process Finished with '${success}'.`);
      })
    }
    return this._autoRest || (this._autoRest = new AutoRest(this));
  }

  constructor(public Manager: AutoRestManager, public RootUri: string, public configurationFile?: string) {
    super();
    this.RootUri = NormalizeUri(this.RootUri);
  }

  public Track(file: File) {
    if (!this._fileSubscriptions.has(file)) {
      this._fileSubscriptions.set(file, file.Changed.Subscribe((f, isnull) => this.Activate()));
    }
  }


  public Activate(): Promise<void> {
    // tell autorest that it's view needs to be re-created.
    this.Manager.log(`Invalidating Autorest view.`);
    this.autorest.Invalidate();
    this.cancel();

    // if autorest is about to restart the work, stop that
    // so we can push it out a bit more.
    if (this._readyToRun) {
      clearTimeout(this._readyToRun);
      this._readyToRun = null;
    }

    this.Manager.log(`Queueing up Autorest to process.`);
    return new Promise<void>((r, j) => {
      // queue up the AutoRest restart
      this._readyToRun = setTimeout(() => {
        // clear the 
        this.Manager.log(`Clearing diagnostics.`);
        for (let each of this._fileSubscriptions.keys()) {
          each.ClearDiagnostics();
        }

        this.Manager.log(`Staring AutoRest Process().`);
        var process = this.autorest.Process();
        process.finish.then(r);
        this.cancel = () => {
          process.cancel();
          this.Manager.log(`Cancelling AutoRest Process().`);
          this.cancel = () => { }
        };
      }, 25);
    });
  }

  async *EnumerateFileUris(folderUri: string): AsyncIterable<string> {
    folderUri = NormalizeUri(folderUri)
    if (folderUri && folderUri.startsWith("file:")) {
      yield* From(await a.readdir(FileUriToPath(folderUri))).Select(f => ResolveUri(folderUri, f));
    }
  }

  async ReadFile(fileUri: string): Promise<string> {
    fileUri = NormalizeUri(fileUri);

    let file = (await this.Manager.AcquireTrackedFile(fileUri));
    if (this._autoRest) {
      // track this because it looks like we're being asked for the file during process()
      this.Track(file);
    }
    return file.content;
  }
}