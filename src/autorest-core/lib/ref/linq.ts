/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/* @internal */ export { Enumerable, Enumerable as IEnumerable, From } from "linq-es2015";

/* @internal */ export function Push<T>(destination: Array<T>, source: any) {
  if (source) {
    if (IsIterable(source)) {
      destination.push(...source);
    } else {
      destination.push(source)
    }
  }
}

/* @internal */ export function IsIterable(target: any) {
  return target && target[Symbol.iterator] && typeof target !== "string";
}