/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestConfigurationManager, AutoRestConfiguration } from "../configuration/configuration";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly, KnownScopes } from "../data-store/data-store";
import { parse } from "../parsing/literateYaml";
import { mergeYamls } from "../source-map/merging";
import { MultiPromiseUtility, MultiPromise } from "../approved-imports/multi-promise";
import { CancellationToken } from "../approved-imports/cancallation";
import { AutoRestPlugin } from "./plugin-server";

export type DataPromise = MultiPromise<DataHandleRead>;

async function LoadUri(inputScope: DataStoreViewReadonly, inputFileUri: string): Promise<DataHandleRead> {
  const handle = await inputScope.Read(inputFileUri);
  if (handle === null) {
    throw new Error(`Input file '${inputFileUri}' not found.`);
  }
  return handle;
}

async function DeliteralizeYaml(literate: DataHandleRead, workingScope: DataStoreView): Promise<DataHandleRead> {
  const docScope = workingScope.CreateScope(`doc_tmp`);
  const hwRawDoc = await workingScope.Write(`doc.yaml`);
  const hRawDoc = await parse(literate, hwRawDoc, docScope);
  return hRawDoc;
}

async function LoadLiterateYaml(inputScope: DataStoreViewReadonly, inputFileUri: string, workingScope: DataStoreView): Promise<DataHandleRead> {
  const pluginSwaggerInput = await LoadUri(inputScope, inputFileUri);
  const pluginDeliteralizeSwagger = DeliteralizeYaml(pluginSwaggerInput, workingScope);
  return pluginDeliteralizeSwagger;
}

async function LoadLiterateSwagger(inputScope: DataStoreViewReadonly, inputFileUri: string, workingScope: DataStoreView): Promise<DataHandleRead> {
  const data = await LoadLiterateYaml(inputScope, inputFileUri, workingScope);
  // TODO: resolve external references (Amar's magic)
  return data;
}

async function LoadLiterateSwaggers(inputScope: DataStoreViewReadonly, inputFileUris: string[], workingScope: DataStoreView): Promise<DataHandleRead[]> {
  const swaggerScope = workingScope.CreateScope("swagger");
  const rawSwaggers: DataHandleRead[] = [];
  let i = 0;
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateSwagger(inputScope, inputFileUri, swaggerScope.CreateScope("deliteralize_" + i));
    rawSwaggers.push(pluginInput);
    i++;
  }
  return rawSwaggers;
}

async function MergeYaml(inputSwaggers: DataHandleRead[], workingScope: DataStoreView): Promise<DataHandleRead> {
  const hwSwagger = await workingScope.Write("swagger.yaml");
  const hSwagger = await mergeYamls(inputSwaggers, hwSwagger);
  return hSwagger;
}

export async function RunPipeline(configurationUri: string, workingScope: DataStoreView): Promise<{ [name: string]: DataPromise }> {
  // load config
  const hConfig = await LoadLiterateYaml(
    workingScope.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uri => uri === configurationUri),
    configurationUri,
    workingScope.CreateScope("config"));
  const config = new AutoRestConfigurationManager(await hConfig.ReadObject<AutoRestConfiguration>(), configurationUri);

  // load Swaggers
  const swaggers = await LoadLiterateSwaggers(
    // TODO: unlock further URIs here
    workingScope.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uri => config.inputFileUris.indexOf(uri) !== -1),
    config.inputFileUris, workingScope.CreateScope("loader"));

  //
  const swagger = await MergeYaml(swaggers, workingScope.CreateScope("compose"));

  return {
    componentSwaggers: MultiPromiseUtility.list(swaggers),
    swagger: MultiPromiseUtility.single(swagger)
  };
}