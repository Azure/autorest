/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export type MultiPromiseItem<T> = { current: T, next: MultiPromise<T> };
export type MultiPromise<T> = Promise<MultiPromiseItem<T> | null>;

export module MultiPromiseUtility {
  export function empty<T>(): MultiPromise<T> {
    return Promise.resolve(null);
  }
  export function single<T>(value: T): MultiPromise<T> {
    return fromPromise<T>(Promise.resolve(value));
  }
  export function fromPromise<T>(promise: Promise<T>): MultiPromise<T> {
    return new Promise<{ current: T, next: MultiPromise<T> }>((resolve, reject) => {
      promise.then(value => resolve({ current: value, next: empty<T>() }));
      promise.catch(err => reject(err));
    });
  }

  export async function toAsyncCallbacks<T>(promise: MultiPromise<T>, callback: (item: T) => Promise<void>): Promise<void> {
    let res: MultiPromiseItem<T> | null;
    while (res = await promise) {
      await callback(res.current);
      promise = res.next;
    }
  }

  export function toCallbacks<T>(promise: MultiPromise<T>, callback: (item: T) => void): Promise<void> {
    return toAsyncCallbacks(promise, async item => callback(item));
  }

  export async function gather<T>(promise: MultiPromise<T>): Promise<T[]> {
    const result: T[] = [];
    await toCallbacks(promise, item => result.push(item));
    return result;
  }

  export async function getSingle<T>(promise: MultiPromise<T>): Promise<T> {
    const result = await gather<T>(promise);
    if (result.length !== 1) {
      throw new Error(`Expected single item but got ${result.length}`);
    }
    return result[0];
  }

  export async function map<T, U>(promise: MultiPromise<T>, selector: (item: T, index: number) => Promise<U>, startIndex: number = 0): MultiPromise<U> {
    const head = await promise;
    if (head === null) {
      return null;
    }
    const current = await selector(head.current, startIndex);
    return {
      current: current,
      next: map(head.next, selector, startIndex + 1)
    };
  }

  export async function concat<T>(a: MultiPromise<T>, b: MultiPromise<T>): MultiPromise<T> {
    const head = await a;
    if (head === null) {
      return b;
    }
    return {
      current: head.current,
      next: concat(head.next, b)
    };
  }

  export function join<T>(...promise: MultiPromise<T>[]): MultiPromise<T> {
    return promise.reduce(concat, MultiPromiseUtility.empty<T>());
  }
}
