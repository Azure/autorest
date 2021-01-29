import { DataHandle, get } from "@azure-tools/datastore";
import { Oai2ToOai3 } from "../converter";
import { OpenAPI2Document } from "../oai2";
import { loadInputFiles } from "./utils";

export interface OaiToOai3FileInput {
  name: string;
  schema: OpenAPI2Document; // OAI2 type?
}

export interface OaiToOai3FileOutput {
  name: string;
  result: any; // OAI2 type?
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

    return get(file.schema, refPath);
  };

  const computeFile = async (input: OaiToOai3FileInput) => {
    if (resolvingFiles.has(input.name)) {
      // Todo better circular dep findings
      throw new Error(`Circular dependency with file ${input.name}`);
    }
    resolvingFiles.add(input.name);

    const result = await convertOai2ToOai3Schema(input, resolveReference);
    completedFiles.set(input.name, {
      result,
      name: input.name,
    });
    return result;
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
): Promise<any> => {
  const converter = new Oai2ToOai3(name, schema, resolveReference);
  await converter.convert();
  return converter.generated;
};
