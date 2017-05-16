/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export class Exception extends Error {
  constructor(message: string, public exitCode: number = 1) {
    super(message);
    Object.setPrototypeOf(this, Exception.prototype);
  }
}

export class OperationCanceledException extends Exception {
  constructor(message: string = "Cancelation Requested", public exitCode: number = 1) {
    super(message, exitCode);
    Object.setPrototypeOf(this, OperationCanceledException.prototype);
  }
}

export class OutstandingTaskAlreadyCompletedException extends Exception {
  constructor() {
    super("The OutstandingTaskAwaiter is already completed, may not Enter() again.", 1);
    Object.setPrototypeOf(this, OutstandingTaskAlreadyCompletedException.prototype);
  }
}

export class OperationAbortedException extends Exception {
  constructor() {
    super("Error occurred. Exiting.", 1);
    Object.setPrototypeOf(this, OperationAbortedException.prototype);
  }
}
