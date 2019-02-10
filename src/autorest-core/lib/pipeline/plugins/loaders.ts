/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { PipelinePlugin } from '../common';

import { ConfigurationView } from '../../autorest-core';
import { Channel, SourceLocation } from '../../message';
import { commonmarkHeadingFollowingText, commonmarkSubHeadings, parseCommonmark } from '../../parsing/literate';
import { parse as ParseLiterateYaml } from '../../parsing/literate-yaml';

import { CloneAst, DataHandle, DataSink, DataSource, IndexToPosition, Lines, Mapping, QuickDataSource, StrictJsonSyntaxCheck, StringifyAst } from '@microsoft.azure/datastore';

import { IdentitySourceMapping } from '../../source-map/merging';
import { crawlReferences } from './ref-crawling';

async function LoadLiterateSwaggerOverride(inputScope: DataSource, inputFileUri: string, sink: DataSink): Promise<DataHandle> {
  const commonmark = await inputScope.ReadStrict(inputFileUri);
  const rawCommonmark = commonmark.ReadData();
  const commonmarkNode = await parseCommonmark(rawCommonmark);

  const directives: Array<any> = [];
  const mappings = new Array<Mapping>();
  const state = [...commonmarkSubHeadings(commonmarkNode.firstChild)].map(x => ({ node: x, query: '$' }));

  while (state.length > 0) {
    const x = state.pop(); if (x === undefined) { throw new Error('unreachable'); }
    // extract heading clue
    // Syntax: <regular heading> (`<query>`)
    // query syntax:
    // - implicit prefix: "@." (omitted if starts with "$." or "@.")
    // - "#<asd>" to obtain the object containing a string property containing "<asd>"
    let clue: string | null = null;
    let node = x.node.firstChild;
    while (node) {
      if ((node.literal || '').endsWith('(')
        && (((node.next || <any>{}).next || {}).literal || '').startsWith(')')
        && node.next
        && node.next.type === 'code') {
        clue = node.next.literal;
        break;
      }
      node = node.next;
    }

    // process clue
    if (clue) {
      // be explicit about relativity
      if (!clue.startsWith('@.') && !clue.startsWith('$.')) {
        clue = '@.' + clue;
      }

      // make absolute
      if (clue.startsWith('@.')) {
        clue = x.query + clue.slice(1);
      }

      // replace queries
      const candidProperties = ['name', 'operationId', '$ref'];
      clue = clue.replace(/\.\#(.+?)\b/g, (_, match) => `..[?(${candidProperties.map(p => `(@[${JSON.stringify(p)}] && @[${JSON.stringify(p)}].indexOf(${JSON.stringify(match)}) !== -1)`).join(' || ')})]`);

      // target field
      const allowedTargetFields = ['description', 'summary'];
      const targetField = allowedTargetFields.filter(f => (clue || '').endsWith('.' + f))[0] || 'description';
      const targetPath = clue.endsWith('.' + targetField) ? clue.slice(0, clue.length - targetField.length - 1) : clue;

      if (targetPath !== '$.parameters' && targetPath !== '$.definitions') {
        // add directive
        const headingTextRange = commonmarkHeadingFollowingText(x.node);
        const documentation = Lines(rawCommonmark).slice(headingTextRange[0] - 1, headingTextRange[1]).join('\n');
        directives.push({
          where: targetPath,
          transform: `
            if (typeof $.${targetField} === "string" || typeof $.${targetField} === "undefined")
              $.${targetField} = ${JSON.stringify(documentation)};`
        });
      }
    }

    state.push(...[...commonmarkSubHeadings(x.node)].map(y => ({ node: y, query: clue || x.query })));
  }

  return sink.WriteObject('override-directives', { directive: directives }, [inputFileUri], undefined, mappings, [commonmark]);
}

async function LoadLiterateOpenAPIOverride(inputScope: DataSource, inputFileUri: string, sink: DataSink): Promise<DataHandle> {
  const commonmark = await inputScope.ReadStrict(inputFileUri);
  const rawCommonmark = commonmark.ReadData();
  const commonmarkNode = await parseCommonmark(rawCommonmark);

  const directives: Array<any> = [];
  const mappings = new Array<Mapping>();
  const state = [...commonmarkSubHeadings(commonmarkNode.firstChild)].map(x => ({ node: x, query: '$' }));

  while (state.length > 0) {
    const x = state.pop(); if (x === undefined) { throw new Error('unreachable'); }
    // extract heading clue
    // Syntax: <regular heading> (`<query>`)
    // query syntax:
    // - implicit prefix: "@." (omitted if starts with "$." or "@.")
    // - "#<asd>" to obtain the object containing a string property containing "<asd>"
    let clue: string | null = null;
    let node = x.node.firstChild;
    while (node) {
      if ((node.literal || '').endsWith('(')
        && (((node.next || <any>{}).next || {}).literal || '').startsWith(')')
        && node.next
        && node.next.type === 'code') {
        clue = node.next.literal;
        break;
      }
      node = node.next;
    }

    // process clue
    if (clue) {
      // be explicit about relativity
      if (!clue.startsWith('@.') && !clue.startsWith('$.')) {
        clue = '@.' + clue;
      }

      // make absolute
      if (clue.startsWith('@.')) {
        clue = x.query + clue.slice(1);
      }

      // replace queries
      const candidProperties = ['name', 'operationId', '$ref'];
      clue = clue.replace(/\.\#(.+?)\b/g, (_, match) => `..[?(${candidProperties.map(p => `(@[${JSON.stringify(p)}] && @[${JSON.stringify(p)}].indexOf(${JSON.stringify(match)}) !== -1)`).join(' || ')})]`);

      // target field
      const allowedTargetFields = ['description', 'summary'];
      const targetField = allowedTargetFields.filter(f => (clue || '').endsWith('.' + f))[0] || 'description';
      const targetPath = clue.endsWith('.' + targetField) ? clue.slice(0, clue.length - targetField.length - 1) : clue;

      if (targetPath !== '$.parameters' && targetPath !== '$.definitions') {
        // add directive
        const headingTextRange = commonmarkHeadingFollowingText(x.node);
        const documentation = Lines(rawCommonmark).slice(headingTextRange[0] - 1, headingTextRange[1]).join('\n');
        directives.push({
          where: targetPath,
          transform: `
            if (typeof $.${targetField} === "string" || typeof $.${targetField} === "undefined")
              $.${targetField} = ${JSON.stringify(documentation)};`
        });
      }
    }

    state.push(...[...commonmarkSubHeadings(x.node)].map(y => ({ node: y, query: clue || x.query })));
  }

  return sink.WriteObject('override-directives', { directive: directives }, [inputFileUri], undefined, mappings, [commonmark]);
}

export async function LoadLiterateSwagger(config: ConfigurationView, inputScope: DataSource, inputFileUri: string, sink: DataSink): Promise<DataHandle | null> {
  const handle = await inputScope.ReadStrict(inputFileUri);
  checkSyntaxFromData(inputFileUri, handle, config);
  const data = await ParseLiterateYaml(config, handle, sink);
  // check OpenAPI version
  if (data.ReadObject<any>().swagger !== '2.0') {
    return null;
    // TODO: Should we throw or send an error message?
  }

  const ast = CloneAst(data.ReadYamlAst());
  const mapping = IdentitySourceMapping(data.key, ast);

  return sink.WriteData(handle.Description, StringifyAst(ast), [inputFileUri], undefined, mapping, [data]);
}

export async function LoadLiterateOpenAPI(config: ConfigurationView, inputScope: DataSource, inputFileUri: string, sink: DataSink): Promise<DataHandle | null> {
  const handle = await inputScope.ReadStrict(inputFileUri);
  checkSyntaxFromData(inputFileUri, handle, config);
  const data = await ParseLiterateYaml(config, handle, sink);
  if (!isOpenAPI3Spec(data.ReadObject<OpenAPI3Spec>())) {
    return null;
    // TODO: Should we throw or send an error message?
  }

  const ast = CloneAst(data.ReadYamlAst());
  const mapping = IdentitySourceMapping(data.key, ast);

  return sink.WriteData(handle.Description, StringifyAst(ast), [inputFileUri], undefined, mapping, [data]);
}

export async function LoadLiterateSwaggers(config: ConfigurationView, inputScope: DataSource, inputFileUris: Array<string>, sink: DataSink): Promise<Array<DataHandle>> {
  const rawSwaggers: Array<DataHandle> = [];
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateSwagger(config, inputScope, inputFileUri, sink);
    if (pluginInput) {
      rawSwaggers.push(pluginInput);
    }
  }
  return rawSwaggers;
}

export async function LoadLiterateOpenAPIs(config: ConfigurationView, inputScope: DataSource, inputFileUris: Array<string>, sink: DataSink): Promise<Array<DataHandle>> {
  const rawOpenApis: Array<DataHandle> = [];
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateOpenAPI(config, inputScope, inputFileUri, sink);
    if (pluginInput) {
      rawOpenApis.push(pluginInput);
    }
  }
  return rawOpenApis;
}

