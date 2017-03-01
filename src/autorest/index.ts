#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { stringify } from "./lib/parsing/yaml";
import { parse } from "./lib/parsing/literateYaml";
import { DataStore, DataStoreView, KnownScopes } from "./lib/data-store/dataStore";
import { createFileUri } from "./lib/io/input";
import { AutoRestConfiguration, AutoRestConfigurationManager } from "./lib/configuration/configuration";
import { Pipeline, PipelineProducts } from "./lib/pipeline/pipeline";

export async function run(configurationUri: string, dataStore: DataStoreView = new DataStore()): Promise<PipelineProducts> {
  // load configuration file
  const inputView = dataStore.createReadThroughScope(KnownScopes.Input, uri => uri === configurationUri);
  const hLiterateConfig = await inputView.read(configurationUri);
  if (hLiterateConfig === null) {
    throw new Error(`Configuration file '${configurationUri}' not found`);
  }

  // deliteralize
  const configScope = dataStore.createScope(KnownScopes.Configuration);
  const hwConfig = await configScope.write("config.yaml");
  const hConfig = await parse(hLiterateConfig, hwConfig, configScope.createScope("tmp"));

  // configuration manager
  const config = new AutoRestConfigurationManager(await hConfig.readObject<AutoRestConfiguration>(), configurationUri);
  const pipeline = new Pipeline(config);
  return await pipeline.run(dataStore);
}

export async function runWithKnownSetOfFiles(configuration: AutoRestConfiguration, inputFiles: { [fileName: string]: string }): Promise<PipelineProducts> {
  const dataStore = new DataStore();

  const configFileUri = createFileUri("config.yaml");

  // input
  const inputView = dataStore.createFileScope(KnownScopes.Input);
  const hwConfig = await inputView.write(configFileUri);
  await hwConfig.writeData(stringify(configuration));
  for (const fileName in inputFiles) {
    if (typeof fileName === "string") {
      const hwFile = await inputView.write(createFileUri(fileName));
      await hwFile.writeData(inputFiles[fileName]);
    }
  }

  return await run(configFileUri, dataStore);
}