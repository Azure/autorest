#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { parse } from "./lib/parsing/literateYaml";
import { DataStore } from "./lib/data-store/dataStore";

async function test() {
  const dataStore = new DataStore();

  // config-file
  const hConfigFile = await dataStore.readThrough("config-file", "file:///C:/Users/jobader/Desktop/asd/md/input.js")

  // literate
  const hwConfig = await dataStore.create("config");
  const hConfig = await parse(hConfigFile, hwConfig, key => dataStore.create(key));

  console.log(await hConfig.readData());
}

test();