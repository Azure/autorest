import { AutoRestManager } from './autorest-manager';
/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
'use strict';

import {
  IPCMessageReader, IPCMessageWriter,
  createConnection, IConnection, TextDocumentSyncKind,
  TextDocuments, TextDocument, Diagnostic, DiagnosticSeverity,
  InitializeParams, InitializeResult, TextDocumentPositionParams,
  CompletionItem, CompletionItemKind, Range, Position
} from 'vscode-languageserver';

import { AutoRest, IFileSystem, Installer } from "autorest";
import { DocumentContext } from "./file-system";

// Create a connection for the server. The connection uses Node's IPC as a transport
export const connection: IConnection = createConnection(new IPCMessageReader(process), new IPCMessageWriter(process));

// The settings interface describe the server relevant settings part
interface Settings {
  autorest: AutoRestSettings;
}

// These are the settings we defined in the client's package.json
// file
interface AutoRestSettings {
  maxNumberOfProblems: number;
}



let manager: AutoRestManager = new AutoRestManager(connection);

// After the server has started the client sends an initialize request. The server receives
// in the passed params the rootPath of the workspace plus the client capabilities. 
connection.onInitialize(async (params): Promise<InitializeResult> => {
  connection.console.log('Starting Server Side...');
  manager.SetRootUri(params.rootUri);

  return {
    capabilities: {
      // Tell the client that the server works in FULL text document sync mode
      textDocumentSync: TextDocumentSyncKind.Full,

      // Tell the client that the server support code complete
      completionProvider: {
        resolveProvider: true
      }

    }
  }
});


// hold the maxNumberOfProblems setting
let maxNumberOfProblems: number;
// The settings have changed. Is send on server activation
// as well.
connection.onDidChangeConfiguration((change) => {
  let settings = <Settings>change.settings;
  maxNumberOfProblems = settings.autorest.maxNumberOfProblems || 100;
  // Revalidate any open text documents
  // documents.all().forEach(validateTextDocument);
});

// This handler provides the initial list of the completion items.
connection.onCompletion((textDocumentPosition: TextDocumentPositionParams): CompletionItem[] => {
  // The pass parameter contains the position of the text document in 
  // which code complete got requested. For the example we ignore this
  // info and always provide the same completion items.
  return [
    {
      label: 'TypeScript',
      kind: CompletionItemKind.Text,
      data: 1
    },
    {
      label: 'JavaScript',
      kind: CompletionItemKind.Text,
      data: 2
    }
  ]
});

// This handler resolve additional information for the item selected in
// the completion list.
connection.onCompletionResolve((item: CompletionItem): CompletionItem => {
  if (item.data === 1) {
    item.detail = 'TypeScript details',
      item.documentation = 'TypeScript documentation'
  } else if (item.data === 2) {
    item.detail = 'JavaScript details',
      item.documentation = 'JavaScript documentation'
  }
  return item;
});

let t: Thenable<string>;


// Listen on the connection
connection.listen();