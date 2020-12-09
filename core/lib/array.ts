/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// since target.push(...source) is SO prone!
export function pushAll<T>(target: Array<T>, source: Array<T>) {
  for (const x of source) {
    target.push(x);
  }
}
