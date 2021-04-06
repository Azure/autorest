/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import jsonpath from "jsonpath";
import { createSandbox } from "@azure-tools/codegen";

const safeEval = createSandbox();

// patch in smart filter expressions
const handlers = (<any>jsonpath).handlers;
handlers.register("subscript-descendant-filter_expression", function (component: any, partial: any, count: any) {
  const src = component.expression.value.slice(1);

  const passable = function (key: any, value: any) {
    try {
      return safeEval(src.replace(/@/g, "$$$$"), { $$: value });
    } catch (e) {
      return false;
    }
  };

  return eval("this").traverse(partial, null, passable, count);
});
handlers.register("subscript-child-filter_expression", function (component: any, partial: any, count: any) {
  const src = component.expression.value.slice(1);

  const passable = function (key: any, value: any) {
    try {
      return safeEval(src.replace(/@/g, "$$$$"), { $$: value });
    } catch (e) {
      return false;
    }
  };

  return eval("this").descend(partial, null, passable, count);
});
// patch end

export type JsonPathComponent = jsonpath.PathComponent;
export type JsonPath = Array<JsonPathComponent>;

export function parse(jsonPath: string): JsonPath {
  return jsonpath
    .parse(jsonPath)
    .map((part) => part.expression.value)
    .slice(1);
}

export function stringify(jsonPath: JsonPath): string {
  return jsonpath.stringify(["$" as JsonPathComponent].concat(jsonPath));
}

export function paths<T>(obj: T, jsonQuery: string): Array<JsonPath> {
  return nodes(obj, jsonQuery).map((x) => x.path);
}

export function nodes<T>(obj: T, jsonQuery: string): Array<{ path: JsonPath; value: any }> {
  // jsonpath only accepts objects
  if (obj instanceof Object) {
    let result = jsonpath.nodes(obj, jsonQuery).map((x) => ({ path: x.path.slice(1), value: x.value }));
    const comp = (a: string, b: string) => (a < b ? -1 : a > b ? 1 : 0);
    result = result.sort((a, b) => comp(JSON.stringify(a.path), JSON.stringify(b.path)));
    result = result.filter((x, i) => i === 0 || JSON.stringify(x.path) !== JSON.stringify(result[i - 1].path));
    return result;
  } else {
    return matches(jsonQuery, []) ? [{ path: [], value: obj }] : [];
  }
}

export function selectNodes<T>(obj: T, jsonQuery: string): Array<{ path: JsonPath; value: any; parent: any }> {
  // jsonpath only accepts objects
  if (obj instanceof Object) {
    const result = new Array<{ path: JsonPath; value: any; parent: any }>();
    const keys = new Set<string>();

    for (const node of jsonpath.nodes(obj, jsonQuery)) {
      const p = jsonpath.stringify(node.path);
      if (!keys.has(p)) {
        keys.add(p);
        result.push({ path: node.path.slice(1), value: node.value, parent: jsonpath.parent(obj, p) });
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
