/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { mergeYamls } from "../source-map/merging";
import { DataHandleRead, DataHandleWrite } from "../data-store/dataStore";
import { parse as parseLiterate } from "./literate";

export async function parse(hConfigFile: DataHandleRead, hConfig: DataHandleWrite, intermediateHandles: (key: string) => Promise<DataHandleWrite>): Promise<DataHandleRead> {
  // try parsing as literate YAML
  let hsConfigFileBlocks = await parseLiterate(hConfigFile, intermediateHandles);
  // fall back to raw YAML
  if (hsConfigFileBlocks.length == 0) {
    hsConfigFileBlocks = [hConfigFile];
  }
  // merge
  return await mergeYamls(hsConfigFileBlocks, hConfig);
}