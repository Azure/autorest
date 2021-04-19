import { Dictionary, items } from "@azure-tools/linq";
import * as jp from "@azure-tools/json";

export type JsonPointer = string;
export type JsonPointerTokens = Array<string>;
export interface Node {
  value: any;
  key: string;
  pointer: JsonPointer;
  children: Iterable<Node>;
  childIterator: () => Iterable<Node>;
}

export interface NodeT<T, K extends keyof T> {
  value: T[K];
  key: keyof T;
  pointer: JsonPointer;
  children: Iterable<NodeT<T[K], keyof T[K]>>;
  childIterator: () => Iterable<NodeT<T[K], keyof T[K]>>;
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
 * Sets a value on an object
 *
 * @param {Object} obj
 * @param {JsonPointer|JsonPointerTokens} pointer - pointer or tokens to a location
 * @param value
 */
export function set(obj: any, pointer: JsonPointer | JsonPointerTokens, value: any) {
  const refTokens = Array.isArray(pointer) ? pointer : parseJsonPointer(pointer);
  let nextTok: string | number = refTokens[0];

  if (refTokens.length === 0) {
    throw Error("Can not set the root object");
  }

  for (let i = 0; i < refTokens.length - 1; ++i) {
    let tok: string | number = refTokens[i];
    if (tok === "-" && Array.isArray(obj)) {
      tok = obj.length;
    }
    nextTok = refTokens[i + 1];

    if (!(tok in obj)) {
      if (nextTok.match(/^(\d+|-)$/)) {
        obj[tok] = [];
      } else {
        obj[tok] = {};
      }
    }
    obj = obj[tok];
  }
  if (nextTok === "-" && Array.isArray(obj)) {
    nextTok = obj.length;
  }
  obj[nextTok] = value;
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
 * Returns a (pointer -> value) dictionary for an object
 *
 * @param obj
 * @param {function} descend
 * @returns {}
 */
export function toDictionary(obj: any, descend?: (value: any) => boolean) {
  const results = new Dictionary<any>();

  walk(
    obj,
    (value, pointer) => {
      results[pointer] = value;
    },
    descend,
  );
  return results;
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
    for (const { key, value } of items(cur)) {
      refTokens.push(String(key));
      if (descend(value)) {
        next(value);
      } else {
        iterator(value, serializeJsonPointer(refTokens));
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
    for (const { key, value } of items(cur)) {
      refTokens.push(String(key));
      if (iterator(value, serializeJsonPointer(refTokens)) && descend(value)) {
        next(value);
      }
      refTokens.pop();
    }
  };
  next(obj);
}

export function* visit(obj: any, parentReference: JsonPointerTokens = new Array<string>()): Iterable<Node> {
  for (const { key, value } of items(obj)) {
    const reference = [...parentReference, key];
    yield {
      value,
      key,
      pointer: serializeJsonPointer(reference),
      children: visit(value, reference),
      childIterator: () => visit(value, reference),
    };
  }
}

export function* visitT<T, K extends keyof T>(
  obj: T,
  parentReference: JsonPointerTokens = new Array<string>(),
): Iterable<NodeT<T, K>> {
  for (const { key, value } of items(<any>obj)) {
    const reference = [...parentReference, key];
    const v = <T[K]>value;
    yield {
      value: v,
      key,
      pointer: serializeJsonPointer(reference),
      children: visitT(<T[K]>value, reference),
      childIterator: () => visitT(<T[K]>value, reference),
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
