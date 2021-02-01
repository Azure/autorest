/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { Dictionary } from "@azure-tools/linq";

export function includeXDash<T>(dictionary: Dictionary<T>) {
  return Object.keys(dictionary).filter((v, i, a) => v.startsWith("x-"));
}
export function excludeXDash<T>(dictionary: Dictionary<T>) {
  return Object.keys(dictionary).filter((v, i, a) => !v.startsWith("x-"));
}
