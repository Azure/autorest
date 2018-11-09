"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
//#!/usr/bin/env node
// load modules from static linker filesystem.
if (process.argv.indexOf("--no-static-loader") === -1 && process.env["no-static-loader"] === undefined && require('fs').existsSync('./static-loader.js')) {
    require('../static-loader.js').load(`${__dirname}/../static_modules.fs`);
}
// Ensure that if we're running in an electron process, that things will work as if it were node.
process.env['ELECTRON_RUN_AS_NODE'] = "1";
delete process.env['ELECTRON_NO_ATTACH_CONSOLE'];
const main_1 = require("../main");
const source_map_1 = require("./source-map");
const uri_1 = require("@microsoft.azure/uri");
const linq_es2015_1 = require("linq-es2015");
const yaml_ast_parser_1 = require("yaml-ast-parser");
const document_analysis_1 = require("./document-analysis");
const async_io_1 = require("@microsoft.azure/async-io");
const crypto_1 = require("crypto");
const configuration_1 = require("../lib/configuration");
const vscode_languageserver_1 = require("vscode-languageserver");
//TODO: adding URL here temporarily, this should be coming either in the message coming from autorest or the plugin
const azureValidatorRulesDocUrl = "https://github.com/Azure/azure-rest-api-specs/blob/current/documentation/openapi-authoring-automated-guidelines.md";
const md5 = (content) => content ? crypto_1.createHash('md5').update(JSON.stringify(content)).digest("hex") : null;
/** private per-configuration run state */
class Result {
    constructor(service, configurationUrl) {
        this.service = service;
        this.configurationUrl = configurationUrl;
        this.onDispose = new Array();
        this.files = new Array();
        this.busy = Promise.resolve();
        this.queued = false;
        this.artifacts = new Array();
        this.cancel = async () => { };
        this.ready = () => { };
        this.AutoRest = new main_1.AutoRest(service, configurationUrl);
        this.onDispose.push(this.AutoRest.GeneratedFile.Subscribe((a, artifact) => this.artifacts.push(artifact)));
        this.onDispose.push(this.AutoRest.Message.Subscribe((au, message) => {
            switch (message.Channel) {
                case main_1.Channel.Debug:
                    service.debug(message.Text);
                    break;
                case main_1.Channel.Fatal:
                    service.error(message.Text);
                    break;
                case main_1.Channel.Verbose:
                    service.verbose(message.Text);
                    break;
                case main_1.Channel.Information:
                    service.log(message.Text);
                    break;
                case main_1.Channel.Warning:
                    service.pushDiagnostic(message, vscode_languageserver_1.DiagnosticSeverity.Warning);
                    break;
                case main_1.Channel.Error:
                    service.pushDiagnostic(message, vscode_languageserver_1.DiagnosticSeverity.Error);
                    break;
                case main_1.Channel.Information:
                    service.pushDiagnostic(message, vscode_languageserver_1.DiagnosticSeverity.Information);
                    break;
                case main_1.Channel.Hint:
                    service.pushDiagnostic(message, vscode_languageserver_1.DiagnosticSeverity.Hint);
                    break;
            }
        }));
        this.onDispose.push(this.AutoRest.Finished.Subscribe((a, success) => {
            this.cancel = async () => { };
            // anything after it's done?
            service.debug(`Finished Autorest ${success}\n`);
            // clear diagnostics for next run
            this.clearDiagnostics();
            // and mark us done!
            Result.active--;
            this.updateStatus();
            this.ready();
        }));
    }
    dispose() {
        for (const each of this.onDispose) {
            each();
        }
    }
    clearDiagnostics(send = false) {
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
    updateStatus() {
        if (Result.active === 0) {
            this.service.endActivity("autorest");
            return;
        }
        this.service.startActivity("autorest", "AutoRest is running", this.service.settings.debug ? `Validating ${Result.active} ` : "Validating");
    }
    async process() {
        if (this.queued) {
            // we're already waiting to start a run, no sense on going again.
            return;
        }
        this.queued = true;
        // make sure we're clear to start
        await this.busy;
        // reset the busy flag
        this.busy = new Promise((r, j) => this.ready = r);
        // ensure that we have nothing left over from before
        this.clear();
        // now, update the status
        Result.active++;
        this.updateStatus();
        try {
            // set configuration
            await this.resetConfiguration(this.service.settings.configuration);
            // get the list of files this is running on
            this.files = (await this.AutoRest.view).InputFileUris;
            // start it up!
            const processResult = this.AutoRest.Process();
            this.queued = false;
            this.cancel = async () => {
                // cancel only once!
                this.cancel = async () => { };
                // cancel the current process if running.
                processResult.cancel();
                await this.busy;
            };
        }
        catch (E) {
            // clear diagnostics for next run
            this.clearDiagnostics();
            // and mark us done!
            Result.active--;
            this.updateStatus();
            this.ready();
            this.queued = false;
        }
    }
    async resetConfiguration(configuration) {
        // wipe the previous configuration
        await this.AutoRest.ResetConfiguration();
        // set the basic defaults we need
        this.AutoRest.AddConfiguration({
            "output-artifact": ["swagger-document.json", "swagger-document.json.map"]
            // debug and verbose messages are not sent by default, turn them on so client settings can decide to show or not.
            ,
            debug: true,
            verbose: true
        });
        // apply settings from the client
        if (configuration) {
            this.AutoRest.AddConfiguration(configuration);
        }
    }
    clear() {
        this.artifacts.length = 0;
    }
}
Result.active = 0;
class Diagnostics {
    constructor(connection, fileUri) {
        this.connection = connection;
        this.fileUri = fileUri;
        // map allows us to hash the diagnostics to filter out duplicates.
        this.diagnostics = new Map();
    }
    clear(send = false) {
        this.diagnostics.clear();
        if (send) {
            this.send();
        }
    }
    send() {
        this.connection.sendDiagnostics({ uri: this.fileUri, diagnostics: [...this.diagnostics.values()] });
    }
    push(diagnostic, send = true) {
        const hash = md5(diagnostic) || "";
        if (!this.diagnostics.has(hash)) {
            this.diagnostics.set(hash, diagnostic);
            if (send) {
                this.send();
            }
        }
    }
}
class OpenApiLanguageService extends vscode_languageserver_1.TextDocuments {
    constructor(connection) {
        super();
        this.connection = connection;
        this.results = new Map();
        this.diagnostics = new Map();
        this.virtualFile = new Map();
        this.settings = {};
        //  track opened, changed, saved, and closed files
        this.onDidOpen((p) => this.onDocumentChanged(p.document));
        this.onDidChangeContent((p) => this.onDocumentChanged(p.document));
        this.onDidClose((p) => this.onClosed(p.document.uri));
        this.onDidSave((p) => this.onSaving(p.document));
        // subscribe to client settings changes
        connection.onDidChangeConfiguration(config => config.settings && config.settings.autorest ? this.onSettingsChanged(config.settings.autorest) : null);
        // we also get change notifications of files on disk:
        connection.onDidChangeWatchedFiles((changes) => this.onFileEvents(changes.changes));
        // requests for hover/definitions
        connection.onHover((position, _cancel) => this.onHover(position));
        connection.onDefinition((position, _cancel) => this.onDefinition(position));
        connection.onInitialize(params => this.onInitialize(params));
        this.setStatus("Starting Up.");
        // expose the features that we want to give to the client
        connection.onRequest("generate", (p) => this.generate(p.documentUri, p.language, p.configuration));
        connection.onRequest("isOpenApiDocument", (p) => this.isOpenApiDocument(p.contentOrUri));
        connection.onRequest("identifyDocument", (p) => this.identifyDocument(p.contentOrUri));
        connection.onRequest("isConfigurationDocument", (p) => this.isConfigurationDocument(p.contentOrUri));
        connection.onRequest("isSupportedDocument", (p) => this.isSupportedDocument(p.languageId, p.contentOrUri));
        connection.onRequest("toJSON", (p) => this.toJSON(p.contentOrUri));
        connection.onRequest("detectConfigurationFile", p => this.detectConfigurationFile(p.documentUri));
        this.listen(connection);
    }
    get(uri) {
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
    async onClosed(documentUri) {
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
        const configuration = await this.getConfiguration(documentUri, false);
        if (!this.get(configuration)) {
            // is the configuration file for this closed?
            this.getDiagnosticCollection(documentUri).clear(true);
        }
    }
    async generate(documentUri, language, configuration) {
        const cfgFile = await this.getConfiguration(documentUri);
        const autorest = new main_1.AutoRest(this, cfgFile);
        const cfg = {};
        cfg[language] = {
            "output-folder": "/generated"
        };
        autorest.AddConfiguration(cfg);
        autorest.AddConfiguration(configuration);
        const result = {
            files: {},
            messages: new Array()
        };
        autorest.GeneratedFile.Subscribe((a, artifact) => result.files[artifact.uri] = artifact.content);
        autorest.Message.Subscribe((a, message) => result.messages.push(JSON.stringify(message, null, 2)));
        autorest.Finished.Subscribe((a, success) => { });
        const done = autorest.Process();
        await done.finish;
        return result;
    }
    async isOpenApiDocument(contentOrUri) {
        try {
            return uri_1.IsUri(contentOrUri) ? await main_1.IsOpenApiDocument(await this.ReadFile(contentOrUri)) : await main_1.IsOpenApiDocument(contentOrUri);
        }
        catch (_a) { }
        return false;
    }
    async identifyDocument(contentOrUri) {
        try {
            return uri_1.IsUri(contentOrUri) ? await main_1.IdentifyDocument(await this.ReadFile(contentOrUri)) : await main_1.IdentifyDocument(contentOrUri);
        }
        catch (_a) { }
        return main_1.DocumentType.Unknown;
    }
    async isConfigurationDocument(contentOrUri) {
        try {
            return uri_1.IsUri(contentOrUri) ? await main_1.IsConfigurationDocument(await this.ReadFile(contentOrUri)) : await main_1.IsConfigurationDocument(contentOrUri);
        }
        catch (_a) { }
        return false;
    }
    async isSupportedDocument(languageId, contentOrUri) {
        try {
            if (main_1.IsOpenApiExtension(languageId) || main_1.IsConfigurationExtension(languageId)) {
                // so far, so good.
                const content = uri_1.IsUri(contentOrUri) ? await this.ReadFile(contentOrUri) : contentOrUri;
                const isSwag = main_1.IsOpenApiDocument(content);
                const isConf = main_1.IsConfigurationDocument(content);
                return await isSwag || await isConf;
            }
        }
        catch (_a) { }
        return false;
    }
    async toJSON(contentOrUri) {
        try {
            return uri_1.IsUri(contentOrUri) ? await main_1.LiterateToJson(await this.ReadFile(contentOrUri)) : await main_1.LiterateToJson(contentOrUri);
        }
        catch (_a) { }
        return "";
    }
    async detectConfigurationFile(documentUri) {
        return await this.getConfiguration(documentUri, false);
    }
    setStatus(message) {
        this.connection.sendNotification("status", message);
    }
    startActivity(id, title, message) {
        this.connection.sendNotification("startActivity", { id: id, title: title, message: message });
    }
    endActivity(id) {
        this.connection.sendNotification("endActivity", id);
    }
    async onSettingsChanged(serviceSettings) {
        // snapshot the current autorest configuration from the client
        const hash = md5(this.settings.configuration);
        this.settings = serviceSettings || {};
        if (hash !== md5(this.settings.configuration)) {
            // if the configuration change involved a change in the autorest configuration
            // we should activate all the open documents again.
            for (const document of this.all()) {
                this.onDocumentChanged(document);
            }
        }
    }
    async onInitialize(params) {
        await this.onRootUriChanged(params.rootPath || null);
        return {
            capabilities: {
                definitionProvider: true,
                hoverProvider: true,
                // Tell the client that the server works in FULL text document sync mode
                textDocumentSync: vscode_languageserver_1.TextDocumentSyncKind.Full,
            }
        };
    }
    async onSaving(document) {
    }
    async getDocumentAnalysis(documentUri) {
        const config = await this.getConfiguration(documentUri);
        const result = this.results.get(config);
        if (result) {
            await result.busy; // wait for any current process to finish.
            const outputs = result.artifacts;
            const openapiDefinition = linq_es2015_1.From(outputs).Where(x => x.type === "swagger-document.json").Select(x => JSON.parse(x.content)).FirstOrDefault();
            const openapiDefinitionMap = linq_es2015_1.From(outputs).Where(x => x.type === "swagger-document.json.map").Select(x => JSON.parse(x.content)).FirstOrDefault();
            if (openapiDefinition && openapiDefinitionMap) {
                return new document_analysis_1.DocumentAnalysis(documentUri, await this.ReadFile(documentUri), openapiDefinition, new source_map_1.SourceMap(openapiDefinitionMap));
            }
        }
        return null;
    }
    /*@internal*/ getDiagnosticCollection(fileUri) {
        const diag = this.diagnostics.get(fileUri) || new Diagnostics(this.connection, fileUri);
        this.diagnostics.set(fileUri, diag);
        return diag;
    }
    pushDiagnostic(message, severity) {
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
                    file.push({
                        severity: severity,
                        range: vscode_languageserver_1.Range.create(vscode_languageserver_1.Position.create(each.start.line - 1, each.start.column), vscode_languageserver_1.Position.create(each.end.line - 1, each.end.column)),
                        message: message.Text + moreInfo,
                        source: message.Key ? [...message.Key].join("/") : ""
                    });
                }
                else {
                    // console.log(each.document)
                }
            }
        }
    }
    *onHoverRef(docAnalysis, position) {
        const refValueJsonPath = docAnalysis.GetJsonPathFromJsonReferenceAt(position);
        if (refValueJsonPath) {
            for (const location of docAnalysis.GetDefinitionLocations(refValueJsonPath)) {
                yield {
                    language: "yaml",
                    value: yaml_ast_parser_1.safeDump(location.value, {})
                };
            }
        } // else {console.log("found nothing that looks like a JSON reference"); return null; }
    }
    *onHoverJsonPath(docAnalysis, position) {
        const potentialQuery = docAnalysis.GetJsonQueryAt(position);
        if (potentialQuery) {
            const queryNodes = [...docAnalysis.GetDefinitionLocations(potentialQuery)];
            yield {
                language: "plaintext",
                value: `${queryNodes.length} matches\n${queryNodes.map(node => node.jsonPath).join("\n")}`
            };
        } // else { console.log("found nothing that looks like a JSON path"); return null; }
    }
    async onHover(position) {
        const docAnalysis = await this.getDocumentAnalysis(position.textDocument.uri);
        return docAnalysis ? {
            contents: [
                ...this.onHoverRef(docAnalysis, position.position),
                ...this.onHoverJsonPath(docAnalysis, position.position)
            ]
        } : null;
    }
    onDefinitionRef(docAnalysis, position) {
        const refValueJsonPath = docAnalysis.GetJsonPathFromJsonReferenceAt(position);
        if (refValueJsonPath) {
            return docAnalysis.GetDocumentLocations(refValueJsonPath);
        } // else  { console.log("found nothing that looks like a JSON reference"); }
        return [];
    }
    onDefinitionJsonPath(docAnalysis, position) {
        const potentialQuery = docAnalysis.GetJsonQueryAt(position);
        if (potentialQuery) {
            return docAnalysis.GetDocumentLocations(potentialQuery);
        } // else  { console.log("found nothing that looks like a JSON path");}
        return [];
    }
    async onDefinition(position) {
        const docAnalysis = await this.getDocumentAnalysis(position.textDocument.uri);
        return docAnalysis ? [
            ...this.onDefinitionRef(docAnalysis, position.position),
            ...this.onDefinitionJsonPath(docAnalysis, position.position)
        ] : [];
    }
    async onFileEvents(changes) {
        this.debug(`onFileEvents: ${JSON.stringify(changes, null, "  ")}`);
        for (const each of changes) {
            const doc = this.get(each.uri);
            if (doc) {
                this.onDocumentChanged(doc);
                return;
            }
            let documentUri = each.uri;
            const txt = await this.ReadFile(each.uri);
            if (documentUri.startsWith("file://")) {
                // fake out a document for us to play with
                this.onDocumentChanged({
                    uri: each.uri,
                    languageId: "",
                    version: 1,
                    getText: () => txt,
                    positionAt: (offset) => ({}),
                    offsetAt: (position) => 0,
                    lineCount: 1
                });
            }
        }
    }
    // IFileSystem Implementation
    async EnumerateFileUris(folderUri) {
        if (folderUri && folderUri.startsWith("file:")) {
            const folderPath = uri_1.FileUriToPath(folderUri);
            if (await async_io_1.isDirectory(folderPath)) {
                const items = await async_io_1.readdir(folderPath);
                const results = new Array();
                for (const each of items) {
                    if (await main_1.IsConfigurationExtension(uri_1.GetExtension(each))) {
                        results.push(uri_1.ResolveUri(folderUri, each));
                    }
                }
                return results;
            }
        }
        return [];
    }
    async ReadFile(fileUri) {
        const doc = this.get(fileUri) || this.virtualFile.get(fileUri);
        try {
            if (doc) {
                return doc.getText();
            }
            const content = await async_io_1.readFile(decodeURIComponent(uri_1.FileUriToPath(fileUri)));
            return content;
        }
        catch (_a) {
        }
        throw new Error(`Unable to read ${fileUri}`);
    }
    async process(configurationUrl) {
        const result = this.results.get(configurationUrl) || new Result(this, configurationUrl);
        this.results.set(configurationUrl, result);
        // ensure that we are no longer processing a previous run.
        await result.cancel();
        // process the files.
        await result.process();
    }
    async getConfiguration(documentUri, generateFake = true) {
        // let folder = ResolveUri(documentUri, ".");
        let configFiles = [];
        try {
            // passing a file that isn't a config file will throw now.
            configFiles = await configuration_1.Configuration.DetectConfigurationFiles(this, documentUri, undefined, true);
            // is the document a config file?
            if (configFiles.length === 1 && configFiles[0] === documentUri) {
                return documentUri;
            }
        }
        catch (_a) {
            // the URI is a file, and it wasn't a config file. Good to know.
        }
        if (configFiles.length === 0) {
            // this didn't find anything at all.
            // maybe try to ask for the parent folder's files
            try {
                configFiles = await configuration_1.Configuration.DetectConfigurationFiles(this, uri_1.ParentFolderUri(documentUri), undefined, true);
            }
            catch (_b) {
                // shhh. just let it go.
            }
        }
        // is there a config file that contains the document as an input?
        for (const configFile of configFiles) {
            const a = new main_1.AutoRest(this, configFile);
            const inputs = (await a.view).InputFileUris;
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
                positionAt: (offset) => ({}),
                offsetAt: (position) => 0,
                lineCount: 1
            });
        }
        return configFile;
    }
    async onDocumentChanged(document) {
        this.debug(`onDocumentChanged: ${document.uri}`);
        if (await main_1.IsOpenApiExtension(document.languageId) && await main_1.IsOpenApiDocument(document.getText())) {
            // find the configuration file and activate that.
            this.process(await this.getConfiguration(document.uri));
            return;
        }
        // is this a config file?
        if (await main_1.IsConfigurationExtension(document.languageId) && await main_1.IsConfigurationDocument(document.getText())) {
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
    async onRootUriChanged(rootUri) {
        this.debug(`onRootUriChanged: ${rootUri}`);
        if (rootUri) {
            // check this folder for a configuration file
            const configFile = await configuration_1.Configuration.DetectConfigurationFile(this, rootUri, undefined, false);
            if (configFile) {
                const content = await this.ReadFile(configFile);
                const document = {
                    uri: configFile,
                    languageId: "markdown",
                    version: 1,
                    getText: () => content,
                    positionAt: (offset) => ({}),
                    offsetAt: (position) => 0,
                    lineCount: 1
                };
                this.virtualFile.set(configFile, document);
                this.onDocumentChanged(document);
            }
        }
    }
    error(text) {
        this.connection.console.error(text);
    }
    debug(text) {
        if (this.settings.debug) {
            this.connection.console.info(text);
        }
    }
    log(text) {
        this.connection.console.log(text);
    }
    verbose(text) {
        if (this.settings.verbose) {
            this.connection.console.log(text);
        }
    }
    verboseDebug(text) {
        if (this.settings.verbose && this.settings.debug) {
            this.connection.console.info(text);
        }
    }
}
// Create the IPC Channel for the lanaguage service.
let connection = vscode_languageserver_1.createConnection(new vscode_languageserver_1.IPCMessageReader(process), new vscode_languageserver_1.IPCMessageWriter(process));
let languageService = new OpenApiLanguageService(connection);
process.on("unhandledRejection", function (err) {
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
//# sourceMappingURL=language-service.js.map