#!/usr/bin/env node
// load static module: ${__dirname }/static_modules.fs
require('../static-loader.js').load(`${__dirname}/../static_modules.fs`)

// Ensure that if we're running in an electron process, that things will work as if it were node.
process.env['ELECTRON_RUN_AS_NODE'] = "1";
delete process.env['ELECTRON_NO_ATTACH_CONSOLE'];

import { AutoRest } from "../lib/autorest-core";
import { Message, Channel } from "../lib/message"
import { JsonPath, SourceMap } from './source-map';
import { IFileSystem } from "../lib/file-system";
import { Artifact } from "../lib/artifact";
import { ResolveUri, FileUriToPath, GetExtension } from '../lib/ref/uri';
import { From } from "linq-es2015";
import { safeDump } from "js-yaml";
import { DocumentAnalysis } from "./document-analysis";
import { isFile, writeFile, isDirectory, readdir, readFile } from "@microsoft.azure/async-io"
import { createHash } from 'crypto';
import { Configuration } from "../lib/configuration"

import {
  IConnection,
  TextDocuments, DiagnosticSeverity, InitializedParams, TextDocument,
  InitializeParams, TextDocumentPositionParams, DidChangeConfigurationParams,
  Range, Position, DidChangeWatchedFilesParams, TextDocumentChangeEvent, Hover, Location,
  MarkedString, FileEvent, Diagnostic, createConnection,
  InitializeResult, DidChangeConfigurationNotification, Proposed, ProposedFeatures,
  TextDocumentSyncKind, IPCMessageReader, IPCMessageWriter
} from 'vscode-languageserver';

import { AutoRestSettings, Settings } from './interfaces';

//TODO: adding URL here temporarily, this should be coming either in the message coming from autorest or the plugin
const azureValidatorRulesDocUrl = "https://github.com/Azure/azure-rest-api-specs/blob/current/documentation/openapi-authoring-automated-guidelines.md";

const md5 = (content: string) => content ? createHash('md5').update(content).digest("hex") : null;

class Result {
  public readonly artifacts: Array<Artifact> = new Array<Artifact>();
  public cancel: () => Promise<void> = async () => { };
  public clear() {
    this.artifacts.length = 0;
  }
}

class Diagnostics {
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

export class OpenApiLanugageService extends TextDocuments implements IFileSystem {
  private results = new Map</*configfile*/string, Result>();
  private diagnostics = new Map</*file*/string, Diagnostics>();
  private virtualFile = new Map<string, TextDocument>();

  public get(uri: string): TextDocument {
    return super.get(uri);
  }

  constructor(private connection: IConnection) {
    super();

    // ask vscode to track opened, changed, and closed files
    this.onDidOpen((p) => this.onDocumentChanged(p.document));
    this.onDidChangeContent((p) => this.onDocumentChanged(p.document));

    // we also get change notifications of files on disk:
    connection.onDidChangeWatchedFiles((changes) => this.onFileEvents(changes.changes));

    // requests for hover/definitions
    connection.onHover((position, _cancel) => this.onHover(position));
    connection.onDefinition((position, _cancel) => this.onDefinition(position));

    this.onDidClose((p) => this.getDiagnosticCollection(p.document.uri).clear(true));

    // on save (should be on the client side?)
    // this.onDidSave((p) => this.onSaving(p));

    this.listen(connection);
  }

