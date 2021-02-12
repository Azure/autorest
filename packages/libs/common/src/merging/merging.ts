/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable @typescript-eslint/no-use-before-define */
/* eslint-disable no-prototype-builtins */

import {
  DataHandle,
  DataSink,
  IndexToPosition,
  JsonPath,
  Mapping,
  ResolvePath,
  stringify,
  Stringify,
  YAMLNode,
  Descendants,
  Parse,
} from "@azure-tools/datastore";
import { AutorestLogger } from "../logging";

// // TODO: may want ASTy merge! (supporting circular structure and such?)
function merge(a: any, b: any, path: JsonPath = []): any {
  if (a === null || b === null) {
    throw new Error(`Argument cannot be null ('${stringify(path)}')`);
  }

  // trivial case
  if (a === b || JSON.stringify(a) === JSON.stringify(b)) {
    return a;
  }

  // mapping nodes
  if (typeof a === "object" && typeof b === "object") {
    if (a instanceof Array && b instanceof Array) {
      if (a.length === 0) {
        return b;
      }
      if (b.length === 0) {
        return a;
      }
      // both sides gave a sequence, and they are not identical.
      // this is currently not a good thing.
      throw new Error(`'${stringify(path)}' has two arrays that are incompatible (${Stringify(a)}, ${Stringify(b)}).`);
      // // sequence nodes
      // const result = a.slice();
      // for (const belem of b) {
      //     if (a.indexOf(belem) === -1) {
      //         result.push(belem);
      //     }
      // }
      // return result;
    } else {
      // object nodes - iterate all members
      const result: any = {};
      let keys = Object.getOwnPropertyNames(a).concat(Object.getOwnPropertyNames(b));
      keys = keys.filter((v, i) => {
        const idx = keys.indexOf(v);
        return idx === -1 || idx >= i;
      }); // distinct

      for (const key of keys) {
        const subpath = path.concat(key);

        // forward if only present in one of the nodes
        if (a[key] === undefined) {
          result[key] = b[key];
          continue;
        }
        if (b[key] === undefined) {
          result[key] = a[key];
          continue;
        }

        // try merge objects otherwise
        const aMember = a[key];
        const bMember = b[key];
        result[key] = merge(aMember, bMember, subpath);
      }
      return result;
    }
  }

  throw new Error(`'${stringify(path)}' has incompatible values (${Stringify(a)}, ${Stringify(b)}).`);
}

export function shallowCopy(input: any, ...filter: Array<string>): any {
  /* TODO; replace and test with this:
  const copy = { ...input };
  for (const each of filter) {
    if (copy[each]) {
      delete copy[each];
    }
  }
  return copy;
  */

  if (!input) {
    return input;
  }
  const keys = input.Keys ? input.Keys : Object.getOwnPropertyNames(input);

  const result: any = {};
  for (const key of keys) {
    if (filter.indexOf(key) == -1) {
      const value = input[key];
      if (value !== undefined) {
        result[key] = value;
      }
    }
  }
  return result;
}

