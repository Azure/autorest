/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export function NewEmptyObject(): any {
  let keys: PropertyKey[] = [];
  return new Proxy<any>({}, {
    get(target, key) {
      return target[key];
    },
    set(target, key, value) {
      if (keys.indexOf(key) === -1) {
        keys.push(key);
      }
      target[key] = value;
      return true;
    },
    deleteProperty(target, key) {
      if (keys.indexOf(key) !== -1) {
        keys = keys.filter(x => x === key);
      }
      delete target[key];
      return true;
    },
    ownKeys(target) {
      return keys;
    }
  });
}