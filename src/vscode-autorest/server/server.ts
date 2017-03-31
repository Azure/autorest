
/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
'use strict';
// polyfills for language support 
require('../node_modules/autorest/lib/polyfill.min.js');

import {
  IPCMessageReader, IPCMessageWriter,
  createConnection, IConnection, TextDocumentSyncKind,
  TextDocuments, TextDocument, Diagnostic, DiagnosticSeverity, DidChangeConfigurationParams,
  InitializeParams, InitializeResult, TextDocumentPositionParams,
  CompletionItem, CompletionItemKind, Range, Position
} from 'vscode-languageserver';
import { Enumerable as IEnumerable, From } from 'linq-es2015';
import { Installer } from "../node_modules/autorest/installer";
import { Asset, Github, Release } from '../node_modules/autorest/github'
// import { AutoRestManager } from './autorest-manager';
import { Settings, AutoRestSettings } from './interfaces'
import * as semver from 'semver'

export const connection: IConnection = createConnection(new IPCMessageReader(process), new IPCMessageWriter(process));
(<any>global).connection = connection;
(<any>global).settings = null;

connection.onInitialize(initialize);
connection.onDidChangeConfiguration((config: DidChangeConfigurationParams) => {
  (<any>global).settings = <Settings>config.settings;

  // if this is the first time we've been here, we can bootstrap autorest and start the manager.
  // bootstrap autorest itself 
  main().then((result) => {
    if (result) {
      // we have a version of AutoRest installed that we can use.
      // let's start the extension
      require("./autorest-manager");
    } else {
      error("Unable to install components for autorest-core -- extension is disabled (reload the window to retry)")
    }
  });
})

const log = (text) => connection.console.log(text);
const warn = (text) => connection.console.warn(text);
const error = (text) => connection.console.error(text);

// After the server has started the client sends an initialize request. The server receives
// in the passed params the rootPath of the workspace plus the client capabilities. 
async function initialize(params: InitializeParams): Promise<InitializeResult> {
  // store the initializationParameters for later.
  (<any>global).initializeParams = params;

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
}

// bootstrap AutoRest first

let currentVersion: string | null | undefined = Installer.LatestAutorestVersion;

async function GetReleases(): Promise<IEnumerable<Release>> {
  return (await Github.List()).Where(each => semver.valid(each.name, false) != null);
}

async function main(): Promise<boolean> {
  const installs = new Array<Promise<any>>();
  let fw: Promise<string>;
  let ar: Promise<string>;

  // ensure that the framework is Installed
  if (!Installer.LatestFrameworkVersion) {
    log(`Dotnet Framework not installed. Attempting to install it.`);
    fw = Installer.InstallFramework((<any>global).settings.autorest.runtimeId);
  }

  const cur = Installer.LatestAutorestVersion;
  if (!cur || semver.gt((<any>global).settings.autorest.minimumAutoRestVersion, cur)) {
    // minimum version required.
    let releases = await GetReleases();
    const version = releases.FirstOrDefault().name;
    ar = Installer.InstallAutoRest(version);
  }

  try {
    if (fw) {
      await fw;
    }
  }
  catch (exception) {
    error(`Unable to install framework: ${exception}`)
    return false;
  }

  try {
    if (ar) {
      await ar;
    }
  }
  catch (exception) {
    error(`Unable to install autorest: ${exception}`)
    return false;
  }

  return true;
}

connection.listen();