function toJsValue(value: any) {
  switch (typeof value) {
    case "undefined":
      return "undefined";
    case "boolean":
    case "number":
      return value;
    case "object":
      if (value === null) {
        return "null";
      }
      if (Array.isArray(value) && value.length === 0) {
        return "false";
      }
      return "true";
  }
  return `'${value}'`;
}
// Note: I am not convinced this works precisely as it should
// but it works well enough for my needs right now
// I will revisit it later.
const macroRegEx = () => /\$\(([a-zA-Z0-9_-]*)\)/gi;
export function resolveRValue(
  value: any,
  propertyName: string,
  higherPriority: any,
  lowerPriority: any,
  jsAware = 0,
): any {
  if (value) {
    // resolves the actual macro value.
    const resolve = (macroExpression: string, macroKey: string) => {
      // if the original set has it, use that.
      if (higherPriority && higherPriority[macroKey]) {
        return resolveRValue(higherPriority[macroKey], macroKey, lowerPriority, null, jsAware - 1);
      }

      if (lowerPriority) {
        // check to see if the value is in the overrides set before the key itself.
        const keys = Object.getOwnPropertyNames(lowerPriority);
        const macroKeyLocation = keys.indexOf(macroKey);
        if (macroKeyLocation > -1) {
          if (macroKeyLocation < keys.indexOf(propertyName)) {
            // the macroKey is in the overrides, and it precedes the propertyName itself
            return resolveRValue(lowerPriority[macroKey], macroKey, higherPriority, lowerPriority, jsAware - 1);
          }
        }
      }

      // can't find the macro. maybe later.
      return macroExpression;
    };

    // resolve the macro value for strings
    if (typeof value === "string") {
      const match = macroRegEx().exec(value.trim());
      if (match) {
        if (match[0] === match.input) {
          // the target value should be the result without string twiddling
          if (jsAware > 0) {
            return toJsValue(resolve(match[0], match[1]));
          }
          return resolve(match[0], match[1]);
        }
        // it looks like we should do a string replace.
        return value.replace(macroRegEx(), resolve);
      }
    }

    // resolve macro values for array values
    if (value instanceof Array) {
      const result = new Array<any>();
      for (const each of value) {
        // since we're not naming the parameter,
        // if there isn't a higher priority,
        // we can fall back to a wide-lookup in lowerPriority.
        result.push(resolveRValue(each, "", higherPriority || lowerPriority, null));
      }
      return result;
    }
  }

  if (jsAware > 0) {
    return toJsValue(value);
  }

  return value;
}

export function mergeOverwriteOrAppend(
  higherPriority: any,
  lowerPriority: any,
  concatListPathFilter: (path: JsonPath) => boolean = (_) => false,
  path: JsonPath = [],
): any {
  if (higherPriority === null || lowerPriority === null) {
    return null;
  }

  // scalars/arrays involved
  if (
    typeof higherPriority !== "object" ||
    higherPriority instanceof Array ||
    typeof lowerPriority !== "object" ||
    lowerPriority instanceof Array
  ) {
    if (!(higherPriority instanceof Array) && !(lowerPriority instanceof Array) && !concatListPathFilter(path)) {
      return higherPriority;
    }

    return [...new Set((higherPriority instanceof Array ? higherPriority : [higherPriority]).concat(lowerPriority))];
  }

  // object nodes - iterate all members
  const result: any = {};

  const keys = [
    ...new Set(Object.getOwnPropertyNames(higherPriority).concat(Object.getOwnPropertyNames(lowerPriority))),
  ];
  // keys = keys.filter((v, i) => { const idx = keys.indexOf(v); return idx === -1 || idx >= i; }); // distinct

  for (const key of keys) {
    const subpath = path.concat(key);

    // forward if only present in one of the nodes
    if (higherPriority[key] === undefined) {
      result[key] = resolveRValue(lowerPriority[key], key, higherPriority, lowerPriority);
      continue;
    }
    if (lowerPriority[key] === undefined) {
      result[key] = resolveRValue(higherPriority[key], key, null, higherPriority);
      continue;
    }

    // try merge objects otherwise
    const aMember = resolveRValue(higherPriority[key], key, lowerPriority, higherPriority);
    const bMember = resolveRValue(lowerPriority[key], key, higherPriority, lowerPriority);
    result[key] = mergeOverwriteOrAppend(aMember, bMember, concatListPathFilter, subpath);
  }
  return result;
}

export function identitySourceMapping(sourceYamlFileName: string, sourceYamlAst: YAMLNode): Array<Mapping> {
  const result = new Array<Mapping>();
  const descendantsWithPath = Descendants(sourceYamlAst);
  for (const descendantWithPath of descendantsWithPath) {
    const descendantPath = descendantWithPath.path;
    result.push({
      generated: { path: descendantPath },
      original: { path: descendantPath },
      name: JSON.stringify(descendantPath),
      source: sourceYamlFileName,
    });
  }
  return result;
}

