/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRest } from '../lib/autorest-core';

export function PumpMessagesToConsole(autoRest: AutoRest): void {
  autoRest.Debug.Subscribe((_, m) => console.log(m.Text));
  autoRest.Verbose.Subscribe((_, m) => console.log(m.Text));
  autoRest.Information.Subscribe((_, m) => console.log(m.Text));
  autoRest.Warning.Subscribe((_, m) => console.warn(m.Text));
  autoRest.Error.Subscribe((_, m) => console.error(m.Text));
  autoRest.Fatal.Subscribe((_, m) => console.error(m.Text));
}