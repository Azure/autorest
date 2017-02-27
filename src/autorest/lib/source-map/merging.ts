/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";
import * as yaml from "../parsing/yaml";
import * as yamlast from "../parsing/yamlAst";
import { Mappings } from "./sourceMap";
import { DataHandleRead, DataHandleWrite } from "../data-store/dataStore";

// TODO: may want ASTy merge! (keeping circular structure and such?)
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
      // // sequence nodes
      // const result = a.slice();
      // for (const belem of b) {
      //     if (a.indexOf(belem) === -1) {
      //         result.push(belem);
      //     }
      // }
      // return result;
      throw new Error("No support for mergin arrays"); // requires remapping source, so no more identitySourceMapping!
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

export function merge<T, U>(a: T, b: U): T & U {
  return mergeInternal(a, b, ["$"]);
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

export function* identitySourceMappings(files: { [fileName: string]: string }): Mappings {
  for (const fileName in files) {
    yield* identitySourceMapping(fileName, files[fileName]);
  }
}

export async function mergeYamls(yamlInputHandles: DataHandleRead[], yamlOutputHandle: DataHandleWrite): Promise<DataHandleRead> {
  let resultObject: any = {};
  const rawYamls: { [key: string]: string } = {};
  for (const yamlInputHandle of yamlInputHandles) {
    const rawYaml = await yamlInputHandle.readData();
    resultObject = merge(resultObject, yaml.parse(rawYaml));
    rawYamls[yamlInputHandle.key] = rawYaml;
  }

  const resultObjectRaw = yaml.stringify(resultObject);
  const mappings = identitySourceMappings(rawYamls);

  return await yamlOutputHandle.writeData(resultObjectRaw, mappings, yamlInputHandles);
}