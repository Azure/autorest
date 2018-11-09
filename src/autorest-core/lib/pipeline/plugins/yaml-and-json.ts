import { QuickDataSource, ConvertYaml2Jsonx, StringifyAst, ConvertJsonx2Yaml } from '@microsoft.azure/datastore';
import { CreatePerFilePlugin, PipelinePlugin } from '../common';
import { Manipulator } from '../manipulation';

/* @internal */
export function GetPlugin_Yaml2Jsonx(): PipelinePlugin {
  return CreatePerFilePlugin(async () => async (fileIn, sink) => {
    let ast = fileIn.ReadYamlAst();
    ast = ConvertYaml2Jsonx(ast);
    return sink.WriteData(fileIn.Description, StringifyAst(ast), fileIn.Identity);
  });
}

/* @internal */
export function GetPlugin_Jsonx2Yaml(): PipelinePlugin {
  return CreatePerFilePlugin(async () => async (fileIn, sink) => {
    let ast = fileIn.ReadYamlAst();
    ast = ConvertJsonx2Yaml(ast);
    return sink.WriteData(fileIn.Description, StringifyAst(ast), fileIn.Identity);
  });
}