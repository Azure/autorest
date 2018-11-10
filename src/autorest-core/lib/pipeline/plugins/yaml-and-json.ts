import { ConvertJsonx2Yaml, ConvertYaml2Jsonx, QuickDataSource, StringifyAst } from '@microsoft.azure/datastore';
import { createPerFilePlugin, PipelinePlugin } from '../common';
import { Manipulator } from '../manipulation';

/* @internal */
export function createYamlToJsonPlugin(): PipelinePlugin {
  return createPerFilePlugin(async () => async (fileIn, sink) => {
    let ast = fileIn.ReadYamlAst();
    ast = ConvertYaml2Jsonx(ast);
    return sink.WriteData(fileIn.Description, StringifyAst(ast), fileIn.Identity);
  });
}

/* @internal */
export function createJsonToYamlPlugin(): PipelinePlugin {
  return createPerFilePlugin(async () => async (fileIn, sink) => {
    let ast = fileIn.ReadYamlAst();
    ast = ConvertJsonx2Yaml(ast);
    return sink.WriteData(fileIn.Description, StringifyAst(ast), fileIn.Identity);
  });
}