import { AutorestDiagnostic } from "@autorest/common";
import { DataHandle, IFileSystem, QuickDataSource } from "@azure-tools/datastore";
import { parseJsonPointer } from "@azure-tools/json";
import { ConverterDiagnostic, ConverterLogger, convertOai2ToOai3Files } from "@azure-tools/oai2-to-oai3";
import { cloneDeep } from "lodash";
import { PipelinePlugin } from "../pipeline/common";

/* @internal */
export function createSwaggerToOpenApi3Plugin(fileSystem?: IFileSystem): PipelinePlugin {
  return async (context, input, sink) => {
    const files = await input.enum();
    const inputs: DataHandle[] = [];
    for (const file of files) {
      inputs.push(await input.readStrict(file));
    }

    const logger: ConverterLogger = {
      trackError: (x) => context.trackError(convertDiagnostic(x)),
      trackWarning: (x) => context.trackWarning(convertDiagnostic(x)),
    };
    const results = await convertOai2ToOai3Files(logger, inputs);
    const resultHandles: DataHandle[] = [];
    for (const { result, name, mappings } of results) {
      const input = inputs.find((x) => x.originalFullPath === name);
      if (input === undefined) {
        throw new Error(`Unexpected error while trying to map output of file ${name}. It cannot be found as an input.`);
      }
      const out = await sink.writeObject(input.description, cloneDeep(result), input.identity, undefined, {
        pathMappings: mappings,
      });
      resultHandles.push(await sink.forward(input.description, out));
    }

    return new QuickDataSource(resultHandles, input.pipeState);
  };
}

function convertDiagnostic(diag: ConverterDiagnostic): Omit<AutorestDiagnostic, "level"> {
  return {
    ...diag,
    source: diag.source?.map((x) => {
      return { document: x.document, position: { path: parseJsonPointer(x.path) } };
    }),
  };
}
