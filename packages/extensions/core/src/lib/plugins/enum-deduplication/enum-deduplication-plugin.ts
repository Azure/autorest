import { DataHandle, DataSink, DataSource, QuickDataSource } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import { PipelinePlugin } from "../../pipeline/common";
import { EnumDeduplicator } from "./enum-deduplicator";

async function deduplicateEnums(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const deduplicator = new EnumDeduplicator(each);
    result.push(
      await sink.WriteObject(
        "oai3.enum-deduplicated.json",
        await deduplicator.getOutput(),
        each.identity,
        "openapi-document-enum-deduplicated",
        await deduplicator.getSourceMappings(),
      ),
    );
  }
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createEnumDeduplicator(): PipelinePlugin {
  return deduplicateEnums;
}