  private async getDocumentAnalysis(documentUri: string): Promise<DocumentAnalysis | null> {
    const config = await this.getConfiguration(documentUri);
    const result = this.results.get(config);
    if (result) {
      const outputs = result.artifacts;
      const openapiDefinition = From(outputs).Where(x => x.type === "swagger-document.json").Select(x => JSON.parse(x.content)).FirstOrDefault();
      const openapiDefinitionMap = From(outputs).Where(x => x.type === "swagger-document.json.map").Select(x => JSON.parse(x.content)).FirstOrDefault();

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

  private getDiagnosticCollection(fileUri: string): Diagnostics {
    const diag = this.diagnostics.get(fileUri) || new Diagnostics(this.connection, fileUri);
    this.diagnostics.set(fileUri, diag);
    return diag;
  }

  private getResult(documentUri: string): Result {
    const result = this.results.get(documentUri) || new Result();
    this.results.set(documentUri, result);
    return result;
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


        const file = this.getDiagnosticCollection(each.document);

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

  private async onFileEvents(changes: FileEvent[]) {
    this.debug(`onFileEvents: ${changes}`);
    for (const each of changes) {

      const doc = this.get(each.uri);
      if (doc) {
        this.onDocumentChanged(doc);
        return;
      }

      let documentUri = each.uri;
      const txt = await readFile(FileUriToPath(each.uri));
      if (documentUri.startsWith("file://")) {
        // fake out a document for us to play with
        this.onDocumentChanged({
          uri: each.uri,
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
  // IFileSystem Implementation
  public async EnumerateFileUris(folderUri: string): Promise<Array<string>> {
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
    const doc = this.get(fileUri) || this.virtualFile.get(fileUri);
    try {
      if (doc) {
        return doc.getText();
      }

      return await readFile(FileUriToPath(fileUri));
    } catch {
    }
    return "";
  }

  private async process(documentUri: string) {
    const result = this.getResult(documentUri);

    // ensure that we are no longer processing a previous run.
    await result.cancel();

    // ensure that we have nothing left over from before
    result.clear();

    // run process for that config file
    const a = new AutoRest(this, documentUri);

    a.AddConfiguration({
      "output-artifact": ["swagger-document.json", "swagger-document.json.map"]
      , "azure-validator": true
      // debug and verbose messages are not sent by default.
      , debug: true,
      verbose: true
    });

    // write files out
    const unsubscribeArtifacts = a.GeneratedFile.Subscribe((a, artifact) => result.artifacts.push(artifact));
    const unsubscribeMessages = a.Message.Subscribe((au, message) => {
      switch (message.Channel) {
        case Channel.Debug:
          this.connection.console.info(message.Text)
          break;
        case Channel.Fatal:
          this.connection.console.error(message.Text)
          break;
        case Channel.Verbose:
          this.connection.console.log(message.Text)
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
      this.debug(`Finished Autorest ${success}`);
    })

    const processResult = a.Process();


    result.cancel = async () => {
      // cancel only once!
      result.cancel = async () => { };

      const files = (await a.view).InputFileUris;

      // stop processing messages
      unsubscribeMessages();

      // stop processing outputs 
      unsubscribeArtifacts();

      // stop watching for finish
      unsubscribeFinish();

      // cancel the current process if running.
      processResult.cancel();

      // clear diagnostics for next run
      for (const f of files) {
        this.getDiagnosticCollection(f).clear();
      }
    };

  }

  private async getConfiguration(documentUri: string): Promise<string> {
    // let folder = ResolveUri(documentUri, ".");
    let configFiles = await Configuration.DetectConfigurationFiles(this, documentUri, undefined, true);

    // is the document a config file?
    if (configFiles.length === 1 && configFiles[0] == documentUri) {
      return documentUri;
    }

    // is there a config file that contains the document as an input?
    for (const configFile of configFiles) {
      const a = new AutoRest(this, configFile);
      const inputs = (await a.view).InputFileUris
      for (const input of inputs) {
        if (input === documentUri || decodeURIComponent(input) == decodeURIComponent(documentUri)) {
          return configFile;
        }
      }
    }

    // didn't find a match, let's make a dummy one.
    const configFile = `${documentUri}/readme.md`;
    if (!this.virtualFile.get(configFile)) {
      this.virtualFile.set(configFile, {
        uri: configFile,
        languageId: "markdown",
        version: 1,
        getText: () => "#Fake config file \n> see https://aka.ms/autorest \n``` yaml \ninput-file: \n - " + documentUri,
        positionAt: (offset: number) => <Position>{},
        offsetAt: (position: Position) => 0,
        lineCount: 1
      });
    }

    return configFile;
  }

  private async onDocumentChanged(document: TextDocument) {
    this.debug(`onDocumentChanged: ${document.uri}`);

    if (AutoRest.IsSwaggerExtension(document.languageId) && await AutoRest.IsSwaggerFile(document.getText())) {
      // find the configuration file and activate that.
      this.process(await this.getConfiguration(document.uri));
      return;
    }

    // is this a config file?
    if (AutoRest.IsConfigurationExtension(document.languageId) && await AutoRest.IsConfigurationFile(document.getText())) {
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
    this.getDiagnosticCollection(document.uri).clear(true);
  }


  public async onRootUriChanged(rootUri: string | null) {
    this.debug(`onRootUriChanged: ${rootUri}`);
    // do nothing for now.
  }

  public debug(text: string) {
    this.connection.console.info(text);
  }
}

// Create the IPC Channel for the lanaguage service.
let connection: IConnection = createConnection(new IPCMessageReader(process), new IPCMessageWriter(process));
let languageService = new OpenApiLanugageService(connection);

process.on("unhandledRejection", function (err) {
  // connection.console.log(`Unhandled Rejection Suppressed: ${err}`);
});

connection.onInitialize(async (params): Promise<InitializeResult> => {
  await languageService.onRootUriChanged(params.rootPath || null);

  return {
    capabilities: {
      // TODO: provide code lens handlers to preview generated code and such!
      // codeLensProvider: <CodeLensOptions>{
      //   resolveProvider: false
      // },
      // completionProvider: {
      //		resolveProvider: true
      // }

      definitionProvider: true,
      hoverProvider: true,

      // Tell the client that the server works in FULL text document sync mode
      textDocumentSync: TextDocumentSyncKind.Full,
    }
  }
});

// Listen on the connection
connection.listen();