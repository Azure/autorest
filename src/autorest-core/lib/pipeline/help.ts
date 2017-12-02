/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ReadUri, ResolveUri } from '../ref/uri';
import { QuickDataSource } from '../data-store/data-store';
import { Parse } from '../ref/yaml';
import { Help } from "../../help";
import { PipelinePlugin } from "./common";

export function GetPlugin_Help(): PipelinePlugin {
  return async config => {
    const help: { [helpKey: string]: Help } = config.GetEntry("help-content" as any);
    for (const helpKey of Object.keys(help).sort()) {
      config.GeneratedFile.Dispatch({
        type: "help",
        uri: `${helpKey}.json`,
        content: JSON.stringify(help[helpKey])
      });
    }
    return new QuickDataSource([]);
  };
}