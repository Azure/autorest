/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";

export type JsonPathComponent = jsonpath.PathComponent;
export type JsonPath = JsonPathComponent[];

export function parse(jsonPath: string): JsonPath {
  return jsonpath.parse(jsonPath).map(part => part.expression.value).slice(1);
}

export function stringify(jsonPath: JsonPath): string {
  return jsonpath.stringify(["$" as JsonPathComponent].concat(jsonPath));
}

export function paths<T>(obj: T, jsonQuery: string): JsonPath[] {
  return jsonpath.paths(obj, jsonQuery).map(x => x.slice(1));
}

export function nodes<T>(obj: T, jsonQuery: string): { path: JsonPath, value: any }[] {
  return jsonpath.nodes(obj, jsonQuery).map(x => { return { path: x.path.slice(1), value: x.value }; });
}

export function IsPrefix(prefix: JsonPath, path: JsonPath): boolean {
  return prefix.length <= path.length && path.slice(0, prefix.length).every((pc, i) => pc === prefix[i]);
}

export function matches(jsonQuery: string, jsonPath: JsonPath): boolean {
  // build dummy object from `jsonPath`
  const leafNode = "leaf";
  let obj = leafNode;
  for (const jsonPathComponent of jsonPath.reverse()) {
    obj = typeof jsonPathComponent === "number"
      ? (() => { const result = Array.apply(null, Array(jsonPathComponent + 1)); result[jsonPathComponent] = obj; return result; })()
      : (() => { const result: any = {}; result[jsonPathComponent] = obj; return result; })();
  }

  // check that `jsonQuery` on that object returns the `leafNode`
  return nodes(obj, jsonQuery).some(res => res.value === leafNode);
}