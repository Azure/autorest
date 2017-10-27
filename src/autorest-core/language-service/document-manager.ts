// ---------------------------------------------------------------------------------------------
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License. See License.txt in the project root for license information.
// ---------------------------------------------------------------------------------------------

import { AutoRest } from "../lib/autorest-core";
import { Message, Channel } from "../lib/message"
import { JsonPath, SourceMap } from './source-map';
import { IFileSystem } from "../lib/file-system";
import { Artifact } from "../lib/artifact";
import { ResolveUri, NormalizeUri, FileUriToPath, GetExtension } from '../lib/ref/uri';
import { From } from "linq-es2015";
import { TrackedFile } from "./tracked-file"
import { DocumentContext } from './document-context';
import { Settings, AutoRestSettings } from './interfaces'
import * as path from "path"
import { safeDump } from "js-yaml";
import { DocumentAnalysis } from "./document-analysis";
import { isFile, writeFile, isDirectory, readdir, readFile } from "@microsoft.azure/async-io"
import {
  IConnection,
  TextDocuments, DiagnosticSeverity, InitializedParams, TextDocument,
  InitializeParams, TextDocumentPositionParams, DidChangeConfigurationParams,
  Range, Position, DidChangeWatchedFilesParams, TextDocumentChangeEvent, Hover, Location,
  MarkedString, FileEvent, Diagnostic
} from 'vscode-languageserver';
import { createHash } from 'crypto';


const md5 = (content: string) => content ? createHash('md5').update(content).digest("hex") : null;

public class Result {
  public readonly artifacts: Array<Artifact> = new Array<Artifact>();

  public cancel: () => void;
  public clear() {
    this.artifacts.length = 0;
  }
  public files = new Array<string>();
}

public class Diagnostics {

  private diagnostics = new Map<string, Diagnostic>();
  public constructor(private connection: IConnection, private fileUri: string) {
  }

  public clear(send: boolean = false) {
    this.diagnostics.clear();
    if (send) {
      this.send();
    }
  }
  public send() {
    this.connection.sendDiagnostics({ uri: this.fileUri, diagnostics: [...this.diagnostics.values()] });
  }

  public add(diagnostic: Diagnostic, send: boolean = true) {
    const hash = md5(JSON.stringify(diagnostic)) || "";
    if (!this.diagnostics.has(hash)) {
      this.diagnostics.set(hash, diagnostic);
      if (send) {
        this.send();
      }
    }
  }

}

export class OpenApiDocumentManager2 extends TextDocuments implements IFileSystem {
  private results = new Map</*configfile*/string, Result>();
  private diagnostics = new Map</*file*/string, Diagnostics>();

  constructor(private connection: IConnection) {
    super();

    // ask vscode to track opened, changed, and closed files
    this.onDidOpen((p) => this.activate(p.document));
    this.onDidChangeContent((p) => this.activate(p.document));

    // we also get change notifications of files on disk:
    connection.onDidChangeWatchedFiles((changes) => this.changedOnDisk(changes.changes));

    connection.onHover((position, _cancel) => this.onHover(position));

    connection.onDefinition((position, _cancel) => this.onDefinition(position));

    // on save
    // this.onDidSave((p) => this.onSaving(p));
    this.onDidClose((p) => this.getDiagnostics(p.document.uri).clear(true));

    // take over configuration file change notifications.
    // connection.onDidChangeConfiguration((p) => this.configurationChanged(p));

    this.listen(connection);
  }

  private getDiagnostics(fileUri: string): Diagnostics {
    let diag = this.diagnostics.get(fileUri);
    if (!diag) {
      diag = new Diagnostics(this.connection, fileUri);
      this.diagnostics.set(fileUri, diag);
    }
    return diag;
  }

  public pushDiagnostic(message: Message, severity: DiagnosticSeverity) {
    let moreInfo = "";
    if (message.Plugin === "azure-validator") {
      if (message.Key) {
        moreInfo = "\n More info: " + azureValidatorRulesDocUrl + "#" + [...message.Key][1].toLowerCase() + "-" + [...message.Key][0].toLowerCase() + "\n";
      }
    }
    if (message.Range) {
      for (const each of message.Range) {
        // get the file reference first

        const fname = NormalizeUri(each.document.replace(/\/$/, ''));
        const file = this.getDiagnostics(fname);

        if (file) {
          file.add({
            severity: severity,
            range: Range.create(Position.create(each.start.line - 1, each.start.column), Position.create(each.end.line - 1, each.end.column)),
            message: message.Text + moreInfo,
            source: message.Key ? [...message.Key].join("/") : ""
          });
        } else {
          // console.log(each.document)
        }
      }
    }
  }

