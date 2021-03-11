import { DataHandle, LineIndices } from "@azure-tools/datastore";
import { Lazy } from "@azure-tools/tasks";

/**
 * Create a data handle from some string content.
 * @param content Content of the file
 * @returns DataHandle.
 */
export function createDataHandle(content: string, props: { name?: string } = {}): DataHandle {
  const name = props.name ?? "test-generated";
  return new DataHandle(`mem://${name}`, {
    name,
    identity: [name],
    artifactType: "",
    cached: content,
    metadata: {
      lineIndices: new Lazy<number[]>(() => LineIndices(content)),
    },
  });
}
