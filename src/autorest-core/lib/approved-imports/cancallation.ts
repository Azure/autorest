/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

const cancellation = require("cancellation");

const createTokenSource: () => { cancel: (reason: string) => void, token: CancellationToken } = cancellation;
const tokenEmpty: CancellationToken = cancellation.empty;

export class CancellationToken {
  public static get none(): CancellationToken {
    return tokenEmpty;
  }

  public isCancelled: () => boolean;
  public throwIfCancelled: () => void;
  public onCancelled: (callback: (reason: string) => void) => void;
}

export class CancellationTokenSource {

  private slave = createTokenSource();

  public cancel(reason: string): void {
    this.slave.cancel(reason);
  }

  public get token(): CancellationToken {
    return this.slave.token;
  }
}