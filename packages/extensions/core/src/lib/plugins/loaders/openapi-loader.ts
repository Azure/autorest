import { IAutorestLogger } from "@autorest/common";
import { DataHandle, DataSink, DataSource, QuickDataSource } from "@azure-tools/datastore";
import { PipelinePlugin } from "../../pipeline/common";
import { checkSyntaxFromData } from "./common";
import { loadAllReferencedFiles } from "./referenced-file-resolver";

interface OpenAPI3Spec {
  openapi?: string;
  info?: object;
  paths?: object;
  components?: { schemas?: object };
}

export async function loadOpenAPIFiles(
  logger: IAutorestLogger,
  inputScope: DataSource,
  inputFileUris: string[],
  sink: DataSink,
): Promise<Array<DataHandle>> {
  const rawOpenApis: DataHandle[] = [];
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await loadOpenAPIFile(logger, inputScope, inputFileUri, sink);
    if (pluginInput) {
      rawOpenApis.push(pluginInput);
    }
  }
  return rawOpenApis;
}

export async function loadOpenAPIFile(
  logger: IAutorestLogger,
  inputScope: DataSource,
  inputFileUri: string,
  sink: DataSink,
): Promise<DataHandle | null> {
  const handle = await inputScope.readStrict(inputFileUri);
  await checkSyntaxFromData(inputFileUri, handle, logger);
  // const data = await ParseLiterateYaml(config, handle, sink);
  if (!isOpenAPI3Spec(await handle.readObject<OpenAPI3Spec>())) {
    return null;
    // TODO: Should we throw or send an error message?
  }
  logger.verbose(`Reading OpenAPI 3.0 file ${inputFileUri}`);
  return sink.writeData(handle.description, await handle.readData(), [inputFileUri], "openapi-document");
}

/**
 * Checks that the object has the property 'openapi' and that property has
 * the string value matching something like "3.*.*".
 */
function isOpenAPI3Spec(specObject: OpenAPI3Spec): boolean {
  const wasOpenApiVersionFound = /^3\.\d+\.\d+$/g.exec(<string>specObject.openapi);
  return wasOpenApiVersionFound ? true : false;
}

export function createOpenApiLoaderPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const inputs = config.config.inputFileUris;
    const openapis = await loadOpenAPIFiles(config, input, inputs, sink);
    let result: DataHandle[] = [];
    if (openapis.length === inputs.length) {
      result = await loadAllReferencedFiles(config, input, openapis, sink);
    }
    return new QuickDataSource(result, { skipping: openapis.length !== inputs.length });
  };
}
