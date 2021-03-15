// Ensure that if we're running in an electron process, that things will work as if it were node.
process.env["ELECTRON_RUN_AS_NODE"] = "1";
delete process.env["ELECTRON_NO_ATTACH_CONSOLE"];

import {
  Artifact,
  AutoRest,
  Channel,
  DocumentType,
  IdentifyDocument,
  IFileSystem,
  IsConfigurationExtension,
  IsOpenApiDocument,
  IsOpenApiExtension,
  LiterateToJson,
  Message,
} from "../exports";
import { SourceMap } from "./source-map";

import { isDirectory, readdir, readFile } from "@azure-tools/async-io";
import { FileUriToPath, GetExtension, IsUri, ParentFolderUri, ResolveUri } from "@azure-tools/uri";
import { createHash } from "crypto";
import { From } from "linq-es2015";
import { safeDump } from "yaml-ast-parser";
import { detectConfigurationFile, detectConfigurationFiles, isConfigurationDocument } from "@autorest/configuration";
import { DocumentAnalysis } from "./document-analysis";

import {
  createConnection,
  Diagnostic,
  DiagnosticSeverity,
  FileEvent,
  Hover,
  IConnection,
  InitializeParams,
  InitializeResult,
  IPCMessageReader,
  IPCMessageWriter,
  Location,
  MarkedString,
  Position,
  Range,
  TextDocument,
  TextDocumentPositionParams,
  TextDocuments,
  TextDocumentSyncKind,
} from "vscode-languageserver";

// TODO: adding URL here temporarily, this should be coming either in the message coming from autorest or the plugin
const azureValidatorRulesDocUrl =
  "https://github.com/Azure/azure-rest-api-specs/blob/current/documentation/openapi-authoring-automated-guidelines.md";

const md5 = (content: any) => (content ? createHash("md5").update(JSON.stringify(content)).digest("hex") : null);

/** private per-configuration run state */
class Result {
  private readonly onDispose = new Array<() => void>();
  public files = new Array<string>();
  public busy: Promise<void> = Promise.resolve();
  private queued = false;
  public readonly artifacts: Array<Artifact> = new Array<Artifact>();
  private readonly AutoRest: AutoRest;
  private static active = 0;

  public cancel: () => Promise<void> = async () => {};
  public ready = () => {};

  constructor(private readonly service: OpenApiLanguageService, private configurationUrl: string) {
    this.AutoRest = new AutoRest(service, configurationUrl);

    this.onDispose.push(this.AutoRest.GeneratedFile.Subscribe((a, artifact) => this.artifacts.push(artifact)));
    this.onDispose.push(
      this.AutoRest.Message.Subscribe((au, message) => {
        switch (message.Channel) {
          case Channel.Debug:
            service.debug(message.Text);
            break;
          case Channel.Fatal:
            service.error(message.Text);
            break;
          case Channel.Verbose:
            service.verbose(message.Text);
            break;
          case Channel.Warning:
            service.pushDiagnostic(message, DiagnosticSeverity.Warning);
            break;
          case Channel.Error:
            service.pushDiagnostic(message, DiagnosticSeverity.Error);
            break;
          case Channel.Information:
            service.pushDiagnostic(message, DiagnosticSeverity.Information);
            break;
          case Channel.Hint:
            service.pushDiagnostic(message, DiagnosticSeverity.Hint);
            break;
        }
      }),
    );

    this.onDispose.push(
      this.AutoRest.Finished.Subscribe((a, success) => {
        this.cancel = async () => {};
        // anything after it's done?
        service.debug(`Finished Autorest ${success}\n`);

        // clear diagnostics for next run
        this.clearDiagnostics();

        // and mark us done!
        Result.active--;
        this.updateStatus();
        this.ready();
      }),
    );
  }

  public clearDiagnostics(send = false) {
    const diagnostics = this.service.getDiagnosticCollection(this.configurationUrl);
    diagnostics.send();
    diagnostics.clear(send);

    for (const f of this.files) {
      const diagnostics = this.service.getDiagnosticCollection(f);
      // make sure that the last of the last is sent
      diagnostics.send();

      // then clear the collection it since we're sure this is the end of the run.
      diagnostics.clear(send);
    }
  }

