import { DataHandle, DataSink, DataSource, QuickDataSource, visit } from "@azure-tools/datastore";
import { cloneDeep } from "lodash";
import { AutorestContext } from "../../../configuration";
import { PipelinePlugin } from "../../common";

/**
 * Compute the new filemap names.
 * @param dataHandles List of files.
 * @returns Map of the old file name to the new file name.
 */
function resolveNewIdentity(dataHandles: DataHandle[]): Map<string, string> {
  const map = new Map<string, string>();

  for (const data of dataHandles) {
    const filename = data.Description;
    map.set(data.Description, filename.replace(/[:/]/g, "-"));
  }

  return map;
}

async function normalizeIdentity(context: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map((x) => input.ReadStrict(x)));
  const identityMap = resolveNewIdentity(inputs);

  const results = await Promise.all(
    inputs.map(async (input) => {
      const data = cloneDeep(await input.ReadObject());
      const newName = identityMap.get(input.Description);
      if (!newName) {
        throw new Error(`Unexpected error. Couldn't find mapping for data handle ${input.Description}`);
      }
      updateRefs(data, identityMap);

      return await sink.WriteData(newName, JSON.stringify(data, null, 2), input.identity, context.config.to);
    }),
  );

  return new QuickDataSource(results, input.pipeState);
}

/**
 * Update references in content using the given fileMap.
 * @param node Node to recursively check
 * @param fileMap Mapping of the file old name => new name.
 */
function updateRefs(node: any, fileMap: Map<string, string>) {
  for (const { value } of visit(node)) {
    if (value && typeof value === "object") {
      const ref = value.$ref;
      if (ref) {
        // see if this object has a $ref
        const [file, path] = ref.split("#");
        const newFile = fileMap.get(file);
        if (newFile) {
          value.$ref = `${newFile}#${path}`;
        }
      }
      // now, recurse into this object
      updateRefs(value, fileMap);
    }
  }
}

export function createNormalizeIdentityPlugin(): PipelinePlugin {
  return normalizeIdentity;
}
