/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource } from "@azure-tools/datastore";
import { AutorestContext } from "../context";

export type PipelinePlugin = (config: AutorestContext, input: DataSource, sink: DataSink) => Promise<DataSource>;

/** @internal */
export function createPerFilePlugin(
  processorBuilder: (config: AutorestContext) => Promise<(input: DataHandle, sink: DataSink) => Promise<DataHandle>>,
): PipelinePlugin {
  return async (context, input, sink) => {
    const processor = await processorBuilder(context);
    const files = await input.enum();
    const result: Array<DataHandle> = [];
    for (const file of files) {
      const fileIn = await input.readStrict(file);
      // try {
      // only keep/process files that actually have content in them (ie, no empty objects, no {directive:[]} files ).
      const pluginInput = await fileIn.readObject<any>();
      const keysLength = Object.keys(pluginInput).length;
      const isEmptyDirective = keysLength === 1 && pluginInput.directive;
      if (!isEmptyDirective || keysLength === 0) {
        result.push(await processor(fileIn, sink));
      } else {
        context.debug(`Not running per file plugin on file "${file}" as it is empty.`);
      }
      // } catch {
      // not an object anyway
      // Remove this?
      // result.push(await processor(fileIn, sink));
      // }
    }
    return new QuickDataSource(result, input.pipeState);
  };
}
