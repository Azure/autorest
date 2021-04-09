/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable no-console */
import { AutoRest } from "../src/lib/autorest-core";
import { Message, Channel } from "../src/lib/message";

export function PumpMessagesToConsole(autoRest: AutoRest): void {
  autoRest.Message.Subscribe((_, m) => {
    switch (m.channel) {
      case Channel.Information:
      case Channel.Debug:
      case Channel.Verbose:
        console.log(m.message);
        break;
      case Channel.Warning:
        console.warn(m.message);
        break;
      case Channel.Error:
        console.error(m.message);
        break;
      case Channel.Fatal:
        console.error(m.message);
        break;
    }
  });
}
