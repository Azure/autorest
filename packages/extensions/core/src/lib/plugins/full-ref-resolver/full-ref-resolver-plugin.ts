import { IAutorestLogger, PluginUserError } from "@autorest/common";
import { DataHandle, DataSource, IdentityPathMappings, QuickDataSource } from "@azure-tools/datastore";
import { InvalidJsonPointer } from "@azure-tools/json";
import { parseJsonRef } from "@azure-tools/jsonschema";
import { createOpenAPIWorkspace, Discriminator, OpenAPIWorkspace } from "@azure-tools/openapi";
import { resolveUri } from "@azure-tools/uri";
import { PipelinePlugin } from "../../pipeline/common";

/**
 * Plugin expanding all the $ref to their absolute path.
 */
export function createFullRefResolverPlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    const files = await input.enum();
    const dataHandles = await Promise.all(files.map((x) => input.readStrict(x)));
    const specs: Record<string, { spec: any; dataHandle: DataHandle }> = Object.fromEntries(
      await Promise.all(
        dataHandles.map(async (dataHandle) => {
          const uri = resolveUri(dataHandle.originalDirectory, dataHandle.identity[0]);
          return [
            uri,
            {
              dataHandle,
              spec: await dataHandle.readObject(),
            },
          ];
        }),
      ),
    );

    const options: RefProcessorOptions = {
      includeXmsExamplesOriginalFileLocation: context.config["include-x-ms-examples-original-file"],
    };
    if (
      !(await resolveRefs(context.logger, context.DataStore.getReadThroughScope(context.fileSystem), specs, options))
    ) {
      throw new PluginUserError(context.pluginName ?? "");
    }

    const results = await Promise.all(
      dataHandles.map(async (dataHandle) => {
        const uri = resolveUri(dataHandle.originalDirectory, dataHandle.identity[0]);
        return sink.writeObject(dataHandle.description, specs[uri].spec, dataHandle.identity, dataHandle.artifactType, {
          pathMappings: new IdentityPathMappings(dataHandle.key),
        });
      }),
    );

    return new QuickDataSource(results);
  };
}

async function resolveRefs(
  logger: IAutorestLogger,
  dataSource: DataSource,
  specs: Record<string, { dataHandle: DataHandle; spec: any }>,
  options: RefProcessorOptions,
) {
  const workspace = createOpenAPIWorkspace({
    specs: Object.fromEntries(Object.entries(specs).map(([k, { spec }]) => [k, spec])),
  });
  let success = true;
  for (const [uri, { dataHandle, spec }] of Object.entries(specs)) {
    if (!(await crawlRefs(logger, dataSource, dataHandle, uri, spec, workspace, options))) {
      success = false;
    }
  }
  return success;
}

async function crawlRefs(
  logger: IAutorestLogger,
  dataSource: DataSource,
  dataHandle: DataHandle,
  originalFileLocation: string,
  spec: any,
  workspace: OpenAPIWorkspace<any>,
  options: RefProcessorOptions,
) {
  const promises: Promise<void>[] = [];
  function visit(obj: any, pointer: string[]) {
    function resolveNewRef(value: string): string {
      const { file, path } = parseJsonRef(value);
      const newRefFileName = resolveUri(originalFileLocation, file ?? "");

      const newReference = path ? `${newRefFileName}#${path}` : newRefFileName;

      if (!checkReferenceIsValid(workspace, newRefFileName, path)) {
        success = false;
        logger.trackError({
          code: "InvalidRef",
          message: `Ref '${value}' is not referencing a valid location. ${pointer}`,
          source: [{ document: dataHandle.key, position: { path: pointer } }],
        });
      }
      return newReference;
    }

    let success = true;
    for (const [key, value] of Object.entries(obj)) {
      // We don't want to navigate the examples.
      if (key === "x-ms-examples") {
        promises.push(
          (async () => {
            const examples = await loadXmsExamples(dataSource, originalFileLocation, value as any, options);
            if (examples) {
              obj[key] = examples;
            }
          })(),
        );
        continue;
      }
      if (key === "discriminator" && isDiscriminatorWithMapping(value)) {
        for (const [key, mappedRef] of Object.entries(value.mapping)) {
          value.mapping[key] = resolveNewRef(mappedRef);
        }
      } else if (key === "x-ms-long-running-operation-options" && isLroOptionsWithFinalStateSchema(value)) {
        // Update ref in x-ms-long-running-operation-options.final-state-schema
        value["final-state-schema"] = resolveNewRef(value["final-state-schema"]);
      } else if (key === "$ref" && typeof value === "string") {
        obj[key] = resolveNewRef(value);
      } else if (Array.isArray(value)) {
        if (!visit(value, [...pointer, key])) {
          success = false;
        }
      } else if (value && typeof value === "object") {
        if (!visit(value, [...pointer, key])) {
          success = false;
        }
      }
    }
    return success;
  }

  const result = visit(spec, []);
  await Promise.all(promises);
  return result;
}

function isDiscriminatorWithMapping(value: unknown): value is Discriminator & { mapping: Record<string, string> } {
  return (
    typeof value === "object" &&
    value != null &&
    "mapping" in value &&
    typeof value.mapping === "object" &&
    value.mapping !== null
  );
}

function isLroOptionsWithFinalStateSchema(value: unknown): value is { "final-state-schema": string } {
  return (typeof value === "object" && value != null && "final-state-schema" in value) as boolean;
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

interface RefProcessorOptions {
  includeXmsExamplesOriginalFileLocation?: boolean;
}

async function loadXmsExamples(
  dataSoure: DataSource,
  originalFileLocation: string,
  examples: Record<string, any>,
  options: RefProcessorOptions,
) {
  const xmsExamples: any = {};

  for (const [key, value] of Object.entries(examples)) {
    if (value.$ref) {
      try {
        const { file } = parseJsonRef(value.$ref);

        const refUri = resolveUri(originalFileLocation, file ?? "");
        const handle = await dataSoure.readStrict(refUri);
        const exampleData = await handle.readObject<any>();
        xmsExamples[key] = options.includeXmsExamplesOriginalFileLocation
          ? { ...exampleData, "x-ms-original-file": refUri }
          : exampleData;
      } catch (e) {
        // skip examples that are not nice to us.
      }
    } else {
      // copy whatever was there I guess.
      xmsExamples[key] = value;
    }
  }

  if (Object.keys(xmsExamples).length > 0) {
    return xmsExamples;
  } else {
    return undefined;
  }
}
