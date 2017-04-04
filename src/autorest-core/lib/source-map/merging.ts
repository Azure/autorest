import { OutstandingTaskAwaiter } from '../outstanding-task-awaiter';
import { IndexToPosition } from '../parsing/text-utility';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ConfigurationView } from "../autorest-core";
import { From } from "../ref/linq";
import { JsonPath, stringify } from "../ref/jsonpath";
import * as yaml from "../ref/yaml";
import { Mapping, Mappings } from '../ref/source-map';
import { DataHandleRead, DataHandleWrite } from "../data-store/data-store";

// TODO: may want ASTy merge! (keeping circular structure and such?)
function Merge(a: any, b: any, path: JsonPath = []): any {
  if (a === null || b === null) {
    throw new Error(`Argument cannot be null ('${stringify(path)}')`);
  }

  // trivial case
  if (yaml.Stringify(a) === yaml.Stringify(b)) {
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

  throw new Error(`'${stringify(path)}' has incomaptible values (${yaml.Stringify(a)}, ${yaml.Stringify(b)}).`);
}

export function MergeOverwrite(a: any, b: any, concatListPathFilter: (path: JsonPath) => boolean = _ => false, path: JsonPath = []): any {
  if (a === null || b == null) {
    return null; // TODO: overthink, we could use this to force mute something even if it's "concat" mode...
  }

  // scalars/arrays involved
  if (typeof a !== "object" || a instanceof Array ||
    typeof b !== "object" || b instanceof Array) {
    if (!concatListPathFilter(path)) {
      return a;
    }
    return a instanceof Array
      ? a.concat(b)
      : [a].concat(b);
  }

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
    result[key] = MergeOverwrite(aMember, bMember, concatListPathFilter, subpath);
  }
  return result;
}

export function IdentitySourceMapping(sourceYamlFileName: string, sourceYamlAst: yaml.YAMLNode): Mappings {
  const result: Mappings = [];
  const descendantsWithPath = yaml.Descendants(sourceYamlAst);
  for (const descendantWithPath of descendantsWithPath) {
    const descendantPath = descendantWithPath.path;
    result.push({
      generated: { path: descendantPath },
      original: { path: descendantPath },
      name: stringify(descendantPath),
      source: sourceYamlFileName
    });
  }
  return result;
}

export async function MergeYamls(config: ConfigurationView | null, yamlInputHandles: DataHandleRead[], yamlOutputHandle: DataHandleWrite): Promise<DataHandleRead> {
  let resultObject: any = {};
  const mappings: Mappings = [];
  for (const yamlInputHandle of yamlInputHandles) {
    const rawYaml = yamlInputHandle.ReadData();
    resultObject = Merge(resultObject, yaml.Parse(rawYaml, (message, index) => {
      if (config) {
        config.Error.Dispatch({
          Text: message,
          Source: [{ document: yamlInputHandle.key, Position: IndexToPosition(yamlInputHandle, index) }]
        });
      }
    }) || {});
    mappings.push(...IdentitySourceMapping(yamlInputHandle.key, yamlInputHandle.ReadYamlAst()));
  }

  const resultObjectRaw = yaml.Stringify(resultObject);
  return await yamlOutputHandle.WriteData(resultObjectRaw, mappings, yamlInputHandles);
}