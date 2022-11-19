import { readFile, realpath, stat } from "fs/promises";
import { dirname, resolve } from "path";
import { pathToFileURL } from "url";
import { AutorestExtensionLogger } from "@autorest/extension-base";
import { CompilerHost, Diagnostic } from "@cadl-lang/compiler";
import { resolveModule, ResolveModuleHost } from "./module-resolver.js";
export function createCadlHost(
  logger: AutorestExtensionLogger,
  writeFile: (path: string, content: string) => Promise<void>,
  host: CompilerHost,
): CompilerHost {
  return {
    ...host,
    writeFile,
    logSink: {
      log: (x) => logger.debug(`${x.code ? `${x.code}: ` : ""}${x.message}`),
    },
  };
}

export async function compileCadl(
  logger: AutorestExtensionLogger,
  entrypoint: string,
): Promise<{ compiledFiles: Record<string, string> } | { diagnostics: readonly Diagnostic[] }> {
  const output: Record<string, string> = {};
  const writeFile = async (path: string, content: string) => {
    output[path] = content;
  };

  const baseDir = resolve(dirname(entrypoint));
  try {
    const { compile, NodeHost } = await importCadl(baseDir);
    const program = await compile(createCadlHost(logger, writeFile, NodeHost), entrypoint, {
      emitters: { "@azure-tools/cadl-autorest": {} },
    });
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

export async function importCadl(baseDir: string): Promise<typeof import("@cadl-lang/compiler")> {
  try {
    const host: ResolveModuleHost = {
      realpath,
      readFile: async (path: string) => await readFile(path, "utf-8"),
      stat,
    };
    const resolved = await resolveModule(host, "@cadl-lang/compiler", {
      baseDir,
    });
    return import(pathToFileURL(resolved).toString());
  } catch (err: any) {
    if (err.code === "MODULE_NOT_FOUND") {
      // Resolution from cwd failed: use current package.
      return import("@cadl-lang/compiler");
    } else {
      throw err;
    }
  }
}
