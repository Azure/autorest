import { DataHandle } from "@azure-tools/datastore";
import { OpenAPI2Document } from "@azure-tools/openapi/v2";
import { OaiToOai3FileInput } from "./oai2-to-oai3-runner";

export async function loadInputFiles(inputFiles: DataHandle[]): Promise<OaiToOai3FileInput[]> {
  const inputs: OaiToOai3FileInput[] = [];
  for (const file of inputFiles) {
    const schema = await file.readObject<OpenAPI2Document>();
    inputs.push({ name: file.originalFullPath, schema });
  }
  return inputs;
}
