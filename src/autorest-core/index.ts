#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { CreateFileUri } from "./lib/approved-imports/uri";
import { Stringify } from "./lib/approved-imports/yaml";
import { DataStore, DataStoreView, KnownScopes, DataHandleRead } from "./lib/data-store/data-store";
import { AutoRestConfiguration } from "./lib/configuration/configuration";
import { RunPipeline, DataPromise } from "./lib/pipeline/pipeline";
import { MultiPromiseUtility } from "./lib/approved-imports/multi-promise";
import { CancellationToken } from "./lib/approved-imports/cancallation";

/* @internal */
export async function run(
  configurationUri: string,
  cancellationToken: CancellationToken = CancellationToken.None)
  : Promise<void> {

  const dataStore: DataStoreView = new DataStore(cancellationToken);
  const outputData = await RunPipeline(configurationUri, dataStore);
}

/* @internal */
export async function runWithKnownSetOfFiles(
  configuration: AutoRestConfiguration,
  inputFiles: { [fileName: string]: string },
  cancellationToken: CancellationToken = CancellationToken.None)
  : Promise<void> {

  const dataStore = new DataStore(cancellationToken);
  const configFileUri = CreateFileUri("config.yaml");

  // input
  const inputView = dataStore.CreateScope(KnownScopes.Input).AsFileScope();
  const hwConfig = await inputView.Write(configFileUri);
  await hwConfig.WriteData(Stringify(configuration));
  for (const fileName in inputFiles) {
    if (typeof fileName === "string") {
      const hwFile = await inputView.Write(CreateFileUri(fileName));
      await hwFile.WriteData(inputFiles[fileName]);
    }
  }

  const outputData = await RunPipeline(configFileUri, dataStore);
}

export interface IFileSystem {

}

export class AutoRest {
  public constructor(configurationUrl: string, fileSystem: IFileSystem) {
  }
}
