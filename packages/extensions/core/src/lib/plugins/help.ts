/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { QuickDataSource } from "@azure-tools/datastore";
import { Help } from "../../help";
import { PipelinePlugin } from "../pipeline/common";

/* @internal */
export function createHelpPlugin(): PipelinePlugin {
  return async (config) => {
    const help: { [helpKey: string]: Help } = config.GetEntry(<any>"help-content");
    for (const helpKey of Object.keys(help).sort()) {
      config.GeneratedFile.Dispatch({
        type: "help",
        uri: `${helpKey}.json`,
        content: JSON.stringify(help[helpKey]),
      });
    }
    return new QuickDataSource([]);
  };
}
