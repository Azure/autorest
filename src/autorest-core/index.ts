#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { CreateFileUri } from "./lib/approved-imports/uri";
import { Stringify } from "./lib/approved-imports/yaml";
import { DataStore, DataStoreView, KnownScopes, DataHandleRead, DataStoreViewReadonly } from "./lib/data-store/data-store";
import { AutoRestConfiguration } from "./lib/configuration/configuration";
import { RunPipeline, DataPromise } from "./lib/pipeline/pipeline";
import { MultiPromiseUtility, MultiPromise } from "./lib/approved-imports/multi-promise";
import { CancellationToken } from "./lib/approved-imports/cancallation";
import { IEnumerable, From } from './lib/approved-imports/linq';
import { IEvent, EventDispatcher, EventEmitter } from "./lib/events/events"

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
  readonly RootUri: string;
  EnumerateFiles(prefixPath: string): AsyncIterable<string>;
  ReadFile(path: string): Promise<string>;
}

export interface Message {
  Text: string;
}


export class AutoRest extends EventEmitter {
  /**
   * 
   * @param rootUri The rootUri of the workspace. Is null if no workspace is open. 
   * @param fileSystem The implementation of the filesystem to load and save files from the host application.
   */
  public constructor(fileSystem: IFileSystem) {
    super();

  }

  /**
   * Using the fileSystem associated with this instance, this will look at the root level for *.md files 
   * and find the configuration file.
   * 
   * The "configuration file" must have the string `\n>see https://aka.ms/autorest` in the file somewhere. 
   * 
   * If there are multiple configuration files, the file with the shortest filename wins. (aka, foo.md wins over foo.bak.md )
   */
  public get HasConfiguration(): boolean {

    return false;
  }

  /**
   * This should be called to notify AutoRest that a file has changed. 
   * 
   * @param path the path of the files that has changed 
   */
  public FileChanged(path: string) {

  }

  /**
   * Called to start processing of the files. 
   */
  public Start(): void {

  }

  /**
   * Called to stop the processing.
   */
  public Stop(): void {

  }

  /**
   * Event: Signals when a debug message is sent from AutoRest
   */
  @EventEmitter.Event public Debug: IEvent<AutoRest, Message>;


  @EventEmitter.Event public Success: IEvent<AutoRest, Message>;



}