  private updateStatus() {
    if (Result.active === 0) {
      this.service.endActivity("autorest");
      return;
    }
    this.service.startActivity(
      "autorest",
      "AutoRest is running",
      this.service.settings.debug ? `Validating ${Result.active} ` : "Validating",
    );
  }

  public async process() {
    if (this.queued) {
      // we're already waiting to start a run, no sense on going again.
      return;
    }
    this.queued = true;
    // make sure we're clear to start
    await this.busy;

    // reset the busy flag
    this.busy = new Promise((r) => (this.ready = r));

    // ensure that we have nothing left over from before
    this.clear();

    // now, update the status
    Result.active++;
    this.updateStatus();
    try {
      // set configuration
      await this.resetConfiguration(this.service.settings.configuration);

      // get the list of files this is running on
      this.files = (await this.AutoRest.view).config.inputFileUris;

      // start it up!
      const processResult = this.AutoRest.Process();
      this.queued = false;

      this.cancel = async () => {
        // cancel only once!
        this.cancel = async () => {};

        // cancel the current process if running.
        processResult.cancel();

        await this.busy;
      };
    } catch (E) {
      // clear diagnostics for next run
      this.clearDiagnostics();

      // and mark us done!
      Result.active--;
      this.updateStatus();
      this.ready();
      this.queued = false;
    }
  }

  public async resetConfiguration(configuration: any) {
    // wipe the previous configuration
    await this.AutoRest.ResetConfiguration();

    // set the basic defaults we need
    this.AutoRest.AddConfiguration({
      "output-artifact": ["swagger-document.json", "swagger-document.json.map"],
      // debug and verbose messages are not sent by default, turn them on so client settings can decide to show or not.
      "debug": true,
      "verbose": true,
    });

    // apply settings from the client
    if (configuration) {
      this.AutoRest.AddConfiguration(configuration);
    }
  }

  public clear() {
    this.artifacts.length = 0;
  }
}

class Diagnostics {
  // map allows us to hash the diagnostics to filter out duplicates.
  private diagnostics = new Map<string, Diagnostic>();

  public constructor(private connection: IConnection, private fileUri: string) {}

  public clear(send = false) {
    this.diagnostics.clear();
    if (send) {
      this.send();
    }
  }

  public send() {
    this.connection.sendDiagnostics({ uri: this.fileUri, diagnostics: [...this.diagnostics.values()] });
  }

  public push(diagnostic: Diagnostic, send = true) {
    const hash = md5(diagnostic) || "";
    if (!this.diagnostics.has(hash)) {
      this.diagnostics.set(hash, diagnostic);
      if (send) {
        this.send();
      }
    }
  }
}

/**
 * The results from calling the 'generate' method via the {@link AutoRestLanguageService/generate}
 *
 */
export interface GenerationResults {
  /** the array of messages produced from the run. */

  messages: Array<string>;
  /** the collection of outputted files.
   *
   * Member keys are the file names
   * Member values are the file contents
   *
   * To Access the files:
   * for( const filename in generated.files ) {
   *   const content = generated.files[filename];
   *   /// ...
   * }
   */
  files: Map<string, string>;
}

class OpenApiLanguageService extends TextDocuments implements IFileSystem {
  private results = new Map</*configfile*/ string, Result>();
  private diagnostics = new Map</*file*/ string, Diagnostics>();
  private virtualFile = new Map<string, TextDocument>();
  public settings: any = {};

  public get(uri: string): TextDocument {
    const content = super.get(uri);
    if (!content) {
      const name = decodeURIComponent(uri);
      for (const each of super.all()) {
        if (decodeURIComponent(each.uri) === name) {
          return each;
        }
      }
    }
    return content;
  }

