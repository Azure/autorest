/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export enum DocumentType {
  OpenAPI2 = <any>"OpenAPI2",
  OpenAPI3 = <any>"OpenAPI3",
  LiterateConfiguration = <any>"LiterateConfiguration",
  Unknown = <any>"Unknown",
}

export enum DocumentFormat {
  Markdown = <any>"markdown",
  Yaml = <any>"yaml",
  Json = <any>"json",
  Unknown = <any>"unknown",
}

export const DocumentExtension = {
  yaml: DocumentFormat.Yaml,
  yml: DocumentFormat.Yaml,
  json: DocumentFormat.Json,
  md: DocumentFormat.Markdown,
  markdown: DocumentFormat.Markdown,
};

export const DocumentPatterns = {
  yaml: [`*.${DocumentExtension.yaml}`, `*.${DocumentExtension.yml}`],
  json: [`*.${DocumentExtension.json}`],
  markdown: [`*.${DocumentExtension.markdown}`, `*.${DocumentExtension.md}`],
  all: [""],
};
DocumentPatterns.all = [...DocumentPatterns.yaml, ...DocumentPatterns.json, ...DocumentPatterns.markdown];
