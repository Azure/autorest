/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestConfiguration } from "../configuration/configuration";
import { DataStore, DataStoreView, DataHandleRead, DataStoreViewReadonly } from "../data-store/dataStore";

export class Pipeline {
  constructor(private configuration: DataHandleRead) {
  }

  public async run(pipelineView: DataStoreView): Promise<{ [productKey: string]: DataStoreViewReadonly }> {
    // beep
    return {};
  }
}