  constructor(private connection: IConnection) {
    super();

    //  track opened, changed, saved, and closed files
    this.onDidOpen((p) => this.onDocumentChanged(p.document));
    this.onDidChangeContent((p) => this.onDocumentChanged(p.document));
    this.onDidClose((p) => this.onClosed(p.document.uri));
    this.onDidSave((p) => this.onSaving());

    // subscribe to client settings changes
    connection.onDidChangeConfiguration((config) =>
      config.settings && config.settings.autorest ? this.onSettingsChanged(config.settings.autorest) : null,
    );

    // we also get change notifications of files on disk:
    connection.onDidChangeWatchedFiles((changes) => this.onFileEvents(changes.changes));

    // requests for hover/definitions
    connection.onHover((position, _cancel) => this.onHover(position));
    connection.onDefinition((position, _cancel) => this.onDefinition(position));

    connection.onInitialize((params) => this.onInitialize(params));

    this.setStatus("Starting Up.");

    // expose the features that we want to give to the client
    connection.onRequest("generate", (p) => this.generate(p.documentUri, p.language, p.configuration));
    connection.onRequest("isOpenApiDocument", (p) => this.isOpenApiDocument(p.contentOrUri));
    connection.onRequest("identifyDocument", (p) => this.identifyDocument(p.contentOrUri));
    connection.onRequest("isConfigurationDocument", (p) => this.isConfigurationDocument(p.contentOrUri));
    connection.onRequest("isSupportedDocument", (p) => this.isSupportedDocument(p.languageId, p.contentOrUri));
    connection.onRequest("toJSON", (p) => this.toJSON(p.contentOrUri));
    connection.onRequest("detectConfigurationFile", (p) => this.detectConfigurationFile(p.documentUri));

    this.listen(connection);
  }

  private async onClosed(documentUri: string): Promise<void> {
    if (await this.isConfigurationDocument(documentUri)) {
      // if this is a configuration, clear it's own errors
      this.getDiagnosticCollection(documentUri).clear(true);

      // and if there are no files open, then clear theirs too.
      const result = this.results.get(documentUri);
      if (result) {
        // make sure it's not doing anything...
        await result.busy;

        // check if any files are still open
        for (const each of result.files) {
          if (this.get(each)) {
            return; // yes, some file was still open, just quit from here.
          }
        }
        result.clearDiagnostics(true);
      }
      return;
    }

    // just closing a file.
    const configuration = await this.getConfiguration(documentUri);
    if (!this.get(configuration)) {
      // is the configuration file for this closed?
      this.getDiagnosticCollection(documentUri).clear(true);
    }
  }

  public async generate(documentUri: string, language: string, configuration: any): Promise<GenerationResults> {
    const cfgFile = await this.getConfiguration(documentUri);
    const autorest = new AutoRest(this, cfgFile);
    const cfg: any = {};
    cfg[language] = {
      "output-folder": "/generated",
    };
    autorest.AddConfiguration(cfg);
    autorest.AddConfiguration(configuration);

    const result = {
      files: <any>{},
      messages: new Array<string>(),
    };
    autorest.GeneratedFile.Subscribe((a, artifact) => (result.files[artifact.uri] = artifact.content));
    autorest.Message.Subscribe((a, message) => result.messages.push(JSON.stringify(message, null, 2)));
    autorest.Finished.Subscribe(() => {});
    const done = autorest.Process();
    await done.finish;

    return result;
  }
  public async isOpenApiDocument(contentOrUri: string): Promise<boolean> {
    try {
      return IsUri(contentOrUri)
        ? await IsOpenApiDocument(await this.ReadFile(contentOrUri))
        : await IsOpenApiDocument(contentOrUri);
    } catch {
      // no worries
    }
    return false;
  }

  public async identifyDocument(contentOrUri: string): Promise<DocumentType> {
    try {
      return IsUri(contentOrUri)
        ? await IdentifyDocument(await this.ReadFile(contentOrUri))
        : await IdentifyDocument(contentOrUri);
    } catch {
      // no worries
    }
    return DocumentType.Unknown;
  }
  public async isConfigurationDocument(contentOrUri: string): Promise<boolean> {
    try {
      return IsUri(contentOrUri)
        ? await isConfigurationDocument(await this.ReadFile(contentOrUri))
        : await isConfigurationDocument(contentOrUri);
    } catch {
      // no worries
    }
    return false;
  }
  public async isSupportedDocument(languageId: string, contentOrUri: string): Promise<boolean> {
    try {
      if (IsOpenApiExtension(languageId) || IsConfigurationExtension(languageId)) {
        // so far, so good.
        const content = IsUri(contentOrUri) ? await this.ReadFile(contentOrUri) : contentOrUri;
        const isSwag = IsOpenApiDocument(content);
        const isConf = isConfigurationDocument(content);
        return (await isSwag) || (await isConf);
      }
    } catch {
      // no worries
    }
    return false;
  }
  public async toJSON(contentOrUri: string): Promise<string> {
    try {
      return IsUri(contentOrUri)
        ? await LiterateToJson(await this.ReadFile(contentOrUri))
        : await LiterateToJson(contentOrUri);
    } catch {
      // no worries
    }
    return "";
  }