  private * onHoverRef(docAnalysis: DocumentAnalysis, position: Position): Iterable<MarkedString> {
    const refValueJsonPath = docAnalysis.GetJsonPathFromJsonReferenceAt(position);
    if (refValueJsonPath) {

      for (const location of docAnalysis.GetDefinitionLocations(refValueJsonPath)) {
        yield {
          language: "yaml",
          value: safeDump(location.value)
        };
      }
    } // else {console.log("found nothing that looks like a JSON reference"); return null; }
  }

  private * onHoverJsonPath(docAnalysis: DocumentAnalysis, position: Position): Iterable<MarkedString> {
    const potentialQuery: string = <string>docAnalysis.GetJsonQueryAt(position);
    if (potentialQuery) {

      const queryNodes = [...docAnalysis.GetDefinitionLocations(potentialQuery)];
      yield {
        language: "plaintext",
        value: `${queryNodes.length} matches\n${queryNodes.map(node => node.jsonPath).join("\n")}`
      };
    } // else { console.log("found nothing that looks like a JSON path"); return null; }
  }

  private async getDocumentAnalysis(documentUri: string): Promise<DocumentAnalysis | null> {
    const result = this.results.get(documentUri);
    if (result) {
      const outputs = result.artifacts;
      const openapiDefinition = From(outputs.values()).Where(x => x.type === "swagger-document.json").Select(x => JSON.parse(x.content)).FirstOrDefault();
      const openapiDefinitionMap = From(outputs.values()).Where(x => x.type === "swagger-document.json.map").Select(x => JSON.parse(x.content)).FirstOrDefault();

      if (openapiDefinition && openapiDefinitionMap) {
        return new DocumentAnalysis(
          documentUri,
          await this.ReadFile(documentUri),
          openapiDefinition,
          new SourceMap(openapiDefinitionMap));
      }
    }
    return null;
  }

  private async onHover(position: TextDocumentPositionParams): Promise<Hover> {
    const docAnalysis = await this.getDocumentAnalysis(position.textDocument.uri);
    return docAnalysis ? <Hover>{
      contents: [
        ...this.onHoverRef(docAnalysis, position.position),
        ...this.onHoverJsonPath(docAnalysis, position.position)
      ]
    } : <Hover><any>null
  }

  private onDefinitionRef(docAnalysis: DocumentAnalysis, position: Position): Iterable<Location> {
    const refValueJsonPath = docAnalysis.GetJsonPathFromJsonReferenceAt(position);
    if (refValueJsonPath) {
      return docAnalysis.GetDocumentLocations(refValueJsonPath);
    } // else  { console.log("found nothing that looks like a JSON reference"); }
    return [];
  }

  private onDefinitionJsonPath(docAnalysis: DocumentAnalysis, position: Position): Iterable<Location> {
    const potentialQuery: string = <string>docAnalysis.GetJsonQueryAt(position);
    if (potentialQuery) {

      return docAnalysis.GetDocumentLocations(potentialQuery);
    } // else  { console.log("found nothing that looks like a JSON path");}
    return [];
  }

  private async onDefinition(position: TextDocumentPositionParams): Promise<Location[]> {
    const docAnalysis = await this.getDocumentAnalysis(position.textDocument.uri);
    return docAnalysis ? [
      ...this.onDefinitionRef(docAnalysis, position.position),
      ...this.onDefinitionJsonPath(docAnalysis, position.position)
    ] : [];
  }

  private async changedOnDisk(changes: FileEvent[]) {
    for (const each of changes) {

      const doc = this.get(each.uri);
      if (doc) {
        this.activate(doc);
        return;
      }

      let documentUri = NormalizeUri(each.uri);
      const txt = await readFile(FileUriToPath(each.uri));
      if (documentUri.startsWith("file://")) {
        // fake out a document for us to play with
        this.activate({
          uri: <string>each.uri,
          languageId: "",
          version: 1,
          getText: () => txt,
          positionAt: (offset: number) => <Position>{},
          offsetAt: (position: Position) => 0,
          lineCount: 1
        });
      }
    }
  }

