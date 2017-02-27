#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { run } from "./index";
import { DataStore } from "./lib/data-store/dataStore";

async function test() {
  try {
    const dataStore = new DataStore();

    // const customUriFilter = (uri: string) => /^file/.test(uri);
    const configFileUri = "file:///C:/Users/jobader/Desktop/asd/readme.md";
    const results = await run(configFileUri);
    await results["root"].dump("C:\\Users\\jobader\\Desktop\\asd\\auto");
  } catch (e) {
    console.error(e);
  }
}

test();