  public async detectConfigurationFile(documentUri: string): Promise<string> {
    return this.getConfiguration(documentUri);
  }

  public setStatus(message: string) {
    this.connection.sendNotification("status", message);
  }

  public startActivity(id: string, title: string, message: string) {
    this.connection.sendNotification("startActivity", { id, title, message });
  }

  public endActivity(id: string) {
    this.connection.sendNotification("endActivity", id);
  }
  private async onSettingsChanged(serviceSettings: any) {
    // snapshot the current autorest configuration from the client
    const hash = md5(this.settings.configuration);
    this.settings = serviceSettings || {};

    if (hash !== md5(this.settings.configuration)) {
      // if the configuration change involved a change in the autorest configuration
      // we should activate all the open documents again.
      for (const document of this.all()) {
        void this.onDocumentChanged(document);
      }
    }
  }

  private async onInitialize(params: InitializeParams): Promise<InitializeResult> {
    await this.onRootUriChanged(params.rootPath || null);

    return {
      capabilities: {
        definitionProvider: true,
        hoverProvider: true,

        // Tell the client that the server works in FULL text document sync mode
        textDocumentSync: TextDocumentSyncKind.Full,
      },
    };
  }

  private async onSaving() {
    // not implemented?
  }

  private async getDocumentAnalysis(documentUri: string): Promise<DocumentAnalysis | null> {
    const config = await this.getConfiguration(documentUri);
    const result = this.results.get(config);
    if (result) {
      await result.busy; // wait for any current process to finish.
      const outputs = result.artifacts;
      const openapiDefinition = From(outputs)
        .Where((x) => x.type === "swagger-document.json")
        .Select((x) => JSON.parse(x.content))
        .FirstOrDefault();
      const openapiDefinitionMap = From(outputs)
        .Where((x) => x.type === "swagger-document.json.map")
        .Select((x) => JSON.parse(x.content))
        .FirstOrDefault();

      if (openapiDefinition && openapiDefinitionMap) {
        return new DocumentAnalysis(
          documentUri,
          await this.ReadFile(documentUri),
          openapiDefinition,
          new SourceMap(openapiDefinitionMap),
        );
      }
    }
    return null;
  }

  /*@internal*/ public getDiagnosticCollection(fileUri: string): Diagnostics {
    const diag = this.diagnostics.get(fileUri) || new Diagnostics(this.connection, fileUri);
    this.diagnostics.set(fileUri, diag);
    return diag;
  }

  public pushDiagnostic(message: Message, severity: DiagnosticSeverity) {
    let moreInfo = "";
    if (message.Plugin === "azure-validator") {
      if (message.Key) {
        moreInfo =
          "\n More info: " +
          azureValidatorRulesDocUrl +
          "#" +
          [...message.Key][1].toLowerCase() +
          "-" +
          [...message.Key][0].toLowerCase() +
          "\n";
      }
    }
    if (message.Range) {
      for (const each of message.Range) {
        // get the file reference first

        const file = this.getDiagnosticCollection(each.document);

        if (file) {
          file.push({
            severity,
            range: Range.create(
              Position.create(each.start.line - 1, each.start.column),
              Position.create(each.end.line - 1, each.end.column),
            ),
            message: message.Text + moreInfo,
            source: message.Key ? [...message.Key].join("/") : "",
          });
        }
      }
    }
  }

