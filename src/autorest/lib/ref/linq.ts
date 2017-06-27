/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { Enumerable as IEnumerable, From } from "linq-es2015";
export { Enumerable, Enumerable as IEnumerable, From } from "linq-es2015";

export async function FromAsync<T>(TSource: Iterable<T> | IEnumerable<T> | PromiseLike<Iterable<T>> | PromiseLike<IEnumerable<T>> | Promise<Iterable<T>> | Promise<IEnumerable<T>>): Promise<IEnumerable<T>> {
  return From<T>(await TSource);
}
