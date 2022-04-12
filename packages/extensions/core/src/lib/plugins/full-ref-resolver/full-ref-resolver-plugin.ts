import { IAutorestLogger, PluginUserError } from "@autorest/common";
import { IdentityPathMappings, QuickDataSource } from "@azure-tools/datastore";
import { InvalidJsonPointer } from "@azure-tools/json";
import { parseJsonRef } from "@azure-tools/jsonschema";
import { createOpenAPIWorkspace, OpenAPIWorkspace } from "@azure-tools/openapi";
import { resolveUri } from "@azure-tools/uri";
import { PipelinePlugin } from "../../pipeline/common";

/**
 * Plugin expanding all the $ref to their absolute path.
 */
export function createFullRefResolverPlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    const files = await input.enum();
    const dataHandles = await Promise.all(files.map((x) => input.readStrict(x)));
    const specs = Object.fromEntries(
      await Promise.all(
        dataHandles.map(async (dataHandle) => {
          const uri = resolveUri(dataHandle.originalDirectory, dataHandle.identity[0]);
          return [uri, await dataHandle.readObject()];
        }),
      ),
    );

    if (!resolveRefs(context.logger, specs)) {
      throw new PluginUserError(context.pluginName ?? "");
    }

    const results = await Promise.all(
      dataHandles.map(async (dataHandle) => {
        const uri = resolveUri(dataHandle.originalDirectory, dataHandle.identity[0]);
        return sink.writeObject(dataHandle.description, specs[uri], dataHandle.identity, dataHandle.artifactType, {
          pathMappings: new IdentityPathMappings(dataHandle.key),
        });
      }),
    );

    return new QuickDataSource(results);
  };
}

function resolveRefs(logger: IAutorestLogger, specs: Record<string, any>) {
  const workspace = createOpenAPIWorkspace({ specs });
  let success = true;
  for (const [uri, spec] of Object.entries(specs)) {
    if (!crawlRefs(logger, uri, spec, workspace, [])) {
      success = false;
    }
  }
  return success;
}

function crawlRefs(
  logger: IAutorestLogger,
  originalFileLocation: string,
  obj: any,
  workspace: OpenAPIWorkspace<any>,
  pointer: string[],
) {
  let success = true;
  for (const [key, value] of Object.entries(obj)) {
    // We don't want to navigate the examples.
    if (key === "x-ms-examples") {
      continue;
    }
    if (key === "$ref" && typeof value === "string") {
      const { file, path } = parseJsonRef(value);
      const newRefFileName = resolveUri(originalFileLocation, file ?? "");

      const newReference = path ? `${newRefFileName}#${path}` : newRefFileName;

      if (!checkReferenceIsValid(workspace, newRefFileName, path)) {
        success = false;
        logger.trackError({
          code: "InvalidRef",
          message: `Ref '${value}' is not referencing a valid location.`,
          source: [{ document: originalFileLocation, position: { path: pointer } }],
        });
      }
      obj[key] = newReference;
    } else if (Array.isArray(value)) {
      if (!crawlRefs(logger, originalFileLocation, value, workspace, [...pointer, key])) {
        success = false;
      }
    } else if (value && typeof value === "object") {
      if (!crawlRefs(logger, originalFileLocation, value, workspace, [...pointer, key])) {
        success = false;
      }
    }
  }
  return success;
}

function checkReferenceIsValid(workspace: OpenAPIWorkspace<any>, file: string, path: string | undefined): boolean {
  try {
    const found = workspace.resolveReference({ file: file, path });
    return found !== undefined;
  } catch (e) {
    if (e instanceof InvalidJsonPointer) {
      return false;
    }
    throw e;
  }
}
