import { PipelinePlugin } from "../../pipeline/common";

import { Channel } from "../../message";
import { parse as ParseLiterateYaml } from "@autorest/common";
import { CloneAst, DataHandle, DataSink, DataSource, QuickDataSource, StringifyAst } from "@azure-tools/datastore";
import { identitySourceMapping } from "@autorest/common";
import { crawlReferences } from "../ref-crawling";
import { AutorestContext } from "../../context";
import { checkSyntaxFromData } from "./common";

interface OpenAPI3Spec {
  openapi?: string;
  info?: object;
  paths?: object;
  components?: { schemas?: object };
}

export async function LoadLiterateOpenAPIs(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUris: Array<string>,
  sink: DataSink,
): Promise<Array<DataHandle>> {
  const rawOpenApis: Array<DataHandle> = [];
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateOpenAPI(config, inputScope, inputFileUri, sink);
    if (pluginInput) {
      rawOpenApis.push(pluginInput);
    }
  }
  return rawOpenApis;
}

export async function LoadLiterateOpenAPI(
  config: AutorestContext,
  inputScope: DataSource,
  inputFileUri: string,
  sink: DataSink,
): Promise<DataHandle | null> {
  const handle = await inputScope.ReadStrict(inputFileUri);
  await checkSyntaxFromData(inputFileUri, handle, config);
  const data = await ParseLiterateYaml(config, handle, sink);
  if (!isOpenAPI3Spec(await data.ReadObject<OpenAPI3Spec>())) {
    return null;
    // TODO: Should we throw or send an error message?
  }
  config.Message({ Channel: Channel.Verbose, Text: `Reading OpenAPI 3.0 file ${inputFileUri}` });

  const ast = CloneAst(await data.ReadYamlAst());
  const mapping = identitySourceMapping(data.key, ast);

  return sink.WriteData(handle.Description, StringifyAst(ast), [inputFileUri], "openapi-document", mapping, [data]);
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
    const openapis = await LoadLiterateOpenAPIs(config, input, inputs, sink);
    let result: Array<DataHandle> = [];
    if (openapis.length === inputs.length) {
      result = await crawlReferences(config, input, openapis, sink);
    }
    return new QuickDataSource(result, { skipping: openapis.length !== inputs.length });
  };
}
