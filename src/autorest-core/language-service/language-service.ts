#!/usr/bin/env node
// load static module: ${__dirname }/static_modules.fs
require('../static-loader.js').load(`${__dirname}/../static_modules.fs`)

// Ensure that if we're running in an electron process, that things will work as if it were node.
process.env['ELECTRON_RUN_AS_NODE'] = "1";
delete process.env['ELECTRON_NO_ATTACH_CONSOLE'];

import {
  createConnection, TextDocuments, TextDocument, Diagnostic, DiagnosticSeverity,
  InitializeResult, DidChangeConfigurationNotification, Proposed, ProposedFeatures,
  TextDocumentSyncKind, IConnection, IPCMessageReader, IPCMessageWriter, InitializeParams
} from 'vscode-languageserver';
import { AutoRestSettings, Settings } from './interfaces';
import { OpenApiDocumentManager } from "./document-manager"

process.on("unhandledRejection", function (err) {
  // documentManager.debug(`Unhandled Rejection Suppressed: ${err}`);
});

// Create the IPC Channel for the lanaguage service.
let connection: IConnection = createConnection(new IPCMessageReader(process), new IPCMessageWriter(process));
let documentManager = new OpenApiDocumentManager(connection);

connection.onInitialize((params): InitializeResult => {
  documentManager.SetRootUri(params.rootPath || null);

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
connection.workspace.
  // Listen on the connection
  connection.listen();
