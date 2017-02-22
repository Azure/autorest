/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";
import * as yaml from "../parsing/yaml";
import * as yamlast from "../parsing/yamlAst";
import { Mappings } from "./sourceMap";

// TODO: may want ASTy merge! (keeping circular structure and such)
function mergeInternal(a: any, b: any, path: jsonpath.PathComponent[]): any {
  if (a === null || b === null) {
    throw new Error("Argument cannot be null");
  }

  // trivial case
  if (a === b) {
    return a;
  }

  // mapping nodes
  if (typeof a === "object" && typeof b === "object") {
    if (a instanceof Array && b instanceof Array) {
      // sequence nodes
      const result = a.slice();
      for (const belem of b) {
        if (a.indexOf(belem) === -1) {
          result.push(belem);
        }
      }
      return result;
    }
    else {
      // object nodes - iterate all members
      const result: any = {};
      let keys = Object.getOwnPropertyNames(a).concat(Object.getOwnPropertyNames(b)).sort();
      keys = keys.filter((v, i) => i === 0 || v !== keys[i - 1]); // distinct
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
        result[key] = mergeInternal(aMember, bMember, subpath);
      }
      return result;
    }
  }

  throw new Error(`'${jsonpath.stringify(path)}' has incomaptible values (${a}, ${b}).`);
}

export function merge<T, U>(a: T, b: U, path: jsonpath.PathComponent[] = ["$"]): T & U {
  return mergeInternal(a, b, path);
}

export function* identitySourceMapping(sourceYamlFileName: string, sourceYamlFile: string): Mappings {
  const descendantPaths = yamlast.descendantPaths(yamlast.parse(sourceYamlFile));
  for (const descendantPath of descendantPaths) {
    yield {
      generated: { path: descendantPath },
      original: { path: descendantPath },
      name: jsonpath.stringify(descendantPath),
      source: sourceYamlFileName
    };
  }
}

export function* sourceMappings(files: { [fileName: string]: string }): Mappings {
  for (const fileName in files) {
    yield* identitySourceMapping(fileName, files[fileName]);
  }
}

export function mergeWithSourceMappings<T>(files: { [fileName: string]: string }): [T, Mappings] {
  let resultObject: any = {};
  for (const fileName in files) {
    resultObject = merge(resultObject, yaml.parse(files[fileName]));
  }
  return [resultObject, sourceMappings(files)];
}