  private *onHoverRef(docAnalysis: DocumentAnalysis, position: Position): Iterable<MarkedString> {
    const refValueJsonPath = docAnalysis.getJsonPathFromJsonReferenceAt(position);
    if (refValueJsonPath) {
      for (const location of docAnalysis.getDefinitionLocations(refValueJsonPath)) {
        yield {
          language: "yaml",
          value: safeDump(location.value, {}),
        };
      }
    } // else {console.log("found nothing that looks like a JSON reference"); return null; }
  }

  private *onHoverJsonPath(docAnalysis: DocumentAnalysis, position: Position): Iterable<MarkedString> {
    const potentialQuery: string = <string>docAnalysis.getJsonQueryAt(position);
    if (potentialQuery) {
      const queryNodes = [...docAnalysis.getDefinitionLocations(potentialQuery)];
      yield {
        language: "plaintext",
        value: `${queryNodes.length} matches\n${queryNodes.map((node) => node.jsonPath).join("\n")}`,
      };
    } // else { console.log("found nothing that looks like a JSON path"); return null; }
  }

  private async onHover(position: TextDocumentPositionParams): Promise<Hover> {
    const docAnalysis = await this.getDocumentAnalysis(position.textDocument.uri);
    return docAnalysis
      ? <Hover>{
          contents: [
            ...this.onHoverRef(docAnalysis, position.position),
            ...this.onHoverJsonPath(docAnalysis, position.position),
          ],
        }
      : <Hover>(<any>null);
  }

  private onDefinitionRef(docAnalysis: DocumentAnalysis, position: Position): Iterable<Location> {
    const refValueJsonPath = docAnalysis.getJsonPathFromJsonReferenceAt(position);
    if (refValueJsonPath) {
      return docAnalysis.getDocumentLocations(refValueJsonPath);
    } // else  { console.log("found nothing that looks like a JSON reference"); }
    return [];
  }

  private onDefinitionJsonPath(docAnalysis: DocumentAnalysis, position: Position): Iterable<Location> {
    const potentialQuery: string = <string>docAnalysis.getJsonQueryAt(position);
    if (potentialQuery) {
      return docAnalysis.getDocumentLocations(potentialQuery);
    } // else  { console.log("found nothing that looks like a JSON path");}
    return [];
  }

  private async onDefinition(position: TextDocumentPositionParams): Promise<Array<Location>> {
    const docAnalysis = await this.getDocumentAnalysis(position.textDocument.uri);
    return docAnalysis
      ? [
          ...this.onDefinitionRef(docAnalysis, position.position),
          ...this.onDefinitionJsonPath(docAnalysis, position.position),
        ]
      : [];
  }

  private async onFileEvents(changes: Array<FileEvent>) {
    this.debug(`onFileEvents: ${JSON.stringify(changes, null, "  ")}`);
    for (const each of changes) {
      const doc = this.get(each.uri);
      if (doc) {
        void this.onDocumentChanged(doc);
        return;
      }

      const documentUri = each.uri;
      const txt = await this.ReadFile(each.uri);
      if (documentUri.startsWith("file://")) {
        // fake out a document for us to play with
        void this.onDocumentChanged({
          uri: each.uri,
          languageId: "",
          version: 1,
          getText: () => txt,
          positionAt: () => <Position>{},
          offsetAt: () => 0,
          lineCount: 1,
        });
      }
    }
  }
  // IFileSystem Implementation
  public async list(folderUri: string): Promise<Array<string>> {
    if (folderUri && folderUri.startsWith("file:")) {
      const folderPath = FileUriToPath(folderUri);
      if (await isDirectory(folderPath)) {
        const items = await readdir(folderPath);
        const results = new Array<string>();
        for (const each of items) {
          if (await IsConfigurationExtension(GetExtension(each))) {
            results.push(ResolveUri(folderUri, each));
          }
        }
        return results;
      }
    }

    return [];
  }

  public async read(fileUri: string): Promise<string> {
    const doc = this.get(fileUri) || this.virtualFile.get(fileUri);
    try {
      if (doc) {
        return doc.getText();
      }
      const content = await readFile(decodeURIComponent(FileUriToPath(fileUri)));
      return content;
    } catch {
      // no worries
    }
    throw new Error(`Unable to read ${fileUri}`);
  }

