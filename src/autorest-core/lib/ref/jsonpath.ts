import { safeEval } from './safe-eval';
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
  return nodes(obj, jsonQuery).map(x => x.path);
}

export function nodes<T>(obj: T, jsonQuery: string): { path: JsonPath, value: any }[] {
  const parsedQuery = jsonpath.parse(jsonQuery);
  if (parsedQuery.shift().expression.type !== "root") {
    throw new Error(`Unexpected format: '${jsonQuery}' has no root.`);
  }


  let matches = [{ path: <JsonPath>[], value: <any>obj }];
  const step = (expr: string) => {
    const newMatches: any[] = [];
    for (const m of matches) {
      try {
        const result = jsonpath.nodes(m.value, expr);
        newMatches.push(...result.map(x => <any>{ path: m.path.concat(x.path.slice(1)), value: x.value }));
      } catch (e) {
        // query failed => no results
      }
    }
    matches = newMatches;
  }

  for (const queryPart of parsedQuery) {
    const value = queryPart.expression.value;
    switch (queryPart.operation) {
      case "member":
        switch (queryPart.expression.type) {
          case "identifier":
          case "wildcard":
            if (queryPart.scope === "child") {
              step(`$.${value}`);
            } else if (queryPart.scope === "descendant") {
              step(`$..${value}`);
            } else {
              console.log(jsonQuery, queryPart); throw queryPart;
            }
            break;
          default:
            console.log(jsonQuery, queryPart); throw queryPart;
        }
        break;
      case "subscript":
        switch (queryPart.expression.type) {
          case "filter_expression":
            if (queryPart.scope === "child") {
              step(`$[*]`);
            } else if (queryPart.scope === "descendant") {
              step(`$..*`);
            } else {
              console.log(jsonQuery, queryPart); throw queryPart;
            }
            if (!value.startsWith("?")) {
              throw queryPart;
            }
            matches = matches.filter(x => {
              try {
                return safeEval(value.slice(1).replace(/\@/g, "$$$$"), { "$$": x.value, "$": obj });
              } catch (e) {
                // bad filter expression => treat as false
                return false;
              }
            });
            break;
          case "wildcard":
            if (queryPart.scope === "child") {
              step(`$[*]`);
            } else if (queryPart.scope === "descendant") {
              console.log(jsonQuery, queryPart); throw queryPart;
              // step(`$..[*]`);
            } else {
              console.log(jsonQuery, queryPart); throw queryPart;
            }
            break;
          case "string_literal":
            if (queryPart.scope === "child") {
              step(`$[${JSON.stringify(value)}]`);
            } else if (queryPart.scope === "descendant") {
              console.log(jsonQuery, queryPart); throw queryPart;
              //step(`$..[${JSON.stringify(value)}]`);
            } else {
              console.log(jsonQuery, queryPart); throw queryPart;
            }
            break;
          default:
            console.log(jsonQuery, queryPart); throw queryPart;
        }
        break;
      default:
        console.log(jsonQuery, queryPart); throw queryPart;
    }
  }

  return matches;
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
  for (const jsonPathComponent of jsonPath.reverse()) {
    obj = typeof jsonPathComponent === "number"
      ? (() => { const result = Array.apply(null, Array(jsonPathComponent + 1)); result[jsonPathComponent] = obj; return result; })()
      : (() => { const result: any = {}; result[jsonPathComponent] = obj; return result; })();
  }
  return obj;
}

export function matches(jsonQuery: string, jsonPath: JsonPath): boolean {
  // build dummy object from `jsonPath`
  const leafNode = new Object();
  const obj = CreateObject(jsonPath, leafNode);

  // check that `jsonQuery` on that object returns the `leafNode`
  return nodes(obj, jsonQuery).some(res => res.value === leafNode);
}