/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { mergeYamls } from "../source-map/merging";
import { DataHandleRead, DataHandleWrite } from "../data-store/dataStore";
import { parse as parseLiterate } from "./literate";

function tryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

export async function parse(hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateHandles: (key: string) => Promise<DataHandleWrite>): Promise<DataHandleRead> {
  let hsConfigFileBlocks: DataHandleRead[] = [];

  // try parsing as literate YAML
  if (tryMarkdown(await hLiterate.readData())) {
    hsConfigFileBlocks = await parseLiterate(hLiterate, intermediateHandles);
  }

  // fall back to raw YAML
  if (hsConfigFileBlocks.length == 0) {
    hsConfigFileBlocks = [hLiterate];
  }

  // merge
  return await mergeYamls(hsConfigFileBlocks, hResult);
}