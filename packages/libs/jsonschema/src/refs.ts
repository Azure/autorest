/**
 * Represent a json reference.
 */
export interface JsonRef {
  file?: string;
  path?: string;
}

/**
 * Parse a json reference into its file and path.
 * @param ref Json reference string.
 * @returns Parsed json reference
 */
export function parseJsonRef(ref: string): JsonRef {
  const [file, path] = ref.split("#");
  return { file: file === "" ? undefined : file, path };
}

/**
 * Convert a @see {JsonRef} into its string format.
 * @param ref Json reference
 * @returns jsonref string.
 */
export function stringifyJsonRef(ref: JsonRef) {
  const path = ref.path === undefined ? "" : `#${ref.path}`;
  return `${ref.file ?? ""}${path}`;
}
