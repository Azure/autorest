/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { createSandbox } from "@azure-tools/codegen";
import { JSONPath } from "jsonpath-plus";

export type JsonPath = JsonPathComponent[];
export type JsonPathComponent = string | number;

interface JSONPathExt {
  toPathArray: (path: string) => string[];
  toPathString: (path: JsonPathComponent[]) => string;
}

interface JsonPathResult {
  path: string;
  value: any;
  parent: any;
  parentProperty: string;
  hasArrExpr: boolean;
  pointer: string;
}

// Override the vm used in jsonpath to use our safeEval and ignore errors.
const safeEval = createSandbox();
JSONPath.prototype.vm = {
  runInNewContext: (code: string, context: Record<string, any>) => {
    try {
      return safeEval(code, context);
    } catch (e) {
      // We just ignore javascript errors.
      return false;
    }
  },
};

export function parse(jsonPath: string): JsonPath {
  return (JSONPath as any as JSONPathExt).toPathArray(jsonPath).slice(1);
}

export function paths<T>(obj: T, jsonQuery: string): Array<JsonPath> {
  return nodes(obj, jsonQuery).map((x) => x.path);
}

function run(obj: any, query: string): JsonPathResult[] {
  return JSONPath({ path: query, json: obj as any, resultType: "all" });
}

export function nodes<T>(obj: T, query: string): Array<{ path: JsonPath; value: any }> {
  // jsonpath only accepts objects
  if (obj instanceof Object) {
    const compare = (a: string, b: string) => (a < b ? -1 : a > b ? 1 : 0);
    const result = run(obj, query);
    return result
      .map((x) => ({ path: parse(x.path), value: x.value }))
      .sort((a, b) => compare(JSON.stringify(a.path), JSON.stringify(b.path)))
      .filter((x, i) => i === 0 || JSON.stringify(x.path) !== JSON.stringify(result[i - 1].path));
  } else {
    return matches(query, []) ? [{ path: [], value: obj }] : [];
  }
}

export function selectNodes<T>(obj: T, jsonQuery: string): Array<{ path: JsonPath; value: any; parent: any }> {
  // jsonpath only accepts objects
  if (obj instanceof Object) {
    const result: { path: JsonPath; value: any; parent: any }[] = [];
    const keys = new Set<string>();

    for (const node of run(obj, jsonQuery)) {
      const p = node.path;
      if (!keys.has(p)) {
        keys.add(p);
        result.push({ path: parse(node.path), value: node.value, parent: node.parent });
      }
    }
    return result;
  } else {
    return [];
  }
}

export function IsPrefix(prefix: JsonPath, path: JsonPath): boolean {
  if (prefix.length > path.length) {
    return false;
  }
  for (let i = 0; i < prefix.length; ++i) {
    if (prefix[i] !== path[i]) {
      return false;
    }
  }
  return true;
}

export function CreateObject(jsonPath: JsonPath, leafObject: any): any {
  let obj = leafObject;
  for (const jsonPathComponent of jsonPath.slice().reverse()) {
    obj =
      typeof jsonPathComponent === "number"
        ? (() => {
            // eslint-disable-next-line prefer-spread
            const result = Array.apply(null, Array(jsonPathComponent + 1));
            result[jsonPathComponent] = obj;
            return result;
          })()
        : (() => {
            const result: any = {};
            result[jsonPathComponent] = obj;
            return result;
          })();
  }
  return obj;
}

export function matches(jsonQuery: string, jsonPath: JsonPath): boolean {
  // build dummy object from `jsonPath`
  const leafNode = new Object();
  const obj = CreateObject(jsonPath, leafNode);

  // check that `jsonQuery` on that object returns the `leafNode`
  return nodes(obj, jsonQuery).some((res) => res.value === leafNode);
}
