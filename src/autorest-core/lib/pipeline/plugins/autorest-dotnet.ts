/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ChildProcess } from "child_process";
import { CancellationToken } from "../../approved-imports/cancallation";
import { SpawnJsonRpcAutoRest } from "../../../interop/autorest-dotnet";
import { AutoRestPlugin } from "../plugin-endpoint";
import { DataHandleRead, DataStoreViewReadonly, QuickScope, DataStoreView } from "../../data-store/data-store";


export class AutoRestDotNetPlugin {
  private childProc: ChildProcess;
  private pluginEndpoint: Promise<AutoRestPlugin>;

  public constructor() {
    this.childProc = SpawnJsonRpcAutoRest();
    this.pluginEndpoint = AutoRestPlugin.FromChildProcess(this.childProc);
  }

  /**
   * Probes whether the extension even supports the requested plugin.
   */
  private async CautiousProcess(
    pluginName: string,
    configuration: (key: string) => any,
    inputScope: DataStoreViewReadonly,
    workingScope: DataStoreView): Promise<void> {

    const ep = await this.pluginEndpoint;
    // probe
    const pluginNames = await ep.GetPluginNames(CancellationToken.None);
    if (pluginNames.indexOf(pluginName) === -1) {
      throw new Error(`The AutoRest dotnet extension does not offer a plugin called '${pluginName}'.`);
    }
    // process
    const success = ep.Process(pluginName, configuration, inputScope, workingScope, CancellationToken.None);
    if (!success) {
      throw new Error(`Plugin ${pluginName} failed.`);
    }
  }

  public async Validate(swagger: DataHandleRead, workingScope: DataStoreView): Promise<void> {
    await this.CautiousProcess("Azure-Validator", _ => { }, new QuickScope([swagger]), workingScope);
  }

  public async GenerateCode(targetLanguage: string, swagger: DataHandleRead, workingScope: DataStoreView): Promise<void> {
    await this.CautiousProcess(`${targetLanguage}-Generator`, _ => { }, new QuickScope([swagger]), workingScope);
  }
}
