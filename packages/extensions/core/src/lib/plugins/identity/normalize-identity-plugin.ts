import { DataHandle, DataSink, DataSource, QuickDataSource, visit } from "@azure-tools/datastore";
import { parseJsonRef, stringifyJsonRef, updateJsonRefs } from "@azure-tools/jsonschema";
import { cloneDeep } from "lodash";
import { AutorestContext } from "../../context";
import { PipelinePlugin } from "../../pipeline/common";
import { URL } from "url";
import { relative, dirname, basename } from "path";

function resolveRelativeRef(currentFile: string, newRef: string) {
  return relative(dirname(currentFile), newRef).replace(/\\/g, "/");
}

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

  if (dataHandles.length === 1) {
    const name = dataHandles[0].Description;
    return new Map([[name, basename(name)]]);
  }

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
      updateFileRefs(data, newName, identityMap);

      return await sink.WriteData(newName, JSON.stringify(data, null, 2), input.identity, context.config.to);
    }),
  );

  return new QuickDataSource(results, input.pipeState);
}

/**
 * Update references in content using the given fileMap.
 * @param node Node to recursively check
 * @param currentFile Current file path to resolve relative urls.
 * @param fileMap Mapping of the file old name => new name.
 */
function updateFileRefs(node: any, currentFile: string, fileMap: Map<string, string>) {
  updateJsonRefs(node, (ref) => {
    const { file, path } = parseJsonRef(ref);
    const newFile = file && fileMap.get(file);
    if (newFile) {
      return stringifyJsonRef({ file: resolveRelativeRef(currentFile, newFile), path });
    }
    return ref;
  });
}

export function createNormalizeIdentityPlugin(): PipelinePlugin {
  return normalizeIdentity;
}
