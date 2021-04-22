import { PipelinePlugin } from "../../pipeline/common";
import { AutorestContext } from "../../context";
import { DataSource, DataSink, DataHandle, QuickDataSource } from "@azure-tools/datastore";
import { uniqBy } from "lodash";

/**
 * Add the given suffix to the given filename before the file extension.
 * @param name DataHandle name.
 * @param suffix Suffix counter to add.
 * @returns name with the suffix added.
 *
 * @example insertIndexSuffix("foo.json", 2) === "foo-2.json"
 */
function insertIndexSuffix(name: string, suffix: number): string {
  let p = name.lastIndexOf(".");
  p = p === -1 ? name.length : p;
  return `${name.substring(0, p)}-${suffix}${name.substring(p)}`;
}

async function resetIdentity(context: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map((x) => input.ReadStrict(x)));
  const numberEachFile = inputs.length > 1 && uniqBy(inputs, (each) => each.Description);
  const result = await Promise.all(
    inputs.map(async (input, index) => {
      let name = `${context.config.name || input.Description}`;
      if (numberEachFile) {
        name = insertIndexSuffix(name, index);
      }
      return await sink.WriteData(name, await input.ReadData(), input.identity, context.config.to);
    }),
  );
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createIdentityResetPlugin(): PipelinePlugin {
  return resetIdentity;
}