  public async EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    folderUri = NormalizeUri(folderUri);
    if (folderUri && folderUri.startsWith("file:")) {
      const folderPath = FileUriToPath(folderUri);
      if (await isDirectory(folderPath)) {
        const items = await readdir(folderPath);
        return From<string>(items).Where(each => AutoRest.IsConfigurationExtension(GetExtension(each))).Select(each => ResolveUri(folderUri, each)).ToArray();
      }
    }
    return [];
  }

  public async ReadFile(fileUri: string): Promise<string> {
    fileUri = NormalizeUri(fileUri);
    const doc = this.get(fileUri);
    if (doc) {
      return doc.getText();
    }
    try {
      return await readFile(FileUriToPath(fileUri));
    } catch {
    }
    return "";
  }

  private getResult(documentUri: string): Result {
    const result = this.results.get(documentUri) || new Result();
    this.results.set(documentUri, result);
    return result;
  }

  private async process(documentUri: string) {
    const result = this.getResult(documentUri);

    // ensure that we are no longer processing a previous run.
    result.cancel();

    // run process for that config file
    const a = new AutoRest(this, documentUri);

    // ensure that we have nothing 
    result.clear();

    // write files out
    const unsubscribeArtifacts = a.GeneratedFile.Subscribe((a, artifact) => result.artifacts.push(artifact));
    const unsubscribeMessages = a.Message.Subscribe((au, message) => {
      switch (message.Channel) {
        case Channel.Debug:
          // this.debug(message.Text)
          break;
        case Channel.Fatal:
          // this.error(message.Text)
          break;
        case Channel.Verbose:
          // this.verbose(message.Text)
          break;

        case Channel.Warning:
          this.pushDiagnostic(message, DiagnosticSeverity.Warning);
          break;
        case Channel.Error:
          this.pushDiagnostic(message, DiagnosticSeverity.Error);
          break;
        case Channel.Information:
          this.pushDiagnostic(message, DiagnosticSeverity.Warning);
          break;
      }
    });

    const unsubscribeFinish = a.Finished.Subscribe((a, success) => {
      // anything after it's done?
    })

    result.files = (await a.view).InputFileUris;
    const processResult = a.Process();

    result.cancel = () => {
      // cancel only once!
      result.cancel = () => { };

      // stop processing messages
      unsubscribeMessages();

      // stop processing outputs 
      unsubscribeArtifacts();

      // stop watching for finish
      unsubscribeFinish();

      // cancel the current process if running.
      processResult.cancel();

      // clear diagnostics for next run
      for (const f in result.files) {
        this.getDiagnostics(f).clear();
      }
    };

  }

  private async getConfiguration(documentUri: string): Promise<string> {
    let folder = ResolveUri(documentUri, ".");
    let configFile = await AutoRest.DetectConfigurationFile(this, folder);
    if (configFile) {
      return configFile;
    }

    return "";

  }

  private async activate(document: TextDocument) {
    if (AutoRest.IsSwaggerExtension(document.languageId) && AutoRest.IsSwaggerFile(document.getText())) {
      // find the configuration file and activate that.
      this.process(await this.getConfiguration(document.uri));
      return;
    }

    // is this a config file?
    if (AutoRest.IsConfigurationExtension(document.languageId) && AutoRest.IsConfigurationFile(document.getText())) {
      this.process(document.uri);
      return;
    }

    // neither 
    // clear any results we have for this.
    const result = this.results.get(document.uri);
    if (result) {
      // this used to be a config file
      result.cancel();
      result.clear();
    }

    // let's clear anything we may have sent for this file.
    this.getDiagnostics(document.uri).clear(true);
  }


}

//TODO: adding URL here temporarily, this should be coming either in the message coming from autorest or the plugin
const azureValidatorRulesDocUrl = "https://github.com/Azure/azure-rest-api-specs/blob/current/documentation/openapi-authoring-automated-guidelines.md";

export class OpenApiDocumentManager extends TextDocuments {
  private trackedFiles = new Map<string, TrackedFile>();

  public async GetFileContent(documentUri: string): Promise<string | null> {
    const file = this.trackedFiles.get(documentUri);
    const content = file && await file.content;
    if (!content) { console.warn(`file '${documentUri}' not found`); return null; }
    return content;
  }

