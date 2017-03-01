/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
import { workspace, Disposable, ExtensionContext, window, commands, StatusBarItem, StatusBarAlignment, Uri, TextDocumentChangeEvent, ViewColumn } from 'vscode';
import {IPlugin, IPluginResult} from '../plugin'
module StatusBar {
    export function setup(): IPluginResult {
        let statusBarItem: StatusBarItem;
        if (!statusBarItem) {
            statusBarItem = window.createStatusBarItem(StatusBarAlignment.Left);
        }
        let editor = window.activeTextEditor;
        if (!editor) {
            statusBarItem.hide();
            return;
        }
        statusBarItem.text = "AutoRest Language Service Active";
        statusBarItem.show();
    }
}
var statusBar: IPlugin = StatusBar;
export default statusBar;