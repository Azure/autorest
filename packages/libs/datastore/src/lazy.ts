/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export class Lazy<T> {
  private promise: { obj: T } | null = null;

  public constructor(private factory: () => T) {}

  public get Value(): T {
    if (this.promise === null) {
      this.promise = { obj: this.factory() };
    }
    return this.promise.obj;
  }
}

export class LazyPromise<T> implements PromiseLike<T> {
  private promise: Promise<T> | null = null;

  public constructor(private factory: () => Promise<T>) {}

  private getValue(): Promise<T> {
    if (this.promise === null) {
      this.promise = this.factory();
    }
    return this.promise;
  }

  public get hasValue(): boolean {
    return this.promise !== null;
  }

  then<TResult1, TResult2>(
    onfulfilled: (value: T) => TResult1 | PromiseLike<TResult1>,
    onrejected: (reason: any) => TResult2 | PromiseLike<TResult2>,
  ): PromiseLike<TResult1 | TResult2> {
    return this.getValue().then(onfulfilled, onrejected);
  }
}
