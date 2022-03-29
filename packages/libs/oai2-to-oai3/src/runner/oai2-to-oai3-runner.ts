import { DataHandle, PathMapping } from "@azure-tools/datastore";
import { getFromJsonPointer } from "@azure-tools/json";
import { createOpenAPIWorkspace } from "@azure-tools/openapi";
import { OpenAPI2Document } from "@azure-tools/openapi/v2";
import { ConverterDiagnostic, ConverterLogger, Oai2ToOai3 } from "../converter";
import { loadInputFiles } from "./utils";

export interface OaiToOai3FileInput {
  name: string;
  schema: OpenAPI2Document;
}

export interface OaiToOai3FileOutput {
  name: string;
  result: any; // OAI3 type?
  mappings: PathMapping[];
}

export async function convertOai2ToOai3Files(
  logger: ConverterLogger,
  inputFiles: DataHandle[],
): Promise<OaiToOai3FileOutput[]> {
  const files = await loadInputFiles(inputFiles);
  const map = new Map<string, OaiToOai3FileInput>();
  for (const file of files) {
    map.set(file.name, file);
  }

  const sourceMapping = {};
  for (const input of inputFiles) {
    sourceMapping[input.originalFullPath] = input.key;
  }

  const mapOriginalSpecName = (diag: ConverterDiagnostic): ConverterDiagnostic => {
    return { ...diag, source: diag.source?.map((s) => ({ ...s, document: sourceMapping[s.document] })) };
  };
  const proxyLogger: ConverterLogger = {
    trackWarning: (x) => logger.trackWarning(mapOriginalSpecName(x)),
    trackError: (x) => logger.trackError(mapOriginalSpecName(x)),
  };

  const result = await convertOai2ToOai3(proxyLogger, map);

  return result.map((x) => {
    return {
      ...x,
      mappings: x.mappings.map((m) => {
        return {
          ...m,
          source: sourceMapping[m.source],
        };
      }),
    };
  });
}

export async function convertOai2ToOai3(
  logger: ConverterLogger,
  inputs: Map<string, OaiToOai3FileInput>,
): Promise<OaiToOai3FileOutput[]> {
  const resolvingFiles = new Set<string>();
  const completedFiles = new Map<string, OaiToOai3FileOutput>();

  const workspace = createOpenAPIWorkspace<OpenAPI2Document>({
    specs: new Map([...inputs.entries()].map(([k, v]) => [k, v.schema])),
  });

  const resolveReference: ResolveReferenceFn = async (
    targetfile: string,
    refPath: string,
  ): Promise<any | undefined> => {
    return workspace.resolveReference({ file: targetfile, path: refPath });
  };

  const computeFile = async (input: OaiToOai3FileInput) => {
    if (resolvingFiles.has(input.name)) {
      // Todo better circular dep findings
      throw new Error(`Circular dependency with file ${input.name}`);
    }
    resolvingFiles.add(input.name);
    const { result, mappings } = await convertOai2ToOai3Schema(logger, input, resolveReference);
    completedFiles.set(input.name, {
      result,
      name: input.name,
      mappings,
    });
    return { result, mappings };
  };

  for (const input of inputs.values()) {
    await computeFile(input);
  }
  return [...completedFiles.values()];
}

/**
 * Callback to resolve a reference.
 */
export type AddMappingFn = (oldRef: string, newRef: string, referencedEl: any) => void;
export type ResolveReferenceFn = (targetfile: string, reference: string) => Promise<any | undefined>;

export const convertOai2ToOai3Schema = async (
  logger: ConverterLogger,
  { name, schema }: OaiToOai3FileInput,
  resolveReference: ResolveReferenceFn,
): Promise<Oai2ToOai3Result> => {
  const converter = new Oai2ToOai3(logger, name, schema, resolveReference);
  await converter.convert();
  return { result: converter.generated, mappings: converter.mappings };
};

export interface Oai2ToOai3Result {
  result: any;
  mappings: PathMapping[];
}
