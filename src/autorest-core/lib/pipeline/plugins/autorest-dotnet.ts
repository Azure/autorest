/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Lazy } from '../../lazy';
import { ChildProcess } from "child_process";
import { EventEmitter, IEvent } from '../../events';
import { CancellationToken } from "../../ref/cancallation";
import { SpawnJsonRpcAutoRest } from "../../../interop/autorest-dotnet";
import { AutoRestPlugin } from "../plugin-endpoint";
import { DataHandleRead, DataStoreViewReadonly, QuickScope, DataStoreView } from "../../data-store/data-store";
import { Message } from "../../message";

export class AutoRestDotNetPlugin extends EventEmitter {
  private static instance: AutoRestDotNetPlugin | null;
  public static Get(): AutoRestDotNetPlugin { return AutoRestDotNetPlugin.instance ? AutoRestDotNetPlugin.instance : (AutoRestDotNetPlugin.instance = new AutoRestDotNetPlugin()); }

  private childProc: ChildProcess;
  private pluginEndpoint: Promise<AutoRestPlugin>;

  private constructor() {
    super();
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
    outputScope: DataStoreView,
    onMessage: (message: Message) => void): Promise<void> {

    const ep = await this.pluginEndpoint;

    // probe
    const pluginNames = await ep.GetPluginNames(CancellationToken.None);
    if (pluginNames.indexOf(pluginName) === -1) {
      throw new Error(`The AutoRest dotnet extension does not offer a plugin called '${pluginName}'.`);
    }
    // process
    const success = await ep.Process(pluginName, configuration, inputScope, outputScope, onMessage, CancellationToken.None);
    if (!success) {
      throw new Error(`Plugin ${pluginName} failed.`);
    }
  }

  public async Validate(swagger: DataHandleRead, workingScope: DataStoreView, onMessage: (message: Message) => void): Promise<void> {
    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess("AzureValidator", _ => { }, new QuickScope([swagger]), outputScope, onMessage);
  }

  public async GenerateCode(
    codeModel: DataHandleRead,
    workingScope: DataStoreView,
    settings: {
      codeGenerator: string,
      namespace: string,
      clientNameOverride?: string,
      header: string | null,
      payloadFlatteningThreshold: number,
      syncMethods: "all" | "essential" | "none",
      internalConstructors: boolean,
      useDateTimeOffset: boolean,
      addCredentials: boolean,
      rubyPackageName: string
    },
    onMessage: (message: Message) => void): Promise<DataStoreViewReadonly> {

    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess(`Generator`, key => (settings as any)[key], new QuickScope([codeModel]), outputScope, onMessage);
    return outputScope;
  }

  public async SimplifyCSharpCode(
    inputScope: DataStoreViewReadonly,
    workingScope: DataStoreView,
    onMessage: (message: Message) => void): Promise<DataStoreViewReadonly> {

    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess(`CSharpSimplifier`, _ => null, inputScope, outputScope, onMessage);
    return outputScope;
  }

  public async Model(
    swagger: DataHandleRead,
    workingScope: DataStoreView,
    settings: { namespace: string },
    onMessage: (message: Message) => void): Promise<DataHandleRead> {

    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess("Modeler", key => (settings as any)[key], new QuickScope([swagger]), outputScope, onMessage);
    const results = await outputScope.Enum();
    if (results.length !== 1) {
      throw new Error(`Modeler plugin produced '${results.length}' items. Only expected one (the code model).`);
    }
    return await outputScope.ReadStrict(results[0]);
  }
}
