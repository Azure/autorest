import { ConvertJsonx2Yaml, ConvertYaml2Jsonx, StringifyAst } from "@azure-tools/datastore";
import { createPerFilePlugin, PipelinePlugin } from "../pipeline/common";

/* @internal */
export function createYamlToJsonPlugin(): PipelinePlugin {
  return createPerFilePlugin(async () => async (fileIn, sink) => {
    let ast = await fileIn.readYamlAst();
    ast = ConvertYaml2Jsonx(ast);
    return sink.writeData(fileIn.description, StringifyAst(ast), fileIn.identity);
  });
}

/* @internal */
export function createJsonToYamlPlugin(): PipelinePlugin {
  return createPerFilePlugin(async () => async (fileIn, sink) => {
    let ast = await fileIn.readYamlAst();
    ast = ConvertJsonx2Yaml(ast);
    return sink.writeData(fileIn.description, StringifyAst(ast), fileIn.identity);
  });
}
