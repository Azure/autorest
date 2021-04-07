import {
  AnyObject,
  DataHandle,
  DataSink,
  DataSource,
  Node,
  parseJsonPointer,
  Processor,
  QuickDataSource,
} from "@azure-tools/datastore";
import { items } from "@azure-tools/linq";
import { AutorestContext } from "../context";
import { PipelinePlugin } from "../pipeline/common";
import { format } from "path";
import { Channel } from "../message";

async function quickCheck(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  for (const each of inputs) {
    const oai = await each.ReadObject<AnyObject>();

    const models = new Map<string, Array<string>>();
    const enums = new Map<string, Array<string>>();
    // check to see if there are models with the same name
    for (const { key, value } of items(oai.components?.schemas)) {
      const schema = <AnyObject>value;
      const name = (<AnyObject>value)["x-ms-metadata"].name.toLowerCase();

      if ((schema.type === "string" || schema.type === undefined) && schema.enum && schema.enum.length > 1) {
        // it's an enum
        if (!enums.has(name)) {
          enums.set(name, []);
        }
        (enums.get(name) || []).push(key);
      }

      if (!schema.type || schema.type === "object") {
        // it's a model
        if (!models.has(name)) {
          models.set(name, []);
        }
        (models.get(name) || []).push(key);
      }
    }
    const failed = false;
    for (const { key, value } of items(models)) {
      if (value.length > 1) {
        //failed = true;
        // console.error(`Model ${key} has multiple implementations: ${value.join(',')}`);
      }
    }
    //    console.error('--------------------------------------------------------------------');
    for (const { key, value } of items(enums)) {
      if (value.length > 1) {
        //failed = true;
        config.Message({
          Text: `Enum ${key} has multiple unmerged implementations: ${value.join(",")}`,
          Channel: Channel.Error,
        });
      }
    }
    if (failed) {
      throw new Error("Detected Collisions.");
    }
  }

  const result: Array<DataHandle> = [];

  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createQuickCheckPlugin(): PipelinePlugin {
  return quickCheck;
}
