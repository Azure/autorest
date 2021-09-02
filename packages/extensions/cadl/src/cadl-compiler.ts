import { CompilerHost, createProgram, DiagnosticError } from "@cadl-lang/compiler";
import { readdir, readFile, realpath, stat } from "fs/promises";
import { join, resolve } from "path";
import { fileURLToPath, pathToFileURL } from "url";

export function createAdlHost(writeFile: (path: string, content: string) => Promise<void>): CompilerHost {
  return {
    readFile: (path: string) => readFile(path, "utf-8"),
    readDir: (path: string) => readdir(path, { withFileTypes: true }),
    getCwd: () => process.cwd(),
    getExecutionRoot: () => resolve(fileURLToPath(import.meta.url), "../../node_modules/@azure-tools/adl"),
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
): Promise<{ compiledFiles: Record<string, string> } | { error: DiagnosticError }> {
  const output: Record<string, string> = {};
  const writeFile = async (path: string, content: string) => {
    output[path] = content;
  };

  try {
    const program = await createProgram(createAdlHost(writeFile), {
      mainFile: entrypoint,
    });
    return { compiledFiles: output };
  } catch (e) {
    if (typeof e === "object" && e !== null && "diagnostics" in e) {
      return { error: e as DiagnosticError };
    }
    throw e;
  }
}
