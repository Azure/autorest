/* eslint-disable no-useless-escape */
import {
  AnyObject,
  DataHandle,
  DataSink,
  DataSource,
  Node,
  parseJsonPointer,
  Transformer,
  QuickDataSource,
  JsonPath,
  Source,
} from "@azure-tools/datastore";
import { Model, isReference, Refable, Schema } from "@azure-tools/openapi";

import { AutorestContext } from "../context";
import { PipelinePlugin } from "../pipeline/common";
import { values, length, items } from "@azure-tools/linq";

export class AllOfCleaner {
  constructor(protected originalFile: Source) {}

  public async getOutput(): Promise<Model> {
    const output = await this.originalFile.ReadObject<Model>();
    for (const { key, value: schema } of items(output.components?.schemas)) {
      if (!isReference(schema) && length(schema.allOf) > 0 && !schema.properties) {
        schema.allOf = <Array<Refable<Schema>>>values(schema.allOf)
          .select((aSchema) => {
            if (isReference(aSchema) || length(aSchema.allOf) > 0) {
              return aSchema;
            }
            // otherwise, copy this schema stuff into the schema
            for (const { key, value } of items(aSchema)) {
              schema[key] = value;
            }
            return undefined;
          })
          .where((each) => each != undefined)
          .toArray();
      }
    }

    return output;
  }
}

async function allofCleaner(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];

  for (const each of inputs) {
    const fixer = new AllOfCleaner(each);
    result.push(
      await sink.WriteObject("oai3.clean-allof.json", await fixer.getOutput(), each.identity, "openapi-clean-allof"),
    );
  }
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createAllOfCleaner(): PipelinePlugin {
  return allofCleaner;
}
