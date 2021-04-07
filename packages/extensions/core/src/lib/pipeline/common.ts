/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource } from "@azure-tools/datastore";
import { AutorestContext } from "../context";
import { length } from "@azure-tools/linq";

export type PipelinePlugin = (config: AutorestContext, input: DataSource, sink: DataSink) => Promise<DataSource>;

/** @internal */
export function createPerFilePlugin(
  processorBuilder: (config: AutorestContext) => Promise<(input: DataHandle, sink: DataSink) => Promise<DataHandle>>,
): PipelinePlugin {
  return async (config, input, sink) => {
    const processor = await processorBuilder(config);
    const files = await input.Enum();
    const result: Array<DataHandle> = [];
    for (const file of files) {
      const fileIn = await input.ReadStrict(file);
      try {
        // only keep/process files that actually have content in them (ie, no empty objects, no {directive:[]} files ).
        const pluginInput = await fileIn.ReadObject<any>();

        if (!(length(pluginInput) === 1 && pluginInput.directive) || length(pluginInput) === 0) {
          result.push(await processor(fileIn, sink));
        }
      } catch {
        // not an object anyway
        result.push(await processor(fileIn, sink));
      }
    }
    return new QuickDataSource(result, input.pipeState);
  };
}
