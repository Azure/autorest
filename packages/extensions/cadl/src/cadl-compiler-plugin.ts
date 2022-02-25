import { fileURLToPath } from "url";
import { AutorestExtensionHost, Channel } from "@autorest/extension-base";
import { compileAdl } from "./cadl-compiler.js";

export async function setupAdlCompilerPlugin(host: AutorestExtensionHost) {
  const inputFiles = await host.getValue<string[]>("inputFileUris");
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const entrypoint = inputFiles![0];
  const result = await compileAdl(fileURLToPath(entrypoint));

  if ("diagnostics" in result) {
    for (const diagnostic of result.diagnostics) {
      host.message({
        Channel: Channel.Error,
        Text: diagnostic.message,
        Source:
          diagnostic.file !== undefined
            ? [
                {
                  document: `file:///${diagnostic.file.path.replace(/\\/g, "/")}`,
                  Position: indexToPosition(diagnostic.file.text, diagnostic.pos ?? 1),
                },
              ]
            : undefined,
      });
    }

    throw new Error("ADL Compiler errored.");
  }

  for (const [name, content] of Object.entries(result.compiledFiles)) {
    host.writeFile({ filename: name, content, artifactType: "swagger-document" });
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
