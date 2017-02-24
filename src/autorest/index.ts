#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { stringify } from "./lib/parsing/yaml";
import { DataStore, DataStoreView, DataHandleRead, DataStoreViewReadonly, KnownScopes } from "./lib/data-store/dataStore";
import { AutoRestConfiguration } from "./lib/configuration/configuration";
import { Pipeline } from "./lib/pipeline/pipeline";

export async function run(configuration: DataHandleRead, pipelineView: DataStoreView): Promise<{ [productKey: string]: DataStoreViewReadonly }> {
  const pipeline = new Pipeline(configuration);
  return await pipeline.run(pipelineView);
}

export async function runWithKnownSetOfFiles(configuration: AutoRestConfiguration, inputFiles: { [fileName: string]: string }): Promise<{ [productKey: string]: DataStoreViewReadonly }> {
  const dataStore = new DataStore();

  // input
  const inputView = dataStore.createFileScope(KnownScopes.Input);
  const hwConfig = await inputView.write("file:///config.yaml");
  const hConfig = await hwConfig.writeData(stringify(configuration));
  for (const fileName in inputFiles) {
    if (typeof fileName === "string") {
      const hwFile = await inputView.write("file:///" + fileName);
      await hwFile.writeData(inputFiles[fileName]);
    }
  }

  return await run(hConfig, dataStore);
}

export async function runWithConfiguration(configurationUri: string, dataStore: DataStoreView = new DataStore()): Promise<{ [productKey: string]: DataStoreViewReadonly }> {
  // load configuration file
  const inputView = dataStore.createReadThroughScope(KnownScopes.Input, uri => uri === configurationUri);
  const hConfig = await inputView.read(configurationUri);
  if (hConfig === null) {
    throw new Error(`Configuration file '${configurationUri}' not found`);
  }

  return await run(hConfig, dataStore);
}