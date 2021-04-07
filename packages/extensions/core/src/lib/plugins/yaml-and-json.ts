import { ConvertJsonx2Yaml, ConvertYaml2Jsonx, StringifyAst } from "@azure-tools/datastore";
import { createPerFilePlugin, PipelinePlugin } from "../pipeline/common";

/* @internal */
export function createYamlToJsonPlugin(): PipelinePlugin {
  return createPerFilePlugin(async () => async (fileIn, sink) => {
    let ast = await fileIn.ReadYamlAst();
    ast = ConvertYaml2Jsonx(ast);
    return sink.WriteData(fileIn.Description, StringifyAst(ast), fileIn.identity);
  });
}

/* @internal */
export function createJsonToYamlPlugin(): PipelinePlugin {
  return createPerFilePlugin(async () => async (fileIn, sink) => {
    let ast = await fileIn.ReadYamlAst();
    ast = ConvertJsonx2Yaml(ast);
    return sink.WriteData(fileIn.Description, StringifyAst(ast), fileIn.identity);
  });
}
