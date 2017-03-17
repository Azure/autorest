/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/**
 * Why not observables or on "data"&"end" pattern?
 * 
 * - syntax support of MultiPromise
 *   - you can `await` to consume them
 *   - you can use `async` methods to create them
 * - "data"&"end" pattern has drawbacks
 *   - on consumer side
 *     - single occurrence of "end" purely contractual and NOT guaranteed by type system! => pot. source of bugs
 *     - if all data is required for processing, it has to be collected manually (introduces mutable state)
 *   - on producer side
 *     - event subscription system requires mutable state (list of subscribers)
 *   - in general
 *     - can a consumer unsubscribe? how? (sounds like further state!)
 *     - can a consumer miss some events by subscribing "too late", i.e. after an event was fired?
 *       - if yes: induces management complexity (all pipeline steps have to be hooked up FULLY before starting any computation)
 *       - if no: so you have to buffer everything. even after "end" was fired, someone may subscribe...
 * - in contrast, MultiPromise provides all that for free
 *   - immutable data structure, no explicit state
 *   - type system enforces order of events and single end of things
 *   - minimum amount of "past events" stored due to single linked list strucutre:
 *     - whoever holds a MultiPromise prevents garbage collection
 *     - consumption of an event effectively decrements ref-count on associated node
 *   - leverages error infrastrucure of Promise
 * - easy to "marshal" from/to any other paradigm (events, streams, regular promises, ...)
 */


export type MultiPromiseItem<T> = { readonly current: T, readonly next: MultiPromise<T> };
export type MultiPromise<T> = Promise<MultiPromiseItem<T> | null>;

export module MultiPromiseUtility {
  export function empty<T>(): MultiPromise<T> {
    return Promise.resolve(null);
  }
  export async function list<T>(items: T[]): MultiPromise<T> {
    let result: MultiPromise<T> = empty<T>();
    for (const item of items.reverse()) {
      result = Promise.resolve({
        current: item,
        next: result
      });
    }
    return result;
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
  export async function bind<T, U>(promise: MultiPromise<T>, f: (item: T) => MultiPromise<U>): MultiPromise<U> {
    const node = await promise;
    if (node === null) {
      return null;
    }
    const sub = f(node.current);
    return concatRace(sub, bind(node.next, f));
  }

  export function deferred<T>(promise: Promise<MultiPromise<T>>): MultiPromise<T> {
    return bind(fromPromise(promise), x => x);
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

  export function fromCallbacks<T>(executor: (callback: (item: T) => void) => Promise<void>): MultiPromise<T> {
    let nextResolve: (item: MultiPromiseItem<T> | null) => void;
    const next = () => new Promise<MultiPromiseItem<T> | null>(res => nextResolve = res);
    const result = next();
    const worker = async () => {
      await executor(item => {
        nextResolve({
          current: item,
          next: next()
        })
      });
      nextResolve(null);
      nextResolve = () => { };
    };
    process.nextTick(worker);
    return result;
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

  function race<T>(a: Promise<T>, b: Promise<T>): Promise<[T, Promise<T>]> {
    return Promise.race([a.then(x => [x, b]), b.then(x => [x, a])]);
  }

  export async function concatRace<T>(a: MultiPromise<T>, b: MultiPromise<T>): MultiPromise<T> {
    const [winner, loser] = await race(a, b);
    if (winner === null) {
      return loser;
    }
    return {
      current: winner.current,
      next: concatRace(winner.next, loser)
    };
  }
  export function joinRace<T>(...promise: MultiPromise<T>[]): MultiPromise<T> {
    return promise.reduce(concatRace, MultiPromiseUtility.empty<T>());
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


export class MultiPromiseBuilder<T> {
  private resolve: (promise: MultiPromise<T>) => void;
  private deferredPromise: MultiPromise<T>;
  private sources: MultiPromise<T>[] | null = [];

  public constructor() {
    this.deferredPromise = MultiPromiseUtility.deferred(new Promise(resolve => this.resolve = resolve));
  }

  public get Promise(): MultiPromise<T> {
    return this.deferredPromise;
  }

  public AddSource(promise: MultiPromise<T>): void {
    if (!this.sources) {
      throw new Error("Promise has already been built.");
    }
    this.sources.push(promise);
  }

  public Build(): void {
    if (!this.sources) {
      throw new Error("Promise has already been built.");
    }
    const sources = this.sources;
    this.sources = null;
    this.resolve(MultiPromiseUtility.joinRace(...sources));
  }
}