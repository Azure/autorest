import { QuickDataSource, DataHandle, safeEval } from '@microsoft.azure/datastore';

import { createPerFilePlugin, PipelinePlugin } from '../common';
import { Manipulator } from '../manipulation';
import { Channel } from '../../message';


/* @internal */
export function createTextTransformerPlugin(): PipelinePlugin {
  // create a lightweight text transformer.
  return async (config, input, sink) => {
    // get directives as concrete objects.
    const directives = config.StaticDirectives;

    if (directives.length === 0) {
      return input;
    }
    const result: Array<DataHandle> = [];
    for (const file of await input.Enum()) {
      const inputHandle = await input.Read(file);
      if (inputHandle) {
        const documentId = `/${inputHandle.Description || inputHandle.key}`;
        let contents: string | undefined = undefined;
        let modified = false;

        for (const directive of directives) {
          if (directive.from.length === 0 || directive.from.find(each => each === inputHandle.artifactType || documentId.endsWith(`/${each}`))) {
            // if the file should be processed, run it thru

            if (directive.where.indexOf('$') > -1) {
              // text transforms are always 'where: $'

              for (const transform of directive.transform) {
                // grab the contents (don't extend the cache tho')
                contents = contents || await inputHandle.ReadData();
                config.Message({ Channel: Channel.Debug, Text: `Running directive '${directive.from}/${directive.reason}' on ${inputHandle.key} ` });


                const output = safeEval<string>(`(() => { { ${transform} }; return $; })()`, {
                  $: contents,
                  $doc: inputHandle,
                  $path: [],
                  $documentPath: inputHandle.key,
                  $lib: {
                    debug: (text: string) => config.Message({ Channel: Channel.Debug, Text: text }),
                    verbose: (text: string) => config.Message({ Channel: Channel.Debug, Text: text }),
                    log: (text: string) => console.error(text),
                    config: config
                  }
                })
                if (output != contents) {
                  modified = true;
                  contents = output;
                }
              }
            }
          }
        }
        if (modified) {
          result.push(await sink.WriteData(inputHandle.Description, contents || '', inputHandle.identity, inputHandle.artifactType))
        } else {
          result.push(await sink.Forward(inputHandle.Description, inputHandle));
          // result.push(inputHandle);
        }

      }
    }
    return new QuickDataSource(result, input.skip);
  }
};



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
    const manipulator = new Manipulator(config.GetNestedConfigurationImmediate(...await Promise.all(scopes.map(s => s.ReadObject<any>()))));
    const file = files[files.length - 1];
    const fileIn = await input.ReadStrict(file);
    const fileOut = await manipulator.process(fileIn, sink, isObject, fileIn.Description);
    return new QuickDataSource([await sink.Forward('swagger-document', fileOut)], input.skip);
  };
}
