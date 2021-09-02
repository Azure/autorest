import { CompilerHost, createProgram, Diagnostic, createSourceFile } from "@cadl-lang/compiler";
import { readFile, realpath, stat } from "fs/promises";
import { join, resolve } from "path";
import { fileURLToPath, pathToFileURL } from "url";

export function createAdlHost(writeFile: (path: string, content: string) => Promise<void>): CompilerHost {
  return {
    readFile: async (path: string) => createSourceFile((await readFile(path, "utf-8")).toString(), path),
    resolveAbsolutePath: (path: string) => resolve(path),
    getExecutionRoot: () => resolve(fileURLToPath(import.meta.url), "../../node_modules/@cadl-lang/compiler"),
    getJsImport: (path: string) => import(pathToFileURL(path).href),
    writeFile,
    getLibDirs() {
      const rootDir = this.getExecutionRoot();
      return [join(rootDir, "lib"), join(rootDir, "dist/lib")];
    },
    stat(path: string) {
      return stat(path);
    },
    realpath(path) {
      return realpath(path);
    },
  };
}

export async function compileAdl(
  entrypoint: string,
): Promise<{ compiledFiles: Record<string, string> } | { diagnostics: readonly Diagnostic[] }> {
  const output: Record<string, string> = {};
  const writeFile = async (path: string, content: string) => {
    output[path] = content;
  };

  try {
    const program = await createProgram(createAdlHost(writeFile), entrypoint);
    if (program.diagnostics.length > 0) {
      return { diagnostics: program.diagnostics };
    }
    return { compiledFiles: output };
  } catch (e) {
    if (typeof e === "object" && e !== null && "diagnostics" in e) {
      return { diagnostics: (e as any).diagnostics };
    }
    throw e;
  }
}
