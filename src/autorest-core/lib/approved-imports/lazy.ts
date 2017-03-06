/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export class Lazy<T> {
  private promise: Promise<T> | null = null;

  public constructor(private factory: () => Promise<T>) {
  }

  public get Value(): Promise<T> {
    if (this.promise === null) {
      this.promise = this.factory();
    }
    return this.promise;
  }
}