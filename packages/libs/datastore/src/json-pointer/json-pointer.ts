import * as jp from "@azure-tools/json";
import { JsonPointer, JsonPointerTokens } from "@azure-tools/json";

export interface Node<T = any> {
  value: T;
  key: string;
  pointer: JsonPointer;
  children: Iterable<Node<T[keyof T]>>;
  childIterator: () => Iterable<Node<T[keyof T]>>;
}

/**
 * Lookup a json pointer in an object
 *
 * @param {Object} obj - object to work on
 * @param {JsonPointer|JsonPointerTokens} pointer - pointer or tokens to a location
 * @returns {*} - value at location, or will throw if location is not present.
 * @deprecated use @azure-tools/json#getJsonPointer
 */
export function get(obj: any, pointer: JsonPointer | JsonPointerTokens): any {
  return jp.getFromJsonPointer(obj, pointer);
}

/**
 * Removes an attribute
 *
 * @param {Object} obj
 * @param {JsonPointer|JsonPointerTokens} pointer - pointer or tokens to a location
 */
export function remove(obj: any, pointer: JsonPointer | JsonPointerTokens) {
  const refTokens = Array.isArray(pointer) ? pointer : parseJsonPointer(pointer);
  const finalToken = refTokens[refTokens.length - 1];
  if (finalToken === undefined) {
    throw new Error(`Invalid JSON pointer for remove: "${pointer}"`);
  }

  const parent = get(obj, refTokens.slice(0, -1));
  if (Array.isArray(parent)) {
    const index = +finalToken;
    if (finalToken === "" && isNaN(index)) {
      throw new Error(`Invalid array index: "${finalToken}"`);
    }

    Array.prototype.splice.call(parent, index, 1);
  } else {
    delete parent[finalToken];
  }
}

/**
 * Iterates over an object
 * Iterator: function (value, pointer) {}
 *
 * @param obj
 * @param {function} iterator
 * @param {function} descend
 * @deprecated use @azure-tools/json#walk
 */
export function walk(
  obj: any,
  iterator: (value: any, pointer: string) => void,
  descend: (value: any) => boolean = isObjectOrArray,
) {
  const refTokens = new Array<any>();
  /*
    const descendFn = descend || ((value: any) => {
      const type = Object.prototype.toString.call(value);
      return type === '[object Object]' || type === '[object Array]';
    });
  */
  const next = (cur: any) => {
    for (const [key, value] of Object.entries(cur)) {
      refTokens.push(String(key));
      if (descend(value)) {
        next(value);
      } else {
        iterator(value, jp.serializeJsonPointer(refTokens));
      }
      refTokens.pop();
    }
  };
  next(obj);
}

function isObjectOrArray(value: any): boolean {
  return typeof value === "object";
}

/**
 * Iterates over an object -- the visitor can return false to skip
 * Iterator: function (value, pointer) {}
 *
 * @param obj
 * @param {function} iterator
 * @param {function} descend
 */
export function _visit(
  obj: any,
  iterator: (value: any, pointer: string) => boolean,
  descend: (value: any) => boolean = isObjectOrArray,
) {
  const refTokens = new Array<string>();
  const next = (cur: any) => {
    for (const [key, value] of Object.entries(cur)) {
      refTokens.push(String(key));
      if (iterator(value, jp.serializeJsonPointer(refTokens)) && descend(value)) {
        next(value);
      }
      refTokens.pop();
    }
  };
  next(obj);
}

export function* visit(obj: any | undefined, parentReference: JsonPointerTokens = new Array<string>()): Iterable<Node> {
  if (!obj) {
    return;
  }

  for (const [key, value] of Object.entries(obj)) {
    const reference = [...parentReference, key];
    yield {
      value,
      key,
      pointer: jp.serializeJsonPointer(reference),
      children: visit(value, reference),
      childIterator: () => visit(value, reference),
    };
  }
}

/**
 * Tests if an object has a value for a json pointer
 *
 * @param obj
 * @param pointer
 * @returns {boolean}
 */
export function has(obj: any, pointer: JsonPointer | JsonPointerTokens) {
  try {
    get(obj, pointer);
  } catch (e) {
    return false;
  }
  return true;
}

/**
 * Converts a json pointer into a array of reference tokens
 *
 * @param pointer
 * @returns {Array}
 * @deprecated use from @azure-tools/json
 */
export function parseJsonPointer(pointer: string): JsonPointerTokens {
  return jp.parseJsonPointer(pointer);
}

/**
 * Builds a json pointer from a array of reference tokens
 *
 * @param refTokens segment of paths.
 * @returns JsonPointer string.
 * @deprecated use from @azure-tools/json
 */
export function serializeJsonPointer(refTokens: JsonPointerTokens): string {
  return jp.serializeJsonPointer(refTokens);
}
