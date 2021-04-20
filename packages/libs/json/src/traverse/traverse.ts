export type WalkStatus = "stop" | "visit-children";

/**
 * Recursively visit all the node in a json object.
 * Visitor should return a @see {WalkStatus} to determine if the object should be visited further.
 * @param obj Object to visit
 * @param visitor Vistor function.
 */
export function walk(obj: unknown, visitor: (value: unknown, path: string[]) => WalkStatus) {
  return walkInternal(obj, [], visitor);
}

function walkInternal(obj: unknown, path: string[], visitor: (value: unknown, path: string[]) => WalkStatus) {
  if (!obj) {
    return undefined;
  }

  if (visitor(obj, path) !== "visit-children") {
    return;
  }

  if (Array.isArray(obj)) {
    for (const [index, item] of obj.entries()) {
      walkInternal(item, [...path, index.toString()], visitor);
    }
  } else if (typeof obj === "object") {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    for (const [key, item] of Object.entries(obj!)) {
      walkInternal(item, [...path, key], visitor);
    }
  }
  return false;
}
