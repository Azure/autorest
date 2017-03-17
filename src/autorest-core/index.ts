#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { CreateFileUri } from "./lib/approved-imports/uri";
import { Stringify } from "./lib/approved-imports/yaml";
import { DataStore, DataStoreView, KnownScopes, DataHandleRead, DataStoreViewReadonly } from "./lib/data-store/data-store";
import { AutoRestConfigurationImpl } from "./lib/configuration";
import { RunPipeline, DataPromise } from "./lib/pipeline/pipeline";
import { MultiPromiseUtility, MultiPromise } from "./lib/approved-imports/multi-promise";
import { CancellationToken } from "./lib/approved-imports/cancallation";
import { IEnumerable, From } from './lib/approved-imports/linq';
import { IEvent, EventDispatcher, EventEmitter } from "./lib/events"

export { IFileSystem } from "./lib/file-system"
export { AutoRest } from "./lib/autorest-core"
export { Message } from "./lib/autorest-core"
export { Configuration } from "./lib/configuration"

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
  configuration: AutoRestConfigurationImpl,
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
