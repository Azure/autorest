// TODO-TIM fix this in extension-base
import { Channel, Host } from "@autorest/extension-base";
import { fileURLToPath } from "url";
import { compileAdl } from "./adl-compiler.js";

export async function setupAdlCompilerPlugin(host: Host) {
  const inputFiles = await host.GetValue("inputFileUris");
  const entrypoint = inputFiles[0];
  const result = await compileAdl(fileURLToPath(entrypoint));

  if ("error" in result) {
    for (const diagnostic of result.error.diagnostics) {
      host.Message({
        Channel: Channel.Error,
        Text: diagnostic.message,
        Source: [
          {
            document: `file:///${diagnostic.file.path.replace(/\\/g, "/")}`,
            Position: indexToPosition(diagnostic.file.text, diagnostic.pos),
          },
        ],
      });
    }

    throw new Error("ADL Compiler errored.");
  }

  for (const [name, content] of Object.entries(result.compiledFiles)) {
    host.WriteFile(name, content, undefined, "swagger-document");
  }
}

/**
 * Retrieve the position(Line,Column) from the index in the source.
 * @param text Source.
 * @param index Index.
 */
export function indexToPosition(text: string, index: number): { column: number; line: number } {
  let line = 1;
  let column = 0;

  for (let i = 0; i < text.length; i++) {
    if (i === index) {
      break;
    }

    if (text[i] === "\n") {
      line++;
      column = 0;
    } else {
      column++;
    }
  }

  return { line, column: column };
}