export async function mergeYamls(
  logger: AutorestLogger,
  yamlInputHandles: Array<DataHandle>,
  sink: DataSink,
  verifyOAI2 = false,
): Promise<DataHandle> {
  let mergedGraph: any = {};
  const mappings = new Array<Mapping>();
  let cancel = false;
  let failed = false;

  const newIdentity = new Array<string>();
  for (const each of yamlInputHandles) {
    newIdentity.push(...each.identity);
  }

  for (const yamlInputHandle of yamlInputHandles) {
    const rawYaml = await yamlInputHandle.ReadData();
    const inputGraph: any =
      Parse(rawYaml, (message, index) => {
        failed = true;
        if (logger) {
          logger.trackError({
            code: "yaml_parsing",
            message: message,
            source: [{ document: yamlInputHandle.key, position: IndexToPosition(yamlInputHandle, index) }],
          });
        }
      }) || {};

    mergedGraph = merge(mergedGraph, inputGraph);
    mappings.push(...identitySourceMapping(yamlInputHandle.key, await yamlInputHandle.ReadYamlAst()));

    if (verifyOAI2) {
      // check for non-identical duplicate models and parameters

      if (inputGraph.definitions) {
        for (const model in inputGraph.definitions) {
          const merged = mergedGraph.definitions[model];
          const individual = inputGraph.definitions[model];
          if (!deepCompare(individual, merged)) {
            cancel = true;
            const mergedHandle = await sink.WriteObject(
              "merged YAMLs",
              mergedGraph,
              newIdentity,
              undefined,
              mappings,
              yamlInputHandles,
            );
            logger.trackError({
              code: "Fatal/DuplicateModelCollsion",
              message: "Duplicated model name with non-identical definitions",
              source: [
                { document: mergedHandle.key, position: await ResolvePath(mergedHandle, ["definitions", model]) },
              ],
            });
          }
        }
      }

      if (inputGraph.parameters) {
        for (const parameter in inputGraph.parameters) {
          const merged = mergedGraph.parameters[parameter];
          const individual = inputGraph.parameters[parameter];
          if (!deepCompare(individual, merged)) {
            cancel = true;
            const mergedHandle = await sink.WriteObject(
              "merged YAMLs",
              mergedGraph,
              newIdentity,
              undefined,
              mappings,
              yamlInputHandles,
            );
            logger.trackError({
              code: "Fatal/DuplicateParameterCollision",
              message: "Duplicated global non-identical parameter definitions",
              source: [
                { document: mergedHandle.key, position: await ResolvePath(mergedHandle, ["parameters", parameter]) },
              ],
            });
          }
        }
      }
    }
  }

  if (failed) {
    throw new Error("Syntax errors encountered.");
  }

  if (cancel) {
    throw new Error("Operation Cancelled");
  }

  return sink.WriteObject("merged YAMLs", mergedGraph, newIdentity, undefined, mappings, yamlInputHandles);
}

function deepCompare(x: any, y: any) {
  // if both x and y are null or undefined and exactly the same
  if (x === y) {
    return true;
  }

  // if they are not strictly equal, they both need to be Objects
  if (!(x instanceof Object) || !(y instanceof Object)) {
    return false;
  }

  for (const p in x) {
    // other properties were tested using x.constructor === y.constructor
    if (!x.hasOwnProperty(p)) {
      continue;
    }

    // allows to compare x[ p ] and y[ p ] when set to undefined
    if (!y.hasOwnProperty(p)) {
      return false;
    }

    // if they have the same strict value or identity then they are equal
    if (x[p] === y[p]) {
      continue;
    }

    // Numbers, Strings, Functions, Booleans must be strictly equal
    if (typeof x[p] !== "object") {
      return false;
    }

    // Objects and Arrays must be tested recursively
    if (!deepCompare(x[p], y[p])) {
      return false;
    }
  }

  for (const p in y) {
    // allows x[ p ] to be set to undefined
    if (y.hasOwnProperty(p) && !x.hasOwnProperty(p)) {
      return false;
    }
  }
  return true;
}
