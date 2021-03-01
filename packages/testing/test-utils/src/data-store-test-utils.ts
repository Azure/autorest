import { DataHandle, LineIndices } from "@azure-tools/datastore";
import { Lazy } from "@azure-tools/tasks";

export function createDataHandle(content: string): DataHandle {
  const name = "test-generated";
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
