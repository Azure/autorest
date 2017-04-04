/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
'use strict';
require('../node_modules/autorest/lib/polyfill.min.js');
import * as path from 'path';

import { workspace, Disposable, ExtensionContext } from 'vscode';
import { LanguageClient, LanguageClientOptions, SettingMonitor, ServerOptions, TransportKind } from 'vscode-languageclient';
import StatusBar from './statusbar/setup';


export function activate(context: ExtensionContext) {
  // Set up status bar


  // The server is implemented in node
  let serverModule = context.asAbsolutePath(path.join('server', 'server.js'));
  // The debug options for the server
  let debugOptions = { execArgv: ["--nolazy", "--debug=6009"] };

  // If the extension is launched in debug mode then the debug server options are used
  // Otherwise the run options are used
  let serverOptions: ServerOptions = {
    run: { module: serverModule, transport: TransportKind.ipc },
    debug: { module: serverModule, transport: TransportKind.ipc, options: debugOptions }
  }

  // Options to control the language client
  let clientOptions: LanguageClientOptions = {
    // Register the server for plain text documents
    documentSelector: ['json', 'yaml', 'markdown'],
    synchronize: {
      // Synchronize the setting section 'autorest' to the server
      configurationSection: 'autorest',
      // Notify the server about file changes to '.clientrc files contain in the workspace
      fileEvents: [
        workspace.createFileSystemWatcher('**/*.md'),
        workspace.createFileSystemWatcher('**/*.markdown'),
        workspace.createFileSystemWatcher('**/*.yaml'),
        workspace.createFileSystemWatcher('**/*.yml'),
        workspace.createFileSystemWatcher('**/*.json')
      ]

    }

  }

  // Create the language client and start the client.
  let disposable = new LanguageClient('autorest', 'Autorest Language Service', serverOptions, clientOptions).start();

  // Push the disposable to the context's subscriptions so that the 
  // client can be deactivated on extension deactivation
  context.subscriptions.push(disposable);

  StatusBar.setup();
}
