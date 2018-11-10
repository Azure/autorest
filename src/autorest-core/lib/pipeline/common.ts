/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource } from '@microsoft.azure/datastore';
import { ConfigurationView } from '../configuration';

export type PipelinePlugin = (config: ConfigurationView, input: DataSource, sink: DataSink) => Promise<DataSource>;

export function createPerFilePlugin(processorBuilder: (config: ConfigurationView) => Promise<(input: DataHandle, sink: DataSink) => Promise<DataHandle>>): PipelinePlugin {
  return async (config, input, sink) => {
    const processor = await processorBuilder(config);
    const files = await input.Enum();
    const result: Array<DataHandle> = [];
    for (const file of files) {
      const fileIn = await input.ReadStrict(file);
      const fileOut = await processor(fileIn, sink);
      result.push(fileOut);
    }
    return new QuickDataSource(result, input.skip);
  };
}
