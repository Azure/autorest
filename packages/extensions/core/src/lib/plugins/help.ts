/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { QuickDataSource } from "@azure-tools/datastore";
import { PipelinePlugin } from "../pipeline/common";

/* @internal */
export function createHelpPlugin(): PipelinePlugin {
  return async (config) => {
    const help: { [helpKey: string]: any } = config.GetEntry("help-content");
    if (help) {
      for (const helpKey of Object.keys(help).sort()) {
        config.GeneratedFile.Dispatch({
          type: "help",
          uri: `${helpKey}.json`,
          content: JSON.stringify(help[helpKey]),
        });
      }
    }
    return new QuickDataSource([]);
  };
}
