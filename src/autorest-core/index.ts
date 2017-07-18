#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

require("./lib/polyfill.min.js");
export { IFileSystem } from "./lib/file-system"
export { Message, Channel } from "./lib/message"
export { AutoRest, ConfigurationView } from "./lib/autorest-core"
export { DocumentType, DocumentExtension, DocumentPatterns } from "./lib/document-type"
