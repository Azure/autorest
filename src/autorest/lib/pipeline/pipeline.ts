/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestConfiguration } from "../configuration/configuration";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly } from "../data-store/dataStore";

export type PipelineProducts = { [productKey: string]: DataStoreViewReadonly };

export class Pipeline {
  constructor(private configuration: DataHandleRead) {
    this.build(configuration.readObject<AutoRestConfiguration>());
  }

  private build(configuration: AutoRestConfiguration) {
    // bleep
  }

  public async run(pipelineView: DataStoreView): Promise<PipelineProducts> {
    const result: PipelineProducts = {};

    // forward global view for debugging
    result["root"] = pipelineView.asReadonly();

    // bloop


    return result;
  }
}