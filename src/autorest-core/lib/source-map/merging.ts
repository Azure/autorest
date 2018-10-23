/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { pushAll } from '../ref/array';
import { IndexToPosition } from "@microsoft.azure/datastore";
import { ConfigurationView } from "../configuration";
import { Channel } from "../message";
import { JsonPath, stringify } from "@microsoft.azure/datastore";
import * as yaml from '@microsoft.azure/datastore';
import { Mapping } from "@microsoft.azure/datastore";
import { DataHandle, DataSink } from "@microsoft.azure/datastore";
import { ResolvePath } from '@microsoft.azure/datastore';
import { isArray } from 'util';

// // TODO: may want ASTy merge! (supporting circular structure and such?)
function Merge(a: any, b: any, path: JsonPath = []): any {
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
      keys = keys.filter((v, i) => { const idx = keys.indexOf(v); return idx === -1 || idx >= i; }); // distinct

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
        result[key] = Merge(aMember, bMember, subpath);
      }
      return result;
    }
  }

  throw new Error(`'${stringify(path)}' has incompatible values (${yaml.Stringify(a)}, ${yaml.Stringify(b)}).`);
}

export function ShallowCopy(input: any, ...filter: Array<string>): any {
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
  switch (typeof (value)) {
    case 'undefined':
      return "undefined";
    case "boolean":
    case "number":
      return value;
    case "object":
      if (value === null) {
        return "null";
      }
      if (isArray(value) && value.length === 0) {
        return "false";
      }
      return "true";
  }
  return `'${value}'`;

}
// Note: I am not convinced this works precisely as it should
// but it works well enough for my needs right now
// I will revisit it later.
const macroRegEx = () => /\$\(([a-zA-Z0-9_-]*)\)/ig
export function resolveRValue(value: any, propertyName: string, higherPriority: any, lowerPriority: any, jsAware: number = 0): any {
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

            // return `'${resolve(match[0], match[1])}'`;
          }
          return resolve(match[0], match[1]);
        }
        // it looks like we should do a string replace.
        return value.replace(macroRegEx(), resolve)
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

export function MergeOverwriteOrAppend(higherPriority: any, lowerPriority: any, concatListPathFilter: (path: JsonPath) => boolean = _ => false, path: JsonPath = []): any {
  if (higherPriority === null || lowerPriority === null) {
    return null; // TODO: overthink, we could use this to force mute something even if it's "concat" mode...
  }

  // scalars/arrays involved
  if (typeof higherPriority !== "object" || higherPriority instanceof Array ||
    typeof lowerPriority !== "object" || lowerPriority instanceof Array) {
    if (!(higherPriority instanceof Array) && !(lowerPriority instanceof Array) && !concatListPathFilter(path)) {
      return higherPriority;
    }
    return higherPriority instanceof Array
      ? higherPriority.concat(lowerPriority)
      : [higherPriority].concat(lowerPriority);
  }

  // object nodes - iterate all members
  const result: any = {};
  let keys = Object.getOwnPropertyNames(higherPriority).concat(Object.getOwnPropertyNames(lowerPriority));
  keys = keys.filter((v, i) => { const idx = keys.indexOf(v); return idx === -1 || idx >= i; }); // distinct

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
    result[key] = MergeOverwriteOrAppend(aMember, bMember, concatListPathFilter, subpath);
  }
  return result;
}

export function IdentitySourceMapping(sourceYamlFileName: string, sourceYamlAst: yaml.YAMLNode): Array<Mapping> {
  const result = new Array<Mapping>();
  const descendantsWithPath = yaml.Descendants(sourceYamlAst);
  for (const descendantWithPath of descendantsWithPath) {
    const descendantPath = descendantWithPath.path;
    result.push({
      generated: { path: descendantPath },
      original: { path: descendantPath },
      name: JSON.stringify(descendantPath),
      source: sourceYamlFileName
    });
  }
  return result;
}

export async function MergeYamls(config: ConfigurationView, yamlInputHandles: DataHandle[], sink: DataSink, verifyOAI2: boolean = false): Promise<DataHandle> {
  let mergedGraph: any = {};
  const mappings = new Array<Mapping>();
  let cancel = false;
  let failed = false;

  for (const yamlInputHandle of yamlInputHandles) {
    const rawYaml = yamlInputHandle.ReadData();
    const inputGraph: any = yaml.Parse(rawYaml, (message, index) => {
      failed = true;
      if (config) {
        config.Message({
          Channel: Channel.Error,
          Text: message,
          Source: [{ document: yamlInputHandle.key, Position: IndexToPosition(yamlInputHandle, index) }]
        });
      }
    }) || {};

    mergedGraph = Merge(mergedGraph, inputGraph);
    pushAll(mappings, IdentitySourceMapping(yamlInputHandle.key, yamlInputHandle.ReadYamlAst()));

    if (verifyOAI2) {
      // check for non-identical duplicate models and parameters
      if (inputGraph.definitions) {
        for (const model in inputGraph.definitions) {
          const merged = mergedGraph.definitions[model];
          const individual = inputGraph.definitions[model];
          if (!deepCompare(individual, merged)) {
            cancel = true;
            const mergedHandle = await sink.WriteObject("merged YAMLs", mergedGraph, undefined, mappings, yamlInputHandles);
            config.Message({
              Channel: Channel.Error,
              Key: ["Fatal/DuplicateModelCollsion"],
              Text: `Duplicated model name with non-identical definitions`,
              Source: [{ document: mergedHandle.key, Position: ResolvePath(mergedHandle, ['definitions', model]) }]

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
            const mergedHandle = await sink.WriteObject("merged YAMLs", mergedGraph, undefined, mappings, yamlInputHandles);
            config.Message({
              Channel: Channel.Error,
              Key: ["Fatal/DuplicateParameterCollision"],
              Text: `Duplicated global non-identical parameter definitions`,
              Source: [{ document: mergedHandle.key, Position: ResolvePath(mergedHandle, ['parameters', parameter]) }]
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
    config.CancellationTokenSource.cancel();
    throw new Error("Operation Cancelled");
  }

  return sink.WriteObject("merged YAMLs", mergedGraph, undefined, mappings, yamlInputHandles);
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

  for (var p in x) {
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
    if (typeof (x[p]) !== "object") {
      return false;
    }

    // Objects and Arrays must be tested recursively
    if (!deepCompare(x[p], y[p])) {
      return false;
    }
  }

  for (p in y) {
    // allows x[ p ] to be set to undefined
    if (y.hasOwnProperty(p) && !x.hasOwnProperty(p)) {
      return false;
    }
  }
  return true;
}