export async function LoadLiterateSwaggerOverrides(inputScope: DataSource, inputFileUris: Array<string>, sink: DataSink): Promise<Array<DataHandle>> {
  const rawSwaggers: Array<DataHandle> = [];
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateSwaggerOverride(inputScope, inputFileUri, sink);
    rawSwaggers.push(pluginInput);
  }
  return rawSwaggers;
}

export async function LoadLiterateOpenAPIOverrides(inputScope: DataSource, inputFileUris: Array<string>, sink: DataSink): Promise<Array<DataHandle>> {
  const rawOpenApis: Array<DataHandle> = [];
  for (const inputFileUri of inputFileUris) {
    // read literate OpenAPI
    const pluginInput = await LoadLiterateOpenAPIOverride(inputScope, inputFileUri, sink);
    rawOpenApis.push(pluginInput);
  }
  return rawOpenApis;
}

/**
 * If a JSON file is provided, it checks that the syntax is correct.
 * And if the syntax is incorrect, it puts an error message .
 */
function checkSyntaxFromData(fileUri: string, handle: DataHandle, configView: ConfigurationView): void {
  if (fileUri.toLowerCase().endsWith('.json')) {
    const error = StrictJsonSyntaxCheck(handle.ReadData());
    if (error) {
      configView.Message({
        Channel: Channel.Error,
        Text: `Syntax Error Encountered:  ${error.message}`,
        Source: [<SourceLocation>{ Position: IndexToPosition(handle, error.index), document: handle.key }],
      });
    }
  }
}

