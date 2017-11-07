/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// load static module: ${__dirname }/static_modules.fs
require('./static-loader.js').load(`${__dirname}/static_modules.fs`)

export { IFileSystem } from "./lib/file-system"
export { Message, Channel } from "./lib/message"
export { Artifact } from "./lib/artifact"
export { AutoRest, ConfigurationView, IdentifyDocument, IsConfigurationExtension, IsConfigurationDocument, IsOpenApiExtension, LiterateToJson, IsOpenApiDocument } from "./lib/autorest-core"
export { DocumentFormat, DocumentExtension, DocumentPatterns, DocumentType } from "./lib/document-type"



