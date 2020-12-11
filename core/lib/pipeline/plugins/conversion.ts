import { DataHandle, IFileSystem, QuickDataSource } from "@azure-tools/datastore";
import { createPerFilePlugin, PipelinePlugin } from "../common";
import { convertOai2ToOai3Files } from "@azure-tools/oai2-to-oai3";
import { convertOAI2toOAI3 } from "../../openapi/conversion";
import { clone } from "@azure-tools/linq";

/* @internal */
export function createSwaggerToOpenApi3Plugin(fileSystem?: IFileSystem): PipelinePlugin {
  return async (config, input, sink) => {
    const files = await input.Enum();
    const inputs: Array<DataHandle> = [];
    for (const file of files) {
      inputs.push(await input.ReadStrict(file));
    }
    const results = await convertOai2ToOai3Files(inputs);
    const resultHandles: Array<DataHandle> = [];
    for (const { result, name } of results) {
      const input = inputs.find((x) => x.originalFullPath === name);
      const out = await sink.WriteObject("OpenAPI", clone(result), input!.identity);
      resultHandles.push(await sink.Forward(input!.Description, out));
    }
    return new QuickDataSource(resultHandles, input.pipeState);
  };
  // return createPerFilePlugin(async () => async (fileIn, sink) => {
  //   const fileOut = await convertOAI2toOAI3(fileIn, sink, fileSystem);
  //   return sink.Forward(fileIn.Description, fileOut);
  // });
}
