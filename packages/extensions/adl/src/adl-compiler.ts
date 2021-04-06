import { CompilerHost, createProgram } from "@azure-tools/adl";
import { readdir, readFile, realpath, stat } from "fs/promises";
import { join, resolve } from "path";
import { fileURLToPath, pathToFileURL } from "url";

export function createAdlHost(): CompilerHost {
  return {
    readFile: (path: string) => readFile(path, "utf-8"),
    readDir: (path: string) => readdir(path, { withFileTypes: true }),
    getCwd: () => process.cwd(),
    getExecutionRoot: () => resolve(fileURLToPath(import.meta.url), "../../node_modules/@azure-tools/adl"),
    getJsImport: (path: string) => import(pathToFileURL(path).href),
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

export async function compileAdl(entrypoint: string) {
  const program = await createProgram(createAdlHost(), {
    mainFile: entrypoint,
    noEmit: true,
  });
  console.error("Pr", program);
  return [];
}
