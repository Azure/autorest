/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export { IFileSystem } from "@azure-tools/datastore";
export { Message, Channel } from "./lib/message";
export { Artifact } from "./lib/artifact";
export {
  AutoRest,
  AutorestContext,
  IdentifyDocument,
  IsConfigurationExtension,
  IsOpenApiExtension,
  LiterateToJson,
  IsOpenApiDocument,
} from "./lib/autorest-core";
export { DocumentFormat, DocumentExtension, DocumentPatterns, DocumentType } from "./lib/document-type";
export { GenerationResults } from "./language-service/language-service";
