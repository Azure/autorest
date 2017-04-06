import * as a from '../lib/ref/async'
import { IFileSystem, AutoRest, EventEmitter, IEvent } from "autorest";

import { IConnection, TextDocumentIdentifier, TextDocumentChangeEvent, TextDocuments } from "vscode-languageserver";
import { File } from "./tracked-file"
import { AutoRestManager, connection } from "./autorest-manager"
import { From } from "../lib/ref/linq"
import { CreateFileUri, FileUriToPath, NormalizeUri, ResolveUri, GetExtension } from '../lib/ref/uri';

import * as path from "path"

export class DocumentContext extends EventEmitter implements IFileSystem {
  private _autoRest: AutoRest | null;
  private _readyToRun: NodeJS.Timer | null = null;
  private _fileSubscriptions = new Map<File, () => void>();
  public cancel: () => boolean = () => true;
  private _outputs = new Map<string, string>();

  public get autorest(): AutoRest {
    if (!this._autoRest) {
      this._autoRest = new AutoRest(this, this.configurationFile);
      this._autoRest.AddConfiguration({ "output-artifact": ["swagger-document", "swagger-document.map"] });

      this.Manager.listenForResults(this._autoRest);
      this.autorest.GeneratedFile.Subscribe((instance, artifact) => {
        this._outputs.set(artifact.uri, artifact.content);
      })
      this._autoRest.Finished.Subscribe((autorest, success) => {
        this.cancel = () => true;

        if (success != false) {
          this.FlushDiagnostics(true);
          this.ClearDiagnostics();
        }
        this.Manager.verbose(`AutoRest Process Finished with '${success}'.`);
      })
    }
    return this._autoRest;
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

    // if there is a process() running, kill it. 
    this.cancel();

    // reaquire the config file.
    this.autorest.configFileUri = await AutoRest.DetectConfigurationFile(this, this.RootUri);

    // if autorest is about to restart the work, stop that
    // so we can push it out a bit more.
    if (this._readyToRun) {
      clearTimeout(this._readyToRun);
      this._readyToRun = null;
    }
    return await this.RunAutoRest();
  }

  private FlushDiagnostics(force?: boolean) {
    this.Manager.debug(`Flushing diagnostics.`);

    for (let each of this._fileSubscriptions.keys()) {
      each.FlushDiagnostics(force);
    }
  }

  private ClearDiagnostics() {
    this.Manager.debug(`Clearing diagnostics.`);

    for (let each of this._fileSubscriptions.keys()) {
      each.ClearDiagnostics();
    }
  }

  private RunAutoRest(): Promise<void> {
    this.Manager.verbose(`Queueing up Autorest to process.`);

    return new Promise<void>((r, j) => {
      // queue up the AutoRest restart
      this._readyToRun = setTimeout(() => {

        this.Manager.debug(`Starting AutoRest Process().`);
        var process = this.autorest.Process();
        process.finish.then(() => {
          return r();
        });

        this.cancel = () => {
          // make sure this can't get called twice for the same process call. 
          this.cancel = () => true;

          // Shut it down.
          this.Manager.debug(`Cancelling AutoRest Process().`);
          process.cancel();

          this.FlushDiagnostics(true);
          this.ClearDiagnostics();
          return true;
        };
      }, 100);
    });
  }

  async *EnumerateFileUris(folderUri: string): AsyncIterable<string> {
    folderUri = NormalizeUri(folderUri)
    if (folderUri && folderUri.startsWith("file:")) {
      const folderPath = FileUriToPath(folderUri);
      var isdir = await a.isDirectory(folderPath);

      if (isdir) {
        const items = await a.readdir(folderPath);
        yield* From<string>(items).Where(each => AutoRest.IsConfigurationExtension(GetExtension(each))).Select(each => ResolveUri(folderUri, each));
      }
    }
  }

  async ReadFile(fileUri: string): Promise<string> {
    fileUri = NormalizeUri(fileUri);
    let file = (await this.Manager.AcquireTrackedFile(fileUri));
    if (this._autoRest) {
      // track this because it looks like we're being asked for the file during process()
      this.Track(file);
    }
    return await file.content;
  }
}