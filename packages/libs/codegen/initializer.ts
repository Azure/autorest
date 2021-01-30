/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { keys, items } from "@azure-tools/linq";

export type Primitive = string | number | boolean | bigint | symbol | undefined | null;

export type XDeepPartial<T> = DeepPartial<T>;

export type DeepPartial<T> = T extends Primitive | Function | Date
  ? T
  : T extends Map<infer K, infer V>
  ? DeepPartialMap<K, V>
  : T extends Set<infer U>
  ? DeepPartialSet<U>
  :
      | {
          [P in keyof T]?: T[P] extends Array<infer U>
            ? Array<DeepPartial<U>>
            : T[P] extends ReadonlyArray<infer V>
            ? ReadonlyArray<DeepPartial<V>>
            : T[P] extends Primitive
            ? T[P]
            : DeepPartial<T[P]>;
        }
      | T;

export type NDeepPartial<T> = T extends Primitive
  ? T
  : T extends Function
  ? T
  : T extends Date
  ? T
  : T extends Map<infer K, infer V>
  ? DeepPartialMap<K, V>
  : T extends Set<infer U>
  ? DeepPartialSet<U>
  : T extends {}
  ? {
      [P in keyof T]?: T[P] extends string | number | boolean | null | undefined // T[P] extends ReadonlyArray<infer V> ? ReadonlyArray<DeepPartial<V>> :   // if it's an ReadOnly Array, // use a ReadOnly of DeepPartial // T[P] extends Array<infer U> ? Array<DeepPartial<U>> :        // if it is an array then use an Array of DeepPartial
        ? T[P] // if it's a primitive use that
        : NDeepPartial<T[P]>; // otherwise, it's a DeepPartial of the type.
    }
  : Partial<T>;

interface DeepPartialSet<ItemType> extends Set<NDeepPartial<ItemType>> {}
interface DeepPartialMap<KeyType, ValueType> extends Map<NDeepPartial<KeyType>, NDeepPartial<ValueType>> {}

const empty = new Set<string>();

function applyTo(source: any, target: any, exclusions: Set<string>, cache = new Set<any>()) {
  if (cache.has(source)) {
    throw new Error("Circular refrenced models are not permitted in apply() initializers.");
  }

  for (const i of <any>keys(source)) {
    if (exclusions.has(i)) {
      continue;
    }

    switch (typeof source[i]) {
      case "object":
        // merge objects
        if (source[i] != null && source[i] != undefined && typeof target[i] === "object") {
          cache.add(source);
          try {
            applyTo(source[i], target[i], exclusions, cache);
          } catch (E) {
            // eslint-disable-next-line no-console
            console.error(`  in property: ${i} `);
            throw E;
          }
          cache.delete(source);
          continue;
        }
        // otherwise, just use that object.
        target[i] = source[i];
        continue;

      /* bad idea? : 

      this recursively cloned the contents of the intializer
      but this has the effect of breaking referencs where I wanted 
      them.

      // copy toarray 
      if (Array.isArray(source[i])) {
        cache.add(source);
        applyTo(source[i], target[i] = [], cache);
        cache.delete(source);
        continue;
      }

      // otherwise, copy into an empty object
      cache.add(source);
      applyTo(source[i], target[i] = {}, cache);
      cache.delete(source);
      continue;
    */
      default:
        // everything else just replace.
        target[i] = source[i];
        continue;
    }
  }
}

/** inheriting from Initializer adds an apply<T> method to the class, allowing you to accept an object initalizer, and applying it to the class in the constructor. */
export class Initializer {
  protected apply<T>(...initializer: Array<DeepPartial<T> | undefined>) {
    for (const each of initializer) {
      applyTo(each, this, empty);
    }
  }
  protected applyWithExclusions<T>(exclusions: Array<string>, ...initializer: Array<DeepPartial<T> | undefined>) {
    const filter = new Set(exclusions);
    for (const each of initializer) {
      applyTo(each, this, filter);
    }
  }

  protected applyTo<T>($this: T, ...initializer: Array<DeepPartial<T> | undefined>) {
    for (const each of initializer) {
      applyTo(each, $this, empty);
    }
  }
}