  public async EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return this.list(folderUri);
  }

  public async ReadFile(fileUri: string): Promise<string> {
    return this.read(fileUri);
  }

  private async process(configurationUrl: string) {
    const result = this.results.get(configurationUrl) || new Result(this, configurationUrl);
    this.results.set(configurationUrl, result);

    // ensure that we are no longer processing a previous run.
    await result.cancel();

    // process the files.
    await result.process();
  }

  private async getConfiguration(documentUri: string): Promise<string> {
    // let folder = ResolveUri(documentUri, ".");
    let configFiles: Array<string> = [];

    try {
      // passing a file that isn't a config file will throw now.
      configFiles = await detectConfigurationFiles(this, documentUri, undefined, true);

      // is the document a config file?
      if (configFiles.length === 1 && configFiles[0] === documentUri) {
        return documentUri;
      }
    } catch {
      // the URI is a file, and it wasn't a config file. Good to know.
    }

    if (configFiles.length === 0) {
      // this didn't find anything at all.
      // maybe try to ask for the parent folder's files
      try {
        configFiles = await detectConfigurationFiles(this, ParentFolderUri(documentUri), undefined, true);
      } catch {
        // shhh. just let it go.
      }
    }

    // is there a config file that contains the document as an input?
    for (const configFile of configFiles) {
      const a = new AutoRest(this, configFile);
      const inputs = (await a.view).config.inputFileUris;
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
        positionAt: () => <Position>{},
        offsetAt: () => 0,
        lineCount: 1,
      });
    }

    return configFile;
  }

  private async onDocumentChanged(document: TextDocument) {
    this.debug(`onDocumentChanged: ${document.uri}`);

    if ((await IsOpenApiExtension(document.languageId)) && (await IsOpenApiDocument(document.getText()))) {
      // find the configuration file and activate that.
      void this.process(await this.getConfiguration(document.uri));
      return;
    }

    // is this a config file?
    if ((await IsConfigurationExtension(document.languageId)) && (await isConfigurationDocument(document.getText()))) {
      void this.process(document.uri);
      return;
    }

    // neither
    // clear any results we have for this.
    const result = this.results.get(document.uri);
    if (result) {
      // this used to be a config file
      void result.cancel();
      result.clear();
    }

    // let's clear anything we may have sent for this file.
    this.getDiagnosticCollection(document.uri).clear(true);
  }

  public async onRootUriChanged(rootUri: string | null) {
    this.debug(`onRootUriChanged: ${rootUri}`);
    if (rootUri) {
      // check this folder for a configuration file
      const configFile = await detectConfigurationFile(this, rootUri, undefined, false);

      if (configFile) {
        const content = await this.ReadFile(configFile);
        const document = {
          uri: configFile,
          languageId: "markdown",
          version: 1,
          getText: () => content,
          positionAt: () => <Position>{},
          offsetAt: () => 0,
          lineCount: 1,
        };
        this.virtualFile.set(configFile, document);
        void this.onDocumentChanged(document);
      }
    }
  }

  public error(text: string) {
    this.connection.console.error(text);
  }
  public debug(text: string) {
    if (this.settings.debug) {
      this.connection.console.info(text);
    }
  }
  public log(text: string) {
    this.connection.console.log(text);
  }
  public verbose(text: string) {
    if (this.settings.verbose) {
      this.connection.console.log(text);
    }
  }
  public verboseDebug(text: string) {
    if (this.settings.verbose && this.settings.debug) {
      this.connection.console.info(text);
    }
  }
}

// Create the IPC Channel for the lanaguage service.
const connection: IConnection = createConnection(new IPCMessageReader(process), new IPCMessageWriter(process));

process.on("unhandledRejection", function () {
  //
  // @Future_Garrett - only turn this on as a desperate move of last resort.
  // You'll be sorry, and you will waste another day going down this rat hole
  // looking for the reason something is failing only to find out that it's only
  // during the detection if a file is swagger or not, and then you'll
  // realize why I wrote this message. Don't say I didn't warn you.
  // -- @Past_Garrett
  //
  // languageService.verboseDebug(`Unhandled Rejection Suppressed: ${err}`);
});

// Listen on the connection
connection.listen();
