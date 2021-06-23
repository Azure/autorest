import { PipelinePlugin } from "../../pipeline/common";
import { Channel } from "../../message";
import { DataHandle, DataSink, DataSource, QuickDataSource } from "@azure-tools/datastore";
import { crawlReferences } from "../ref-crawling";
import { AutorestContext } from "../../context";
import { checkSyntaxFromData } from "./common";

export async function LoadLiterateSwaggers(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUris: Array<string>,
  sink: DataSink,
): Promise<Array<DataHandle>> {
  const rawSwaggers: Array<DataHandle> = [];
  for (const inputFileUri of inputFileUris) {
    const pluginInput = await LoadLiterateSwagger(config, inputScope, inputFileUri, sink);
    if (pluginInput) {
      rawSwaggers.push(pluginInput);
    }
  }
  return rawSwaggers;
}

export async function LoadLiterateSwagger(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUri: string,
  sink: DataSink,
): Promise<DataHandle | null> {
  const data = await inputScope.readStrict(inputFileUri);
  await checkSyntaxFromData(inputFileUri, data, config);
  // check OpenAPI version
  if ((await data.readObject<any>()).swagger !== "2.0") {
    return null;
    // TODO: Should we throw or send an error message?
  }
  config.Message({ Channel: Channel.Verbose, Text: `Reading OpenAPI 2.0 file ${inputFileUri}` });

  return sink.writeData(data.description, await data.readData(), [inputFileUri], "swagger-document", [], [data]);
}

export function createSwaggerLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.config.inputFileUris;
    const swaggers = await LoadLiterateSwaggers(config, input, inputs, sink);

    const foundAllFiles = swaggers.length !== inputs.length;
    let result: DataHandle[] = [];
    if (swaggers.length === inputs.length) {
      result = await crawlReferences(config, input, swaggers, sink);
    }

    return new QuickDataSource(result, { skipping: foundAllFiles });
  };
}
