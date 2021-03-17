import { DataHandle, DataSink, DataSource, QuickDataSource, visit } from "@azure-tools/datastore";
import { parseJsonRef, stringifyJsonRef } from "@azure-tools/jsonschema";
import { cloneDeep } from "lodash";
import { AutorestContext } from "../../../configuration";
import { PipelinePlugin } from "../../common";
import { URL } from "url";
import { resolve } from "node:url";

/**
 * Find the common path from all the provided paths.
 * @param paths List of paths to resolve the common parent.
 * @returns common parent path.
 */
function resolveCommonPath(paths: string[]): string {
  const [first, ...parsedPaths] = paths.map((x) => x.split("/"));
  const commonPath: string[] = [];
  for (let i = 0; i < first.length; i++) {
    for (const path of parsedPaths) {
      if (path[i] !== first[i]) {
        return commonPath.join("/");
      }
    }
    commonPath.push(first[i]);
  }
  return commonPath.join("/");
}

function resolveCommonRoot(uris: string[]) {
  let root = "";
  const [first, ...parsedUris] = uris.map((x) => new URL(x));
  for (const uri of parsedUris) {
    if (uri.protocol !== first.protocol) {
      return root;
    }
  }
  root += `${first.protocol}//`;
  for (const uri of parsedUris) {
    if (uri.host !== first.host) {
      return root;
    }
  }
  root += first.host;

  return `${root}${resolveCommonPath([first, ...parsedUris].map((x) => x.pathname))}/`;
}

/**
 * Compute the new filemap names.
 * @param dataHandles List of files.
 * @returns Map of the old file name to the new file name.
 */
function resolveNewIdentity(dataHandles: DataHandle[]): Map<string, string> {
  const map = new Map<string, string>();

  const root = resolveCommonRoot(dataHandles.map((x) => x.Description));
  for (const data of dataHandles) {
    if (!data.Description.startsWith(root)) {
      throw new Error(`Unexpected error: '${data.Description}' does not start with '${root}'`);
    }
    map.set(data.Description, data.Description.substring(root.length));
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
        const { file, path } = parseJsonRef(ref);
        const newFile = file && fileMap.get(file);
        if (newFile) {
          value.$ref = stringifyJsonRef({ file: newFile, path });
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
