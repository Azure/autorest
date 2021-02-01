import { DataHandle } from "@azure-tools/datastore";
import { OpenAPI2Document } from "../oai2";
import { OaiToOai3FileInput } from "./oai2-to-oai3-runner";

export const loadInputFiles = async (inputFiles: DataHandle[]): Promise<OaiToOai3FileInput[]> => {
  const inputs: OaiToOai3FileInput[] = [];
  for (const file of inputFiles) {
    const schema = await file.ReadObject<OpenAPI2Document>();
    inputs.push({ name: file.originalFullPath, schema });
  }
  return inputs;
};
