import { CompilerHost, createProgram, DiagnosticError } from "@azure-tools/adl";
import { ADLModeler } from "./adl-modeler.js";
import { readdir, readFile, realpath, stat } from "fs/promises";
import { join, resolve } from "path";
import { fileURLToPath, pathToFileURL } from "url";
import { serialize } from "@azure-tools/codegen";

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
    if ("diagnostics" in e) {
      return { error: e };
    }
    throw e;
  }
}

export async function compileAdlToCodeModel(
  entrypoint: string,
): Promise<{ compiledFiles: Record<string, string> } | { error: DiagnosticError }> {
  const output: Record<string, string> = {};
  const writeFile = async (path: string, content: string) => {};

  try {
    const program = await createProgram(createAdlHost(writeFile), {
      mainFile: entrypoint,
      noEmit: true,
    });
    const modeler = new ADLModeler(program);
    const codeModel = modeler.process();
    return {
      compiledFiles: {
        "code-model-v4-no-tags.yaml": serialize(codeModel),
      },
    };
  } catch (e) {
    if ("diagnostics" in e) {
      return { error: e };
    }
    throw e;
  }
}
