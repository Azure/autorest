#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { runWithConfiguration } from "./index";
import { parse } from "./lib/parsing/literateYaml";
import { DataStore } from "./lib/data-store/dataStore";

async function test() {
  const dataStore = new DataStore();

  // const customUriFilter = (uri: string) => /^file/.test(uri);
  const configFileUri = "file:///C:/Users/jobader/Desktop/asd/md/input.js";
  await runWithConfiguration(configFileUri);
}

test();