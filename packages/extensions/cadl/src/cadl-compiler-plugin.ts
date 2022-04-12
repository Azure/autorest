import { fileURLToPath } from "url";
import { AutorestExtensionHost, Channel } from "@autorest/extension-base";
import { getSourceLocation } from "@cadl-lang/compiler";
import { compileCadl } from "./cadl-compiler.js";

export async function setupCadlCompilerPlugin(host: AutorestExtensionHost) {
  const inputFiles = await host.getValue<string[]>("inputFileUris");
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const entrypoint = inputFiles![0];
  const result = await compileCadl(host.logger, fileURLToPath(entrypoint));

  if ("diagnostics" in result) {
    for (const diagnostic of result.diagnostics) {
      const location = typeof diagnostic.target === "symbol" ? undefined : getSourceLocation(diagnostic.target);
      host.message({
        Channel: Channel.Error,
        Text: diagnostic.message,
        Source:
          location !== undefined
            ? [
                {
                  document: `file:///${location.file.path.replace(/\\/g, "/")}`,
                  Position: indexToPosition(location.file.text, location.pos ?? 1),
                },
              ]
            : undefined,
      });
    }

    throw new Error("Cadl Compiler errored.");
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
