
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
import { Enumerable as IEnumerable, From } from 'linq-es2015';
import { Installer } from "../node_modules/autorest/installer";
import { Asset, Github, Release } from '../node_modules/autorest/github'
import { AutoRestManager } from './autorest-manager';
import * as semver from 'semver'

export const connection: IConnection = createConnection(new IPCMessageReader(process), new IPCMessageWriter(process));
(<any>global).connection = connection;

const log = (text) => connection.console.log(text);
const warn = (text) => connection.console.warn(text);
const error = (text) => connection.console.error(text);

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
    fw = Installer.InstallFramework();
  }

  if (!Installer.LatestAutorestVersion) {
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

main().then((result) => {
  if (result) {
    // we have a version of AutoRest installed that we can use.
    // let's start the extension
    require("./autorest-manager");
  } else {
    error("Unable to install components for autorest-core -- extension is disabled (reload the window to retry)")
  }
});