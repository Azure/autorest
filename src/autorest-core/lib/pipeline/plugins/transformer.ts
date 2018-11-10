import { QuickDataSource } from '@microsoft.azure/datastore';
import { createPerFilePlugin, PipelinePlugin } from '../common';
import { Manipulator } from '../manipulation';

/* @internal */
export function createTransformerPlugin(): PipelinePlugin {
  return createPerFilePlugin(async config => {
    const isObject = config.GetEntry(<any>'is-object') === false ? false : true;
    const manipulator = new Manipulator(config);
    return async (fileIn, sink) => {
      const fileOut = await manipulator.process(fileIn, sink, isObject, fileIn.Description);
      return sink.Forward(fileIn.Description, fileOut);
    };
  });
}

/* @internal */
export function createImmediateTransformerPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const isObject = config.GetEntry(<any>'is-object') === false ? false : true;
    const files = await input.Enum(); // first all the immediate-configs, then a single swagger-document
    const scopes = await Promise.all(files.slice(0, files.length - 1).map(f => input.ReadStrict(f)));
    const manipulator = new Manipulator(config.GetNestedConfigurationImmediate(...scopes.map(s => s.ReadObject<any>())));
    const file = files[files.length - 1];
    const fileIn = await input.ReadStrict(file);
    const fileOut = await manipulator.process(fileIn, sink, isObject, fileIn.Description);
    return new QuickDataSource([await sink.Forward('swagger-document', fileOut)], input.skip);
  };
}
