import * as a from '../lib/ref/async'
import { IFileSystem, AutoRest, EventEmitter, IEvent } from "autorest";

import { IConnection, TextDocumentIdentifier, TextDocumentChangeEvent, TextDocuments } from "vscode-languageserver";
import { File, AutoRestManager, connection } from "./autorest-manager"
import { From } from "../lib/ref/linq"
import { CreateFileUri, FileUriToPath, NormalizeUri, ResolveUri, GetExtension } from '../lib/ref/uri';

import * as path from "path"

export class DocumentContext extends EventEmitter implements IFileSystem {
  private _autoRest: AutoRest | null;
  private _readyToRun: NodeJS.Timer | null = null;
  private _fileSubscriptions = new Map<File, () => void>();
  public cancel: () => boolean = () => true;

  private get autorest(): AutoRest {
    if (!this._autoRest) {
      this._autoRest = new AutoRest(this);
      this.Manager.listenForResults(this._autoRest);
      this._autoRest.Finished.Subscribe((autorest, success) => {
        this.Manager.verbose(`AutoRest Process Finished with '${success}'.`);
      })
    }
    return this._autoRest || (this._autoRest = new AutoRest(this));
  }

  constructor(public Manager: AutoRestManager, public RootUri: string, public configurationFile?: string) {
    super();
    this.RootUri = NormalizeUri(this.RootUri + "/");
  }

  public Track(file: File) {
    if (!this._fileSubscriptions.has(file)) {
      this._fileSubscriptions.set(file, file.Changed.Subscribe((f, isnull) => this.Activate()));
    }
  }


  public async Activate(): Promise<void> {
    // tell autorest that it's view needs to be re-created.
    this.Manager.verbose(`Invalidating Autorest view.`);
    this.autorest.Invalidate();

    // reaquire the config file.
    this.autorest.configFileUri = await AutoRest.DetectConfigurationFile(this, this.RootUri);

    this.cancel();

    // if autorest is about to restart the work, stop that
    // so we can push it out a bit more.
    if (this._readyToRun) {
      clearTimeout(this._readyToRun);
      this._readyToRun = null;
    }

    this.Manager.verbose(`Queueing up Autorest to process.`);

    return await this.RunAutoRest();
  }

  private RunAutoRest(): Promise<void> {
    return new Promise<void>((r, j) => {
      // queue up the AutoRest restart
      this._readyToRun = setTimeout(() => {
        // clear the 
        this.Manager.verbose(`Clearing diagnostics.`);
        for (let each of this._fileSubscriptions.keys()) {
          each.ClearDiagnostics();
        }

        this.Manager.verbose(`Staring AutoRest Process().`);
        var process = this.autorest.Process();
        process.finish.then(() => {
          return r();
        });
        this.cancel = () => {
          process.cancel();
          this.Manager.verbose(`Cancelling AutoRest Process().`);
          this.cancel = () => true;
          return true;
        };
      }, 25);
    });
  }

  async *EnumerateFileUris(folderUri: string): AsyncIterable<string> {
    connection.console.log(`Enumerating files for ${folderUri}`);
    folderUri = NormalizeUri(folderUri)
    if (folderUri && folderUri.startsWith("file:")) {
      const folderPath = FileUriToPath(folderUri);
      var st = await a.stat(folderPath);
      var isdir = st.isDirectory();
      if (isdir) {
        const items = await a.readdir(folderPath);
        yield* From<string>(items).Where(each => AutoRest.IsConfigurationExtension(GetExtension(each))).Select(each => ResolveUri(folderUri, each));
      }

    }
  }

  async ReadFile(fileUri: string): Promise<string> {
    fileUri = NormalizeUri(fileUri);
    connection.console.log(`IFileSystem:ReadFile : ${fileUri}`);
    let file = (await this.Manager.AcquireTrackedFile(fileUri));
    if (this._autoRest) {
      // track this because it looks like we're being asked for the file during process()
      this.Track(file);
    }
    return await file.content;
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