/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { OutstandingTaskAlreadyCompletedException } from "@autorest/common";

export class OutstandingTaskAwaiter {
  private locked = false;
  private outstandingTasks: Array<Promise<any>> = [];

  public async wait(): Promise<void> {
    this.locked = true;
    await Promise.all(this.outstandingTasks);
  }

  public await<T>(task: Promise<T>) {
    if (this.locked) {
      throw new OutstandingTaskAlreadyCompletedException();
    }
    this.outstandingTasks.push(task);
  }
}