/**
 * Checks that the object has the property 'openapi' and that property has
 * the string value matching something like "3.*.*".
 */
function isOpenAPI3Spec(specObject: OpenAPI3Spec): boolean {
  const wasOpenApiVersionFound = /^3\.\d+\.\d+$/g.exec(<string>specObject.openapi);
  return (wasOpenApiVersionFound) ? true : false;
}

interface OpenAPI3Spec {
  openapi?: string;
  info?: object;
  paths?: object;
  components?: { schemas?: object };
}

/* @internal */
export function createSwaggerLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.InputFileUris;
    const swaggers = await LoadLiterateSwaggers(
      config,
      input,
      inputs,
      sink
    );

    const foundAllFiles = swaggers.length !== inputs.length;
    let result: Array<DataHandle> = [];
    if (swaggers.length === inputs.length) {
      result = await crawlReferences(input, swaggers, sink);
    }

    return new QuickDataSource(result, foundAllFiles);
  };
}

/* @internal */
export function createOpenApiLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.InputFileUris;
    const openapis = await LoadLiterateOpenAPIs(
      config,
      input,
      inputs,
      sink
    );
    let result: Array<DataHandle> = [];
    if (openapis.length === inputs.length) {
      result = await crawlReferences(input, openapis, sink);
    }
    return new QuickDataSource(result, openapis.length !== inputs.length);
  };
}


/* @internal */
export function createMarkdownOverrideSwaggerLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.InputFileUris;
    const swaggers = await LoadLiterateSwaggerOverrides(
      input,
      inputs, sink);
    const result: Array<DataHandle> = [];
    for (let i = 0; i < inputs.length; ++i) {
      result.push(await sink.Forward(inputs[i], swaggers[i]));
    }
    return new QuickDataSource(result, input.skip);
  };
}

/* @internal */
export function createMarkdownOverrideOpenApiLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.InputFileUris;
    const openapis = await LoadLiterateOpenAPIOverrides(
      input,
      inputs, sink);
    const result: Array<DataHandle> = [];
    for (let i = 0; i < inputs.length; ++i) {
      result.push(await sink.Forward(inputs[i], openapis[i]));
    }
    return new QuickDataSource(result, input.skip);
  };
}