/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { Enumerable as IEnumerable } from "linq-es2015";
export { Enumerable, Enumerable as IEnumerable, From } from "linq-es2015";

export async function ToArray<T>(iterable: AsyncIterable<T>): Promise<Array<T>> {
  const result = new Array<T>();
  for await (const each of iterable) {
    result.push(each);
  }
  return result;
}