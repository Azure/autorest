import { isDefined } from "@autorest/common";
import { DataHandle, DataSink, DataSource, IdentityPathMappings, QuickDataSource } from "@azure-tools/datastore";
import { Model, isReference, Schema } from "@azure-tools/openapi";
import { cloneDeep } from "lodash";
import { AutorestContext } from "../context";
import { PipelinePlugin } from "../pipeline/common";

async function cleanAllOfs(model: Model) {
  const output = cloneDeep(model);
  if (!output.components?.schemas) {
    return output;
  }

  for (const schema of Object.values(output.components?.schemas)) {
    cleanAllOfForSchema(schema);
  }

  return output;
}

function cleanAllOfForSchema(schema: Schema) {
  if (!schema.allOf) {
    return;
  }
  if (!isReference(schema) && schema.allOf.length > 0 && !schema.properties) {
    schema.allOf = schema.allOf
      .map((aSchema) => {
        if (isReference(aSchema) || (aSchema.allOf && aSchema.allOf.length > 0)) {
          return aSchema;
        }
        // otherwise, copy this schema stuff into the schema
        for (const [key, value] of Object.entries(aSchema)) {
          schema[key as any] = value;
        }
        return undefined;
      })
      .filter(isDefined);
  }
}

async function allofCleaner(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.enum()).map(async (x) => input.readStrict(x)));
  const result: DataHandle[] = [];

  for (const input of inputs) {
    const output = await cleanAllOfs(await input.readObject());
    result.push(
      await sink.writeObject("oai3.clean-allof.json", output, input.identity, "openapi-clean-allof", {
        pathMappings: new IdentityPathMappings(input.key),
      }),
    );
  }
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createAllOfCleaner(): PipelinePlugin {
  return allofCleaner;
}
