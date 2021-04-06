import { CompilerHost, createProgram } from "@azure-tools/adl";
import { QuickDataSource } from "@azure-tools/datastore";
import { readdir, readFile, realpath, stat } from "fs/promises";
import { join, resolve } from "path";
import { pathToFileURL } from "url";
import { PipelinePlugin } from "../../common";

export function createAdlHost(): CompilerHost {
  return {
    readFile: (path: string) => readFile(path, "utf-8"),
    readDir: (path: string) => readdir(path, { withFileTypes: true }),
    getCwd: () => process.cwd(),
    getExecutionRoot: () => resolve(process.cwd()),
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

export function createAdlCompilerPlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    // Todo-Tim fail if multiple.
    const entrypoint = context.config.inputFileUris[0];
    const result = await compileAdl(entrypoint);
    console.error("Result", result);
    return new QuickDataSource([]);
  };
}
