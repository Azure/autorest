/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export class OutstandingTaskAwaiter {
  private outstandingTasks: Promise<any>[] = [];

  public async Wait(): Promise<void> {
    await Promise.all(this.outstandingTasks);
  }

  public async Await<T>(task: Promise<T>): Promise<T> {
    this.outstandingTasks.push(task);
    return task;
  }
}