  // Map of "path to file/folder" and its document context 
  private activeContexts = new Map<string, DocumentContext>();
  private _rootUri: string | null = null;
  private _settings: Settings = { autorest: <AutoRestSettings>{} };
  public get settings(): Settings {
    return this._settings;
  }
  public set settings(value: Settings) {
    this._settings = value || { autorest: <AutoRestSettings>{} };
  }

  public get RootUri(): string | null {
    return this._rootUri;
  }

  public information(text: string) {
    if (this.settings.autorest.information) {
      this.connection.console.log(`[INFO: ${OpenApiDocumentManager.DateStamp}] ${text}`)
    }
  }

  public verbose(text: string) {
    if (this.settings.autorest.verbose) {
      this.connection.console.log(`[${OpenApiDocumentManager.DateStamp}] ${text}`)
    }
  }

  public debug(text: string) {
    if (this.settings.autorest.debug) {
      this.connection.console.log(`[DEBUG: ${OpenApiDocumentManager.DateStamp}] ${text}`)
    }
  }

  public warn(text: string) {
    this.connection.console.warn(`[WARN: ${OpenApiDocumentManager.DateStamp}] ${text}`)
  }

  public error(text: string) {
    this.connection.console.error(`[ERROR: ${OpenApiDocumentManager.DateStamp}] ${JSON.stringify(text)}`)
  }
  public async SetRootUri(uri: string | null): Promise<void> {
    // when we set the RootURI we look to see if we have a configuration file 
    // there, and then we automatically start validating that folder.

    if (!uri || uri.length == 0) {
      this.warn(`No workspace uri.`);
      return;
    }

    if (this._rootUri) {
      // I'm assuming that this doesn't happen...
      throw new Error("BAD ASSUMPTION DUDE.")
    }

    let ctx = this.activeContexts.get(uri);
    if (ctx) {
      // we already have this as an active context. That's ok
    } else {
      // not an active context -- this is the expectation.
      try {
        ctx = new DocumentContext(this, uri);
        this.activeContexts.set(uri, ctx);

      } catch (exception) {
        // that's not good. 
        this.error(`Exception setting Workspace URI ${uri} `)
      }
    }
  }


  // private initializing: Promise<void> = null;
  // The settings have changed. Is send on server activation
  // as well.
  configurationChanged(configuration: DidChangeConfigurationParams) {
    this.settings = <Settings>configuration.settings;
  };

  private changedOnDisk(changes: DidChangeWatchedFilesParams) {
    // files on disk changed in the workspace. Let's see if we care.
    // changes.changes[0].type 1/2/3 == created/changed/deleted
    // changes.changes[0].uri
    for (const each of changes.changes) {
      let documentUri = NormalizeUri(each.uri);
      if (!documentUri.startsWith("file://")) {
        return;
      }

      this.debug(`Changed On Disk: ${documentUri}`);
      let doc = this.trackedFiles.get(documentUri);
      if (doc) {
        // we are currently tracking this file already.
        if (doc.IsActive) {
          // the document is active, which means that we take orders from VSCode, not the disk.
          // (the file may be modified on the disk, but from our perspective, vscode owns the file until its closed.)
        } else {
          // lets reset the content, and it'll reload it at some other time.
          doc.SetContent(null);
        }
      }
      // we didn't track this file before, so unless something asks for it, we're not going to do anything.
    }
  }

  public async AcquireTrackedFile(documentUri: string, documentContent?: string): Promise<TrackedFile> {
    documentUri = NormalizeUri(documentUri);
    let doc = this.trackedFiles.get(documentUri);
    if (doc) {
      return doc;
    }
    // not tracked yet, let's do that now.
    // console.log(`Tracking file: ${documentUri}`);

    const f = new TrackedFile(documentUri);
    this.trackedFiles.set(documentUri, f);
    f.DiagnosticsToSend.Subscribe((file, diags) => {
      const path = file.fullPath.replace("untitled://", "untitled:");
      this.connection.sendDiagnostics({ uri: path, diagnostics: [...diags.values()] });
    }
    );

    if (documentContent) {
      f.SetContent(documentContent);
    }

    return f;
  }

