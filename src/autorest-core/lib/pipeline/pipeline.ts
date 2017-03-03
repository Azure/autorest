/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestConfigurationManager, AutoRestConfiguration } from "../configuration/configuration";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly, KnownScopes } from "../data-store/dataStore";
import { parse } from "../parsing/literateYaml";
import { mergeYamls } from "../source-map/merging";
import { MultiPromise, MultiPromiseUtility } from "./multi-promise";

export type DataPromise = MultiPromise<DataHandleRead>;
export type DataFactory = (workingScope: DataStoreView) => DataPromise;

// async function pluginJsonRpc(): DataPromise {
//   return (workingScope: DataStoreView) => MultiPromiseUtility.map(literate, async (literateDoc, index) => {
//     const docScope = workingScope.createScope(`doc${index}_tmp`);
//     const hwRawDoc = await workingScope.write(`doc${index}.yaml`);
//     const hRawDoc = await parse(literateDoc, hwRawDoc, docScope);
//     return hRawDoc;
//   });
// }

async function pluginLoad(inputScope: DataStoreViewReadonly, inputFileUri: string): DataPromise {
  const handle = await inputScope.read(inputFileUri);
  if (handle === null) {
    throw new Error(`Input file '${inputFileUri}' not found.`);
  }
  return MultiPromiseUtility.single(handle);
}

function pluginDeliteralizeYaml(literate: DataPromise): DataFactory {
  return (workingScope: DataStoreView) => MultiPromiseUtility.map(literate, async (literateDoc, index) => {
    const docScope = workingScope.createScope(`doc${index}_tmp`);
    const hwRawDoc = await workingScope.write(`doc${index}.yaml`);
    const hRawDoc = await parse(literateDoc, hwRawDoc, docScope);
    return hRawDoc;
  });
}

function pluginLoadLiterateYaml(inputScope: DataStoreViewReadonly, inputFileUri: string): DataFactory {
  return async (workingScope: DataStoreView) => {
    const pluginSwaggerInput: DataPromise = pluginLoad(inputScope, inputFileUri);
    const pluginDeliteralizeSwagger: DataPromise = pluginDeliteralizeYaml(pluginSwaggerInput)(workingScope);
    return pluginDeliteralizeSwagger;
  }
}

function pluginLoadLiterateSwagger(inputScope: DataStoreViewReadonly, inputFileUri: string): DataFactory {
  return async (workingScope: DataStoreView) => {
    const data: DataPromise = pluginLoadLiterateYaml(inputScope, inputFileUri)(workingScope);
    // TODO: resolve external references (Amar's magic)
    return data;
  };
}

function pluginLoadLiterateSwaggers(inputScope: DataStoreViewReadonly, inputFileUris: string[]): DataFactory {
  return async (workingScope: DataStoreView) => {
    const swaggerScope = workingScope.createScope("swagger");
    const rawSwaggers: DataPromise[] = [];
    let i = 0;
    for (const inputFileUri of inputFileUris) {
      // read literate Swagger
      const pluginInput: DataPromise = pluginLoadLiterateSwagger(inputScope, inputFileUri)
        (swaggerScope.createScope("deliteralize_" + i));
      rawSwaggers.push(pluginInput);
      i++;
    }
    const swaggers = MultiPromiseUtility.join(...rawSwaggers);
    const swagger = pluginMergeYaml(swaggers)(swaggerScope.createScope("compose"));
    return swagger;
  };
}

function pluginMergeYaml(data: DataPromise): DataFactory {
  return async (workingScope: DataStoreView) => {
    const hwSwagger = await workingScope.write("swagger.yaml");
    const inputSwaggers = await MultiPromiseUtility.gather(data);
    const hSwagger = await mergeYamls(inputSwaggers, hwSwagger);
    return MultiPromiseUtility.single(hSwagger);
  };
}

export function pipeline(configurationUri: string): DataFactory {
  return async (workingScope: DataStoreView) => {
    // load config
    const configPlugin: DataPromise = pluginLoadLiterateYaml(workingScope.createScope(KnownScopes.Input).asFileScopeReadThrough(uri => uri === configurationUri), configurationUri)
      (workingScope.createScope("config"));
    const hConfig = await MultiPromiseUtility.getSingle(configPlugin);
    const config = new AutoRestConfigurationManager(await hConfig.readObject<AutoRestConfiguration>(), configurationUri);

    // load Swaggers
    const swagger = pluginLoadLiterateSwaggers(
      // TODO: unlock further URIs here
      workingScope.createScope(KnownScopes.Input).asFileScopeReadThrough(uri => config.inputFileUris.indexOf(uri) !== -1),
      config.inputFileUris)
      (workingScope.createScope("loader"));

    // pull
    await MultiPromiseUtility.getSingle(swagger);

    return swagger;
  };
}