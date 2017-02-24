#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { parse } from "./lib/parsing/literateYaml";
import { DataStore } from "./lib/data-store/dataStore";

async function test() {
  const dataStore = new DataStore();

  // const customUriFilter = (uri: string) => /^file/.test(uri);
  const configFileUri = "file:///C:/Users/jobader/Desktop/asd/md/input.js";
  const readThroughScope = dataStore.createReadThroughScope("input", uri => uri === configFileUri);

  // config-file
  //const hConfigFile = await dataStore.readThrough("config-file.md", "file:///C:/Users/jobader/Desktop/asd/md/input.js");
  const hConfigFile = await readThroughScope.read(configFileUri);
  if (hConfigFile === null) {
    throw new Error(`'${configFileUri}' not found`);
  }

  // literate
  const hwConfig = await dataStore.write("config.yaml");
  const hConfig = await parse(hConfigFile, hwConfig, key => dataStore.write(key));

  // config
  const config = await hConfig.readObject<AutoRestConfiguration>();
  console.log(JSON.stringify(config));


  await dataStore.dump("C:\\Users\\jobader\\Desktop\\asd\\auto");
}

test();