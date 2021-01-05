/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// load modules from static linker filesystem.
try {
  if (
    process.argv.indexOf("--no-static-loader") === -1 &&
    process.env["no-static-loader"] === undefined &&
    require("fs").existsSync("./static-loader.js")
  ) {
    require("./static-loader.js").load(`${__dirname}/static_modules.fs`);
  }
} catch {
  // no worries.
}

export { IFileSystem } from "@azure-tools/datastore";
export { Message, Channel } from "./lib/message";
export { Artifact } from "./lib/artifact";
export {
  AutoRest,
  ConfigurationView,
  IdentifyDocument,
  IsConfigurationExtension,
  IsConfigurationDocument,
  IsOpenApiExtension,
  LiterateToJson,
  IsOpenApiDocument,
} from "./lib/autorest-core";
export { DocumentFormat, DocumentExtension, DocumentPatterns, DocumentType } from "./lib/document-type";
export { GenerationResults } from "./language-service/language-service";
