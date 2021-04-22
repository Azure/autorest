// TODO-TIM fix this in extension-base
import { Host } from "@autorest/extension-base";
import { fileURLToPath } from "url";
import { compileAdl } from "./adl-compiler.js";

export async function setupAdlCompilerPlugin(host: Host) {
  const inputFiles = await host.GetValue("inputFileUris");
  console.error("Input files", inputFiles);
  const entrypoint = inputFiles[0];
  const result = await compileAdl(fileURLToPath(entrypoint));
  console.error("Result", result);

  for (const [name, content] of Object.entries(result)) {
    host.WriteFile(name, content, undefined, "swagger-document");
  }
}
