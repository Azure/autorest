import { DataHandle, Mapping } from "@azure-tools/datastore";
import { getFromJsonPointer, serializeJsonPointer } from "@azure-tools/json";
import { Oai2ToOai3 } from "../converter";
import { OpenAPI2Document } from "../oai2";
import { loadInputFiles } from "./utils";

export interface OaiToOai3FileInput {
  name: string;
  schema: OpenAPI2Document;
}

export interface OaiToOai3FileOutput {
  name: string;
  result: any; // OAI3 type?
  mappings: Mapping[];
}

export const convertOai2ToOai3Files = async (inputFiles: DataHandle[]): Promise<OaiToOai3FileOutput[]> => {
  const files = await loadInputFiles(inputFiles);
  const map = new Map<string, OaiToOai3FileInput>();
  for (const file of files) {
    map.set(file.name, file);
  }
  return convertOai2ToOai3(map);
};

export const convertOai2ToOai3 = async (inputs: Map<string, OaiToOai3FileInput>): Promise<OaiToOai3FileOutput[]> => {
  const resolvingFiles = new Set<string>();
  const completedFiles = new Map<string, OaiToOai3FileOutput>();

  const resolveReference: ResolveReferenceFn = async (
    targetfile: string,
    refPath: string,
  ): Promise<any | undefined> => {
    const file = inputs.get(targetfile);
    if (file === undefined) {
      throw new Error(`Ref file ${targetfile} doesn't exists.`);
    }

    return getFromJsonPointer(file.schema, refPath);
  };

  const computeFile = async (input: OaiToOai3FileInput) => {
    if (resolvingFiles.has(input.name)) {
      // Todo better circular dep findings
      throw new Error(`Circular dependency with file ${input.name}`);
    }
    resolvingFiles.add(input.name);

    const { result, mappings } = await convertOai2ToOai3Schema(input, resolveReference);
    completedFiles.set(input.name, {
      result,
      name: input.name,
      mappings,
    });
    console.log(
      "DONe",
      mappings.map((x: any) => {
        return `${serializeJsonPointer(x.original.path)} => ${serializeJsonPointer(x.generated.path)}`;
      }),
    );
    return { result, mappings };
  };

  for (const input of inputs.values()) {
    await computeFile(input);
  }
  return [...completedFiles.values()];
};

/**
 * Callback to resolve a reference.
 */
export type AddMappingFn = (oldRef: string, newRef: string, referencedEl: any) => void;
export type ResolveReferenceFn = (targetfile: string, reference: string) => Promise<any | undefined>;

export const convertOai2ToOai3Schema = async (
  { name, schema }: OaiToOai3FileInput,
  resolveReference: ResolveReferenceFn,
): Promise<Oai2ToOai3Result> => {
  const converter = new Oai2ToOai3(name, schema, resolveReference);
  await converter.convert();
  return { result: converter.generated, mappings: converter.mappings };
};

export interface Oai2ToOai3Result {
  result: any;
  mappings: Mapping[];
}