  // Finds the folder the document is in, creates or returns existing document context based on folder path 
  // (there should only be one config file per folder)
  private async GetDocumentContextForDocument(documentUri: string): Promise<DocumentContext> {
    documentUri = NormalizeUri(documentUri);
    // get the folder for this documentUri
    let folder = ResolveUri(documentUri, ".");

    let configFile = await AutoRest.DetectConfigurationFile(new DocumentContext(this, folder), folder);
    if (configFile) {
      this.debug(`Configuration File Selected: ${configFile}`);


      folder = path.dirname(configFile);  // updating folder, in case config file was found in another folder in the hierarchy
      // do we have this config already?
      let ctx = this.activeContexts.get(folder);
      if (!ctx) {
        ctx = new DocumentContext(this, folder, configFile);
        this.activeContexts.set(folder, ctx);
        this.activeContexts.set(documentUri, ctx);
      }
      // if the file is the config file itself.
      if (configFile === documentUri) {
        // look into acquiring the rest of the files in this config file
        let files = [...(await ctx.autorest.view).InputFileUris]
        for (const fn of files) {
          // acquire each of the docs in the config file
          ctx.ReadFile(fn);
          this.activeContexts.set(fn, ctx);
          ctx.Track(await this.AcquireTrackedFile(fn));
        }
        return ctx;
      }

      const v = (await ctx.autorest.view);

      // is the documentUri in the config file?
      let files = [...(await ctx.autorest.view).InputFileUris];
      for (const fn of files) {
        if (fn == documentUri) {
          // found the document inside this context.
          this.activeContexts.set(fn, ctx);
          ctx.Track(await this.AcquireTrackedFile(configFile));
          return ctx;
        }
      }
    }
    // there was no configuration file for that file.
    // or the configuration that we found didn't contain that file.

    // let's look for or create a faux one at that level
    //creating this file in a folder under the name of the file, so it's unique to this file
    configFile = this.GetFakeConfigFileUri(documentUri);
    //check if file context (the file or files related to this config) is opened in VS Code
    let ctx = this.activeContexts.get(configFile);
    if (ctx) {
      ctx.Track(await this.AcquireTrackedFile(configFile));
      return ctx;
    }

    // we don't have one here - create a faux file
    let file = await this.AcquireTrackedFile(configFile, "#Fake config file \n > see https://aka.ms/autorest \n``` yaml \ninput-file: \n - " + documentUri);
    //mark it active, as if it was opened in VS Code
    file.IsActive = true;
    ctx = new DocumentContext(this, folder, configFile);
    ctx.autorest.AddConfiguration({ "input-file": documentUri, "azure-validator": true });
    this.activeContexts.set(configFile, ctx);
    this.activeContexts.set(documentUri, ctx);
    ctx.Track(file);
    return ctx;
  }

  private GetFakeConfigFileUri(documentUri: string): string {
    return ResolveUri(documentUri + "/", "readme.md");
  }



  private async openOrChangedFile(document: TextDocument) {


    const documentUri = NormalizeUri(document.uri);
    let doc = this.trackedFiles.get(documentUri);
    if (AutoRest.IsConfigurationExtension(document.languageId) || AutoRest.IsSwaggerExtension(document.languageId)) {
      const text = document.getText();


      /* if (!documentUri.startsWith("file://")) {
        return;
      } */

      // are we already tracking this file 
      let doc = this.trackedFiles.get(documentUri);

      if (!doc) {
        // no, it appears that it may not have been a config or swagger when we opened it.
        // looks like we should now tho'
        doc = await this.AcquireTrackedFile(documentUri)
      }

      if (doc) {
        // set the document content.
        doc.IsActive = true;
        let ctx = await this.GetDocumentContextForDocument(documentUri);
        ctx.Track(doc);
        doc.SetContent(text);
      }

      // we're doin' good.
      return;
    }
    if (doc) {
      // we have a doc, but it looks like we shouldn't be reporting anything right now.
      doc.SetContent(document.getText());
      doc.ClearDiagnostics();
      doc.FlushDiagnostics(true);
    }
  }

