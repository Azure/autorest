/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { mergeYamls } from "../source-map/merging";
import { DataHandleRead, DataHandleWrite } from "../data-store/dataStore";
import { parse as parseLiterate } from "./literate";

export async function parse(hConfigFile: DataHandleRead, hConfig: DataHandleWrite, intermediateHandles: (key: string) => Promise<DataHandleWrite>): Promise<DataHandleRead> {
  const hsConfigFileBlocks = await parseLiterate(hConfigFile, intermediateHandles);
  return await mergeYamls(hsConfigFileBlocks, hConfig);
}