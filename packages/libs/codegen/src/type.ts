export function isPrimitive(instance: any) {
  switch (typeof instance) {
    case "undefined":
    case "boolean":
    case "number":
    case "string":
    case "symbol":
      return true;
    default:
      return false;
  }
}

export function typeOf(obj: any) {
  if (obj === null) {
    return "null";
  }

  const t = typeof obj;
  if (t === "object") {
    if (Array.isArray(obj)) {
      return "array";
    }
    if (obj instanceof Set) {
      return "set";
    }
    if (obj instanceof Map) {
      return "map";
    }
    if (obj instanceof Date) {
      return "date";
    }
    if (obj instanceof RegExp) {
      return "regexp";
    }
  }
  return t;
}