  private async closed(close: TextDocumentChangeEvent) {
    // if we have this document, we can mark it 
    let docUri = NormalizeUri(close.document.uri);
    let doc = this.trackedFiles.get(docUri);
    if (doc) {

      // config files need some different treatment
      // if config file is left opened, we do not want to clear diagnostics for referenced files
      // if config file is closed and no other referenced files are opened, then we should clear diagnostics.
      let folder = path.dirname(docUri);
      let ctx = <DocumentContext>this.activeContexts.get(docUri);

      let configFile = await AutoRest.DetectConfigurationFile(ctx, folder);

      if (configFile === docUri) {
        let files = [...(await ctx.autorest.view).InputFileUris];
        let docfile;
        for (const fn of files) {
          docfile = <TrackedFile>this.trackedFiles.get(NormalizeUri(fn));
          if (!docfile.IsActive) {
            this.activeContexts.delete(fn);
            this.unTrackAndClearDiagnotics(ctx, docfile);
          }
        }
      }
      // we're not tracking this file from vscode anymore.
      doc.IsActive = false;

      //if the document is not the config file but it has a real config file associated with it
      if (configFile) {
        this.activeContexts.delete(docUri);
        this.unTrackAndClearDiagnotics(ctx, doc);
      }
      // if the file is an individual file
      else {
        configFile = this.GetFakeConfigFileUri(docUri)
        ctx = <DocumentContext>this.activeContexts.get(configFile);
        this.activeContexts.delete(configFile);
        this.activeContexts.delete(docUri);
        this.unTrackAndClearDiagnotics(ctx, doc);
      }

    }
  }

  private unTrackAndClearDiagnotics(docContext: DocumentContext, file: TrackedFile) {
    docContext.UnTrack(file);
    file.ClearDiagnostics();
    file.FlushDiagnostics(true);
  }

  static PadDigits(number: number, digits: number): string {
    return Array(Math.max(digits - String(number).length + 1, 0)).join('0') + number;
  }

  static get DateStamp(): string {
    let d = new Date();
    return `${this.PadDigits(d.getHours(), 2)}:${this.PadDigits(d.getMinutes(), 2)}:${this.PadDigits(d.getSeconds(), 2)}.${this.PadDigits(d.getMilliseconds(), 4)}`;
  }

  listenForResults(autorest: AutoRest) {
    autorest.Message.Subscribe((_, m) => {
      switch (m.Channel) {
        case Channel.Debug:
          this.debug(m.Text)
          break;
        case Channel.Fatal:
          this.error(m.Text)
          break;
        case Channel.Verbose:
          this.verbose(m.Text)
          break;

        case Channel.Warning:
          this.PushDiagnostic(m, DiagnosticSeverity.Warning);
          break;
        case Channel.Error:
          this.PushDiagnostic(m, DiagnosticSeverity.Error);
          break;
        case Channel.Information:
          this.PushDiagnostic(m, DiagnosticSeverity.Warning);
          break;
      }
    });
  }

  PushDiagnostic(args: Message, severity: DiagnosticSeverity) {
    let moreInfo = "";
    if (args.Plugin === "azure-validator") {
      if (args.Key) {
        moreInfo = "\n More info: " + azureValidatorRulesDocUrl + "#" + [...args.Key][1].toLowerCase() + "-" + [...args.Key][0].toLowerCase() + "\n";
      }
    }
    if (args.Range) {
      for (const each of args.Range) {
        // get the file reference first

        const fname = NormalizeUri(each.document.replace(/\/$/, ''));
        let file = this.trackedFiles.get(fname);
        if (!file) {
          for (const each of this.trackedFiles.keys()) {
            if (each.toLowerCase() === fname) {
              file = this.trackedFiles.get(each);
              break;
            }
          }
        }

        if (file) {
          file.PushDiagnostic({
            severity: severity,
            range: Range.create(Position.create(each.start.line - 1, each.start.column), Position.create(each.end.line - 1, each.end.column)),
            message: args.Text + moreInfo,
            source: args.Key ? [...args.Key].join("/") : ""
          });
        } else {
          // console.log(each.document)
        }
      }
    }
  }

  /**
   * When the extension saves a literate swagger document, we want to save a shadow .json or .yaml file if it exists (or if instructed to in the configuration)
   * @param saving - the vscode TextDocumentChangeEvent containing the information about the document that was saved.
   */
  async onSaving(saving: TextDocumentChangeEvent) {
    let documentUri = saving.document.uri;
    let documentContent = saving.document.getText();
    if (AutoRest.IsSwaggerExtension(GetExtension(documentUri))) {
      let content = await AutoRest.LiterateToJson(documentContent);
      if (content && await AutoRest.IsSwaggerFile(content)) {

        const ctx = await this.GetDocumentContextForDocument(documentUri);
        const settings = (await ctx.autorest.view).GetEntry("vscode");
        let localPath = FileUriToPath(documentUri.replace(".md", ".json"));
        if ((settings && settings.sync == true) ||
          (await isFile(localPath) && !(settings && settings.sync == false))) {
          await writeFile(localPath, content);
        }
      }
    }
  }

