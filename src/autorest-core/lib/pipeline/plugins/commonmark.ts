import { DataHandle, QuickDataSource } from '@microsoft.azure/datastore';
import { PipelinePlugin } from '../common';
import { ProcessCodeModel } from '../commonmark-documentation';

/* @internal */
export function createCommonmarkProcessorPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const files = await input.Enum();
    const results: Array<DataHandle> = [];
    for (let file of files) {
      const fileIn = await input.ReadStrict(file);
      const fileOut = await ProcessCodeModel(fileIn, sink);
      file = file.substr(file.indexOf('/output/') + '/output/'.length);
      results.push(await sink.Forward('code-model-v1', fileOut));
    }
    return new QuickDataSource(results, input.skip);
  };
}