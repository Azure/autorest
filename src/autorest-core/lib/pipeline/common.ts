/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ConfigurationView } from "../configuration";
import { DataHandle, DataSink, QuickDataSource, DataSource } from "../data-store/data-store";

export type PipelinePlugin = (config: ConfigurationView, input: DataSource, sink: DataSink) => Promise<DataSource>;

export function CreatePerFilePlugin(processorBuilder: (config: ConfigurationView) => Promise<(input: DataHandle, sink: DataSink) => Promise<DataHandle>>): PipelinePlugin {
  return async (config, input, sink) => {
    const processor = await processorBuilder(config);
    const files = await input.Enum();
    const result: DataHandle[] = [];
    for (let file of files) {
      const fileIn = await input.ReadStrict(file);
      const fileOut = await processor(fileIn, sink);
      result.push(fileOut);
    }
    return new QuickDataSource(result);
  };
}