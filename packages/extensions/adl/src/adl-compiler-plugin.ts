// TODO-TIM fix this in extension-base
import { Host, startSession } from "@autorest/extension-base";
import { compileAdl } from "./adl-compiler.js";

export async function setupAdlCompilerPlugin(host: Host) {
  const session = await startSession(host);
  const inputFiles = await session.getValue<string[]>("inputFileUris");
  console.error("Input files", inputFiles);
  const entrypoint = inputFiles[0];
  const result = await compileAdl(entrypoint);
  session;
  console.error("Result", result);
  host.WriteFile("swagger-document.json", "{}", undefined, "swagger-document");
}
