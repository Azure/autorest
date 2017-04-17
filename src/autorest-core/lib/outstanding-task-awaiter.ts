/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { OutstandingTaskAlreadyCompletedException } from './exception';

export class OutstandingTaskAwaiter {
  private outstandingTaskCount: number = 1;
  private awaiter: Promise<void>;
  private resolve: () => void;

  public constructor() {
    this.awaiter = new Promise<void>(res => this.resolve = res);
  }

  public async Wait(): Promise<void> {
    this.outstandingTaskCount--;
    this.Signal();
    return this.awaiter;
  }

  public Enter(): void {
    if (this.outstandingTaskCount == 0) {
      throw new OutstandingTaskAlreadyCompletedException();
    }
    this.outstandingTaskCount++;
  }
  public Exit(): void { this.outstandingTaskCount--; this.Signal(); }
  public async Await<T>(task: Promise<T>): Promise<T> {
    this.Enter();
    const result = await task;
    this.Exit();
    return result;
  }

  private Signal(): void {
    if (this.outstandingTaskCount === 0) {
      this.resolve();
    }
  }
}