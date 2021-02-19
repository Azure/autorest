import { fileURLToPath, URL, Url } from "url";
import fs from "fs";

export function isIterable(target: any): target is Iterable<any> {
  return !!target && typeof target[Symbol.iterator] === "function";
}

/**
 * Takes a configuration value that can be either an array, a single value or empty and returns an array with all values.
 * @param value Value to wrap in an array.
 * @returns Array of all the values.
 */
export function arrayOf<T>(value: T | T[] | undefined): T[] {
  if (value === undefined) {
    return [];
  }

  switch (typeof value) {
    case "string": // Need to do this case as String is iterable.
      return [value];
    case "object":
      if (isIterable(value)) {
        return [...value];
      }
      break;
  }
  return [value];
}
