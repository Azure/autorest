/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { PipelinePlugin } from "../common";

import { AutorestContext } from "../../autorest-core";
import { Channel, SourceLocation } from "../../message";
import { parse as ParseLiterateYaml } from "@autorest/common";

import {
  CloneAst,
  DataHandle,
  DataSink,
  DataSource,
  IndexToPosition,
  QuickDataSource,
  StrictJsonSyntaxCheck,
  StringifyAst,
} from "@azure-tools/datastore";

import { identitySourceMapping } from "@autorest/common";
import { crawlReferences } from "./ref-crawling";

/**
 * If a JSON file is provided, it checks that the syntax is correct.
 * And if the syntax is incorrect, it puts an error message .
 */
async function checkSyntaxFromData(fileUri: string, handle: DataHandle, configView: AutorestContext): Promise<void> {
  if (fileUri.toLowerCase().endsWith(".json")) {
    const error = StrictJsonSyntaxCheck(await handle.ReadData());
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
  return wasOpenApiVersionFound ? true : false;
}

export async function LoadLiterateSwagger(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUri: string,
  sink: DataSink,
): Promise<DataHandle | null> {
  const handle = await inputScope.ReadStrict(inputFileUri);
  await checkSyntaxFromData(inputFileUri, handle, config);
  const data = await ParseLiterateYaml(config, handle, sink);
  // check OpenAPI version
  if ((await data.ReadObject<any>()).swagger !== "2.0") {
    return null;
    // TODO: Should we throw or send an error message?
  }
  config.Message({ Channel: Channel.Verbose, Text: `Reading OpenAPI 2.0 file ${inputFileUri}` });

  const ast = CloneAst(await data.ReadYamlAst());
  const mapping = identitySourceMapping(data.key, ast);

  return sink.WriteData(handle.Description, StringifyAst(ast), [inputFileUri], "swagger-document", mapping, [data]);
}

export async function LoadLiterateOpenAPI(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUri: string,
  sink: DataSink,
): Promise<DataHandle | null> {
  const handle = await inputScope.ReadStrict(inputFileUri);
  await checkSyntaxFromData(inputFileUri, handle, config);
  const data = await ParseLiterateYaml(config, handle, sink);
  if (!isOpenAPI3Spec(await data.ReadObject<OpenAPI3Spec>())) {
    return null;
    // TODO: Should we throw or send an error message?
  }
  config.Message({ Channel: Channel.Verbose, Text: `Reading OpenAPI 3.0 file ${inputFileUri}` });

  const ast = CloneAst(await data.ReadYamlAst());
  const mapping = identitySourceMapping(data.key, ast);

  return sink.WriteData(handle.Description, StringifyAst(ast), [inputFileUri], "openapi-document", mapping, [data]);
}

export async function LoadLiterateSwaggers(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUris: Array<string>,
  sink: DataSink,
): Promise<Array<DataHandle>> {
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

export async function LoadLiterateOpenAPIs(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUris: Array<string>,
  sink: DataSink,
): Promise<Array<DataHandle>> {
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

interface OpenAPI3Spec {
  openapi?: string;
  info?: object;
  paths?: object;
  components?: { schemas?: object };
}

/* @internal */
export function createSwaggerLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.config.inputFileUris;
    const swaggers = await LoadLiterateSwaggers(config, input, inputs, sink);

    const foundAllFiles = swaggers.length !== inputs.length;
    let result: Array<DataHandle> = [];
    if (swaggers.length === inputs.length) {
      result = await crawlReferences(config, input, swaggers, sink);
    }

    return new QuickDataSource(result, { skipping: foundAllFiles });
  };
}

/* @internal */
export function createOpenApiLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.config.inputFileUris;
    const openapis = await LoadLiterateOpenAPIs(config, input, inputs, sink);
    let result: Array<DataHandle> = [];
    if (openapis.length === inputs.length) {
      result = await crawlReferences(config, input, openapis, sink);
    }
    return new QuickDataSource(result, { skipping: openapis.length !== inputs.length });
  };
}
