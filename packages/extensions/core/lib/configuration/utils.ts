export function isIterable(target: any): target is Iterable<any> {
  return !!target && typeof target[Symbol.iterator] === "function";
}

export function* valuesOf<T>(value: any): Iterable<T> {
  switch (typeof value) {
    case "string":
      yield <T>(<any>value);
      break;

    case "object":
      if (value) {
        if (isIterable(value)) {
          yield* value;
        } else {
          yield value;
        }
        return;
      }
      break;

    default:
      if (value) {
        yield value;
      }
  }
  /* rewrite
  if (value === undefined) {
    return [];
  }
  if (value instanceof Array) {
    return value;
  }
  return [value];
  */
}

export function arrayOf<T>(value: any): Array<T> {
  if (value === undefined) {
    return [];
  }
  switch (typeof value) {
    case "string":
      return [<T>(<any>value)];
    case "object":
      if (isIterable(value)) {
        return [...value];
      }
      break;
  }
  return [<T>value];
}
