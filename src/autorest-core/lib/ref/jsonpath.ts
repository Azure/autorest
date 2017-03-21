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

export function paths<T>(obj: T, jsonPath: string): JsonPath[] {
  return jsonpath.paths(obj, jsonPath).map(x => x.slice(1));
}

export function nodes<T>(obj: T, jsonPath: string): { path: JsonPath, value: any }[] {
  return jsonpath.nodes(obj, jsonPath).map(x => { return { path: x.path.slice(1), value: x.value }; });
}

export function IsPrefix(prefix: JsonPath, path: JsonPath): boolean {
  return prefix.length <= path.length && path.slice(0, prefix.length).every((pc, i) => pc === prefix[i]);
}