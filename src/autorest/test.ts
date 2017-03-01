#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as commonmark from "commonmark";
import { stringify } from "./lib/parsing/yaml";
import { parseJsonPath } from "./lib/source-map/sourceMap";
import { run } from "./index";
import { DataStore } from "./lib/data-store/dataStore";

async function test() {
  try {
    const dataStore = new DataStore();

    // const customUriFilter = (uri: string) => /^file/.test(uri);
    const configFileUri = "file:///C:/Users/jobader/Desktop/asd/readme.md";
    const results = await run(configFileUri, dataStore);

    // // commonmark test
    // const mdFile = await dataStore.read("input/file%3A%2F%2F%2FC%3A%2FUsers%2Fjobader%2FDesktop%2Fasd%2Fswagger.md");
    // if (!mdFile) throw "asd";
    // const md = await mdFile.readData();
    // const mdTree = new commonmark.Parser().parse(md);
    // console.log(mdTree.firstChild.type, `"${mdTree.firstChild.firstChild.literal}"`, mdTree.firstChild.level);

    // BLAME
    console.log(stringify(await dataStore.calculateBlame("swagger/swagger.yaml", parseJsonPath("$.definitions.SearchServiceListResult.description"))));

    await dataStore.dump("C:\\Users\\jobader\\Desktop\\asd\\auto");
  } catch (e) {
    console.error(e);
  }
}

test();