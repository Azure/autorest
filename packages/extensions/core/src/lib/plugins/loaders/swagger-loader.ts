import { IAutorestLogger } from "@autorest/common";
import { DataHandle, DataSink, DataSource, QuickDataSource } from "@azure-tools/datastore";
import { PipelinePlugin } from "../../pipeline/common";
import { checkSyntaxFromData } from "./common";
import { loadAllReferencedFiles } from "./referenced-file-resolver";

export async function loadSwaggerFiles(
  logger: IAutorestLogger,
  inputScope: DataSource,
  inputFileUris: Array<string>,
  sink: DataSink,
): Promise<Array<DataHandle>> {
  const rawSwaggers: Array<DataHandle> = [];
  for (const inputFileUri of inputFileUris) {
    const pluginInput = await loadSwaggerFile(logger, inputScope, inputFileUri, sink);
    if (pluginInput) {
      rawSwaggers.push(pluginInput);
    }
  }
  return rawSwaggers;
}

export async function loadSwaggerFile(
  logger: IAutorestLogger,
  inputScope: DataSource,
  inputFileUri: string,
  sink: DataSink,
): Promise<DataHandle | null> {
  const data = await inputScope.readStrict(inputFileUri);
  await checkSyntaxFromData(inputFileUri, data, logger);
  // check OpenAPI version
  if ((await data.readObject<any>()).swagger !== "2.0") {
    return null;
    // TODO: Should we throw or send an error message?
  }
  logger.verbose(`Reading OpenAPI 2.0 file ${inputFileUri}`);

  return sink.writeData(data.description, await data.readData(), [inputFileUri], "swagger-document");
}

export function createSwaggerLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.config.inputFileUris;
    const swaggers = await loadSwaggerFiles(config, input, inputs, sink);

    const foundAllFiles = swaggers.length !== inputs.length;
    let result: DataHandle[] = [];
    if (swaggers.length === inputs.length) {
      result = await loadAllReferencedFiles(config, input, swaggers, sink);
    }

    return new QuickDataSource(result, { skipping: foundAllFiles });
  };
}
