/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource } from '@azure-tools/datastore';
import { ConfigurationView } from '../configuration';
import { length } from '@azure-tools/linq';

export type PipelinePlugin = (config: ConfigurationView, input: DataSource, sink: DataSink) => Promise<DataSource>;

/** @internal */
export function createPerFilePlugin(processorBuilder: (config: ConfigurationView) => Promise<(input: DataHandle, sink: DataSink) => Promise<DataHandle>>): PipelinePlugin {
  return async (config, input, sink) => {
    const processor = await processorBuilder(config);
    const files = await input.Enum();
    const result: Array<DataHandle> = [];
    for (const file of files) {
      const fileIn = await input.ReadStrict(file);

      // only keep/process files that actually have content in them (ie, no empty objects, no {directive:[]} files ).
      const pi = await fileIn.ReadObject<any>();

      if (!(length(pi) === 1 && pi.directive) || length(pi) === 0) {
        const fileOut = await processor(fileIn, sink);
        result.push(fileOut);
      }
    }
    return new QuickDataSource(result, input.pipeState);
  };
}
