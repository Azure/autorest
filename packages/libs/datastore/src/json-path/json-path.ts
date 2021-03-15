/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { JSONPath } from "jsonpath-plus";
import { createSandbox } from "@azure-tools/codegen";

export type JsonPathComponent = string | number;

const safeEval = createSandbox();
interface JSONPathExt {
  toPathArray: (path: string) => string[];
  toPathString: (path: JsonPathComponent[]) => string;
}

export interface JsonPathResult {
  path: string;
  value: any;
  parent: any;
  parentProperty: string;
  hasArrExpr: boolean;
  pointer: string;
}

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

// patch in smart filter expressions
// const handlers = (<any>jsonpath).handlers;
// handlers.register("subscript-descendant-filter_expression", function (component: any, partial: any, count: any) {
//   const src = component.expression.value.slice(1);

//   const passable = function (key: any, value: any) {
//     try {
//       return safeEval(src.replace(/@/g, "$$$$"), { $$: value });
//     } catch (e) {
//       return false;
//     }
//   };

//   return eval("this").traverse(partial, null, passable, count);
// });
// handlers.register("subscript-child-filter_expression", function (component: any, partial: any, count: any) {
//   const src = component.expression.value.slice(1);

//   const passable = function (key: any, value: any) {
//     try {
//       return safeEval(src.replace(/@/g, "$$$$"), { $$: value });
//     } catch (e) {
//       return false;
//     }
//   };

//   return eval("this").descend(partial, null, passable, count);
// });
// patch end

export type JsonPath = (string | number)[];

export function parse(jsonPath: string): JsonPath {
  return ((JSONPath as any) as JSONPathExt).toPathArray(jsonPath).slice(1);
}

export function stringify(jsonPath: JsonPath): string {
  return ((JSONPath as any) as JSONPathExt).toPathString(["$", ...jsonPath]);
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

export function parseJsonPointer(jsonPointer: string): JsonPath {
  return jsonPointer
    .split("/")
    .slice(1)
    .map((part) => part.replace(/~1/g, "/").replace(/~0/g, "~"))
    .filter((each) => each !== "");
}
