/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Lazy } from "../../lazy";
import { ConfigurationView } from '../../autorest-core';
import { AutoRestConfigurationImpl } from "../../configuration";
import { ChildProcess } from "child_process";
import { CancellationToken } from "../../ref/cancallation";
import { SpawnJsonRpcAutoRest } from "../../../interop/autorest-dotnet";
import { AutoRestPlugin } from "../plugin-endpoint";
import { DataHandleRead, DataStoreViewReadonly, QuickScope, DataStoreView } from "../../data-store/data-store";
import { Message } from "../../message";

export class AutoRestDotNetPlugin {
  private static instance = new Lazy<AutoRestDotNetPlugin>(() => new AutoRestDotNetPlugin());
  public static Get(): AutoRestDotNetPlugin { return AutoRestDotNetPlugin.instance.Value; }

  public pluginEndpoint: Promise<AutoRestPlugin>;

  private constructor() {
    this.pluginEndpoint = AutoRestPlugin.FromChildProcess(SpawnJsonRpcAutoRest());
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
    const success = await (await this.pluginEndpoint).Process(language, key => (settings as any)[key], new QuickScope([swaggerDocument, codeModel]), outputScope, onMessage, CancellationToken.None);
    if (!success) {
      throw new Error(`Language generation for ${language} failed.`);
    }
    return outputScope;
  }
}