  /**
   * Retrieves the fully resolved, fully merged Swagger definition representing the currently inspected service.
   */
  public GetFullyResolvedAndMergedDefinitionOf(documentUri: string): { openapiDefinition: any, openapiDefinitionMap: sourceMap.RawSourceMap } | null {
    const context = this.activeContexts.get(documentUri);

    if (!context) {
      console.warn("no context found", documentUri, [...this.activeContexts.keys()]);
      return null;
    }

    const result = context.fullyResolvedAndMergedDefinition;

    if (!result.openapiDefinition || !result.openapiDefinitionMap) {
      // console.log("waiting for AutoRest to provide data");
      return null;
    }

    return result;
  }

  private * onHoverRef(docAnalysis: DocumentAnalysis, position: Position): Iterable<MarkedString> {
    const refValueJsonPath = docAnalysis.GetJsonPathFromJsonReferenceAt(position);
    if (refValueJsonPath) {

      for (const location of docAnalysis.GetDefinitionLocations(refValueJsonPath)) {
        yield {
          language: "yaml",
          value: safeDump(location.value)
        };
      }
    } // else {console.log("found nothing that looks like a JSON reference"); return null; }
  }

  private * onHoverJsonPath(docAnalysis: DocumentAnalysis, position: Position): Iterable<MarkedString> {
    const potentialQuery: string = <string>docAnalysis.GetJsonQueryAt(position);
    if (potentialQuery) {

      const queryNodes = [...docAnalysis.GetDefinitionLocations(potentialQuery)];
      yield {
        language: "plaintext",
        value: `${queryNodes.length} matches\n${queryNodes.map(node => node.jsonPath).join("\n")}`
      };
    } // else { console.log("found nothing that looks like a JSON path"); return null; }
  }

  private async onHover(position: TextDocumentPositionParams): Promise<Hover> {
    const docAnalysis = await DocumentAnalysis.Create(this, position.textDocument.uri);
    if (!docAnalysis) {
      return <Hover><any>null;
    }

    return <Hover>{
      contents: [
        ...this.onHoverRef(docAnalysis, position.position),
        ...this.onHoverJsonPath(docAnalysis, position.position)
      ]
    };
  }

  private onDefinitionRef(docAnalysis: DocumentAnalysis, position: Position): Iterable<Location> {
    const refValueJsonPath = docAnalysis.GetJsonPathFromJsonReferenceAt(position);
    if (refValueJsonPath) {

      return docAnalysis.GetDocumentLocations(refValueJsonPath);
    } // else  { console.log("found nothing that looks like a JSON reference"); }
    return [];
  }

  private onDefinitionJsonPath(docAnalysis: DocumentAnalysis, position: Position): Iterable<Location> {
    const potentialQuery: string = <string>docAnalysis.GetJsonQueryAt(position);
    if (potentialQuery) {

      return docAnalysis.GetDocumentLocations(potentialQuery);
    } // else  { console.log("found nothing that looks like a JSON path");}
    return [];
  }

  private async onDefinition(position: TextDocumentPositionParams): Promise<Location[]> {
    const docAnalysis = await DocumentAnalysis.Create(this, position.textDocument.uri);
    if (!docAnalysis) {
      return [];
    }

    return [
      ...this.onDefinitionRef(docAnalysis, position.position),
      ...this.onDefinitionJsonPath(docAnalysis, position.position)
    ];
  }

  constructor(private connection: IConnection) {
    super();
    this.debug("setting up AutoRestManager.");

    // ask vscode to track opened, changed, and closed files
    this.onDidOpen((p) => this.openOrChangedFile(p.document));
    this.onDidChangeContent((p) => this.openOrChangedFile(p.document));
    this.onDidClose((p) => this.closed(p));

    // we also get change notifications of files on disk:
    connection.onDidChangeWatchedFiles((p) => this.changedOnDisk(p));

    connection.onHover((position, _cancel) => this.onHover(position));

    connection.onDefinition((position, _cancel) => this.onDefinition(position));

    // on save
    this.onDidSave((p) => this.onSaving(p));

    // take over configuration file change notifications.
    connection.onDidChangeConfiguration((p) => this.configurationChanged(p));
    this.listen(connection);

    this.verbose("AutoRestManager is Listening.")
  }
}

