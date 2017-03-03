#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { createFileUri } from "./lib/approved-imports/uri";
import { stringify } from "./lib/approved-imports/yaml";
import { DataStore, DataStoreView, KnownScopes } from "./lib/data-store/dataStore";
import { AutoRestConfiguration } from "./lib/configuration/configuration";
import { pipeline } from "./lib/pipeline/pipeline";
import { DataPromise } from "./lib/pipeline/plugin";

/* @internal */
export async function run(configurationUri: string, dataStore: DataStoreView = new DataStore()): DataPromise {
  return pipeline(configurationUri)(dataStore);
}

/* @internal */
export async function runWithKnownSetOfFiles(configuration: AutoRestConfiguration, inputFiles: { [fileName: string]: string }): DataPromise {
  const dataStore = new DataStore();

  const configFileUri = createFileUri("config.yaml");

  // input
  const inputView = dataStore.createScope(KnownScopes.Input).asFileScope();
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

export interface IFileSystem {

}

export class AutoRest {
  public constructor(configurationUrl: string, fileSystem: IFileSystem) {
  }
}
