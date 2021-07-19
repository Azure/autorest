import { DataHandle, getLineIndices } from "@azure-tools/datastore";

/**
 * Create a data handle from some string content.
 * @param content Content of the file
 * @returns DataHandle.
 */
export function createDataHandle(content: string, props: { name?: string } = {}): DataHandle {
  const name = props.name ?? "test-generated";
  const key = name.includes("://") ? name : `mem://${name}`;
  return new DataHandle(
    key,
    {
      status: "loaded",
      name,
      identity: [name],
      artifactType: "",
      cached: content,
      lineIndices: getLineIndices(content),
      sourceMap: undefined,
    },
    false,
  );
}
