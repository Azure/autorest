/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export function Delay(delayMS: number): Promise<void> {
  return new Promise<void>((res) => setTimeout(res, delayMS));
}
