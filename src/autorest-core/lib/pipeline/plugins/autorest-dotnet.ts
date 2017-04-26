import { ConfigurationView } from '../../autorest-core';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Lazy } from "../../lazy";
import { AutoRestConfigurationImpl } from "../../configuration";
import { ChildProcess } from "child_process";
import { EventEmitter } from "../../events";
import { CancellationToken } from "../../ref/cancallation";
import { SpawnJsonRpcAutoRest } from "../../../interop/autorest-dotnet";
import { AutoRestPlugin } from "../plugin-endpoint";
import { DataHandleRead, DataStoreViewReadonly, QuickScope, DataStoreView } from "../../data-store/data-store";
import { Message } from "../../message";

export class AutoRestDotNetPlugin extends EventEmitter {
  private static instance = new Lazy<AutoRestDotNetPlugin>(() => new AutoRestDotNetPlugin());
  public static Get(): AutoRestDotNetPlugin { return AutoRestDotNetPlugin.instance.Value; }

  private childProc: ChildProcess;
  public pluginEndpoint: Promise<AutoRestPlugin>;

  private constructor() {
    super();
    this.childProc = SpawnJsonRpcAutoRest();
    this.pluginEndpoint = AutoRestPlugin.FromChildProcess(this.childProc);
  }

  /**
   * Probes whether the extension even supports the requested plugin.
   */
  public async CautiousProcess(
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

  async Validate(swagger: DataHandleRead, workingScope: DataStoreView, onMessage: (message: Message) => void, isIndividual: boolean, openapiType: string): Promise<void> {
    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess("azure-validator", key => {
      switch (key) {
        case "openapi-type": return openapiType;
        case "merge-state": return isIndividual;
        default: return null;
      }
    }, new QuickScope([swagger]), outputScope, onMessage);
  }

  public async ValidateIndividual(swagger: DataHandleRead, workingScope: DataStoreView, openapiType: string, onMessage: (message: Message) => void): Promise<void> {
    await this.Validate(swagger, workingScope, onMessage, true, openapiType /* TODO: derive from stuff */);
  }

  public async ValidateComposite(swagger: DataHandleRead, workingScope: DataStoreView, openapiType: string, onMessage: (message: Message) => void): Promise<void> {
    await this.Validate(swagger, workingScope, onMessage, false, openapiType /* TODO: derive from stuff */);
  }

  public async GenerateCode(
    config: ConfigurationView,
    language: string,
    swaggerDocument: DataHandleRead,
    codeModel: DataHandleRead,
    workingScope: DataStoreView,
    onMessage: (message: Message) => void): Promise<DataStoreViewReadonly> {

    const rawSwagger = await swaggerDocument.ReadObject<any>();
    const getXmsCodeGenSetting = (name: string) => (() => { try { return rawSwagger.info["x-ms-code-generation-settings"][name]; } catch (e) { return null; } })();
    const settings: AutoRestConfigurationImpl =
      Object.assign(
        { // stuff that comes in via `x-ms-code-generation-settings`
          "override-client-name": getXmsCodeGenSetting("name"),
          "use-internal-constructors": getXmsCodeGenSetting("internalConstructors"),
          "use-datetimeoffset": getXmsCodeGenSetting("useDateTimeOffset"),
          "payload-flattening-threshold": getXmsCodeGenSetting("ft"),
          "sync-methods": getXmsCodeGenSetting("syncMethods")
        },
        config.Raw);

    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess(language, key => (settings as any)[key], new QuickScope([swaggerDocument, codeModel]), outputScope, onMessage);
    return outputScope;
  }

  public async SimplifyCSharpCode(
    inputScope: DataStoreViewReadonly,
    workingScope: DataStoreView,
    onMessage: (message: Message) => void): Promise<DataStoreViewReadonly> {

    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess(`csharp-simplifier`, _ => null, inputScope, outputScope, onMessage);
    return outputScope;
  }

  public async Model(
    swagger: DataHandleRead,
    workingScope: DataStoreView,
    settings: { namespace: string },
    onMessage: (message: Message) => void): Promise<DataHandleRead> {

    const outputScope = workingScope.CreateScope("output");
    await this.CautiousProcess("modeler", key => (settings as any)[key], new QuickScope([swagger]), outputScope, onMessage);
    const results = await outputScope.Enum();
    if (results.length !== 1) {
      throw new Error(`Modeler plugin produced '${results.length}' items. Only expected one (the code model).`);
    }
    return await outputScope.ReadStrict(results[0]);
  }
}
