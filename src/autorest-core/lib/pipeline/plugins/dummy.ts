/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { createMessageConnection, Logger } from "vscode-jsonrpc";
import { IAutoRestPluginInitiator, IAutoRestPluginInitiator_Types, IAutoRestPluginTarget, IAutoRestPluginTarget_Types, Message } from "../plugin-api";
import { SmartPosition, Mapping, RawSourceMap } from "../../ref/source-map";


class DummyPlugin {
  public static readonly Name = "dummy";

  public async Process(sessionId: string, initiator: IAutoRestPluginInitiator): Promise<boolean> {
    const setting: string = await initiator.GetValue(sessionId, "truth");
    initiator.Message(sessionId, <Message<number>>{ channel: "DEBUG", message: setting, payload: 42 });
    return true;
  }
}

class PluginHost implements IAutoRestPluginTarget {
  public constructor(private readonly initiator: IAutoRestPluginInitiator) { }

  public async GetPluginNames(): Promise<string[]> {
    return [DummyPlugin.Name];
  }

  public async Process(pluginName: string, sessionId: string): Promise<boolean> {
    switch (pluginName) {
      case DummyPlugin.Name:
        return new DummyPlugin().Process(sessionId, this.initiator);
      default:
        return false;
    }
  }
}


async function main() {
  // connection setup
  const channel = createMessageConnection(
    process.stdin,
    process.stdout,
    {
      error(message) { console.error(message); },
      info(message) { console.info(message); },
      log(message) { console.log(message); },
      warn(message) { console.warn(message); }
    }
  );

  const initiator: IAutoRestPluginInitiator = {
    async ReadFile(sessionId: string, filename: string): Promise<string> {
      return await channel.sendRequest(IAutoRestPluginInitiator_Types.ReadFile, sessionId, filename);
    },
    async GetValue(sessionId: string, key: string): Promise<any> {
      return await channel.sendRequest(IAutoRestPluginInitiator_Types.GetValue, sessionId, key);
    },
    async ListInputs(sessionId: string): Promise<string[]> {
      return await channel.sendRequest(IAutoRestPluginInitiator_Types.ListInputs, sessionId);
    },

    WriteFile(sessionId: string, filename: string, content: string, sourceMap?: Mapping[] | RawSourceMap): void {
      channel.sendNotification(IAutoRestPluginInitiator_Types.WriteFile, sessionId, filename, content, sourceMap);
    },
    Message(sessionId: string, message: Message<any>, path?: SmartPosition, sourceFile?: string): void {
      channel.sendNotification(IAutoRestPluginInitiator_Types.Message, sessionId, message, path, sourceFile);
    }
  };
  const target: IAutoRestPluginTarget = new PluginHost(initiator);
  channel.onRequest(IAutoRestPluginTarget_Types.GetPluginNames, target.GetPluginNames.bind(target));
  channel.onRequest(IAutoRestPluginTarget_Types.Process, target.Process.bind(target));

  // activate
  channel.listen();
}

main();