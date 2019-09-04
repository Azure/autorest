/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { OutstandingTaskAlreadyCompletedException } from "./exception";


export class OutstandingTaskAwaiter {
  private locked: boolean = false;
  private outstandingTasks: Promise<any>[] = [];


  public async Wait(): Promise<void> {
    this.locked = true;
    await Promise.all(this.outstandingTasks);
  }

  public async Await<T>(task: Promise<T>): Promise<T> {
    if (this.locked) {
      throw new OutstandingTaskAlreadyCompletedException();
    }
    this.outstandingTasks.push(task);
    return task;
  }
}