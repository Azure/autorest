/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { fork } from "child_process";
import { Mappings, Mapping, RawSourceMap, SmartPosition, Position } from "../approved-imports/sourceMap";
import { CancellationToken } from "../approved-imports/cancallation";
import { createMessageConnection, MessageConnection, StreamMessageReader, StreamMessageWriter } from "../approved-imports/jsonrpc";
import { DataStoreViewReadonly, DataStoreView, DataHandleRead } from "../data-store/dataStore";
import { Message, IAutoRestPluginInitiator_Types, IAutoRestPluginTarget_Types, IAutoRestPluginInitiator } from "./plugin-api";


interface IAutoRestPluginTargetEndpoint {
  GetPluginNames(cancellationToken: CancellationToken): Promise<string[]>;
  Process(pluginName: string, sessionId: string, cancellationToken: CancellationToken): Promise<boolean>;
}

interface IAutoRestPluginInitiatorEndpoint {
  ReadFile(filename: string): Promise<string>;
  GetValue(key: string): Promise<any>;
  ListInputs(): Promise<string[]>;

  WriteFile(filename: string, content: string, sourceMap?: Mappings | RawSourceMap): Promise<void>;
  Message(message: Message<any>, path?: SmartPosition, sourceFile?: string): Promise<void>;
}

export class AutoRestPlugin {
  private static lastSessionId: number = 0;
  private static createSessionId(): string { return `session_${++AutoRestPlugin.lastSessionId}`; }

  public static async fromModule(modulePath: string): Promise<AutoRestPlugin> {
    const childProc = fork(modulePath);
    childProc.on("error", err => { throw err; });
    if (childProc.stdin === null) await new Promise(_ => { });
    const channel = createMessageConnection(
      childProc.stdout,
      childProc.stdin,
      {
        error(message) { console.error(message); },
        info(message) { console.info(message); },
        log(message) { console.log(message); },
        warn(message) { console.warn(message); }
      }
    );
    const plugin = new AutoRestPlugin(channel);
    channel.listen();
    return plugin;
  }

  public constructor(channel: MessageConnection) {
    // initiator
    const dispatcher = (fnName: string) => (sessionId: string, ...rest: any[]) => {
      const endpoint = this.apiInitiatorEndpoints[sessionId];
      if (endpoint) {
        return (endpoint as any)[fnName](...rest);
      }
    };
    this.apiInitiator = {
      ReadFile: dispatcher("ReadFile"),
      GetValue: dispatcher("GetValue"),
      ListInputs: dispatcher("ListInputs"),

      WriteFile: dispatcher("WriteFile"),
      Message: dispatcher("Message"),
    };
    channel.onRequest(IAutoRestPluginInitiator_Types.ReadFile, this.apiInitiator.ReadFile);
    channel.onRequest(IAutoRestPluginInitiator_Types.GetValue, this.apiInitiator.GetValue);
    channel.onRequest(IAutoRestPluginInitiator_Types.ListInputs, this.apiInitiator.ListInputs);
    channel.onNotification(IAutoRestPluginInitiator_Types.WriteFile, this.apiInitiator.WriteFile);
    channel.onNotification(IAutoRestPluginInitiator_Types.Message, this.apiInitiator.Message);

    // target
    this.apiTarget = {
      async GetPluginNames(cancellationToken: CancellationToken): Promise<string[]> {
        return await channel.sendRequest(IAutoRestPluginTarget_Types.GetPluginNames, cancellationToken);
      },
      async Process(pluginName: string, sessionId: string, cancellationToken: CancellationToken): Promise<boolean> {
        return await channel.sendRequest(IAutoRestPluginTarget_Types.Process, pluginName, sessionId, cancellationToken);
      }
    };
  }

  private apiTarget: IAutoRestPluginTargetEndpoint;
  private apiInitiator: IAutoRestPluginInitiator;
  private apiInitiatorEndpoints: { [sessionId: string]: IAutoRestPluginInitiatorEndpoint };

  public GetPluginNames(cancellationToken: CancellationToken): Promise<string[]> {
    return this.apiTarget.GetPluginNames(cancellationToken);
  }

  public async Process(pluginName: string, configuration: (key: string) => any, inputScope: DataStoreViewReadonly, workingScope: DataStoreView, cancellationToken: CancellationToken): Promise<boolean> {
    const sid = AutoRestPlugin.createSessionId();

    // register endpoint
    this.apiInitiatorEndpoints[sid] = AutoRestPlugin.createEndpointFor(configuration, inputScope, workingScope, cancellationToken);

    // dispatch
    const result = await this.apiTarget.Process(pluginName, sid, cancellationToken);

    // unregister endpoint
    delete this.apiInitiatorEndpoints[sid];

    return result;
  }

  private static createEndpointFor(configuration: (key: string) => any, inputScope: DataStoreViewReadonly, workingScope: DataStoreView, cancellationToken: CancellationToken): IAutoRestPluginInitiatorEndpoint {
    const workingScopeOutput = workingScope.createScope("output");
    const workingScopeMessages = workingScope.createScope("messages");
    let messageId: number = 0;

    const inputFileHandles = async () => {
      const inputFileNames = Array.from(await inputScope.enum());
      const inputFiles = await Promise.all(inputFileNames.map(fn => inputScope.read(fn)));
      return inputFiles as DataHandleRead[];
    }

    const apiInitiator = {
      async ReadFile(filename: string): Promise<string> {
        const file = await inputScope.read(filename);
        if (file === null) {
          throw new Error(`Requested file '${filename}' not found`);
        }
        return await file.readData();
      },
      async GetValue(key: string): Promise<any> {
        return configuration(key);
      },
      async ListInputs(): Promise<string[]> {
        const result = await inputScope.enum();
        return Array.from(result);
      },

      async WriteFile(filename: string, content: string, sourceMap: Mappings | RawSourceMap = []): Promise<void> {
        const file = await workingScopeOutput.write(filename);
        if (typeof (sourceMap as any).mappings === "string") {
          await file.writeDataWithSourceMap(content, async () => sourceMap);
        } else {
          await file.writeData(content, sourceMap as Mappings, await inputFileHandles());
        }
      },
      async Message(message: Message<any>, path?: SmartPosition, sourceFile?: string): Promise<void> {
        const dataHandle = await workingScopeMessages.write(`message_${messageId++}.yaml`);
        const mappings: Mapping[] = [];
        const files = await inputFileHandles();
        if (path) {
          if (!sourceFile) {
            if (files.length !== 1) {
              throw new Error("Message did not specify blame origin but there are multiple input files");
            }
            sourceFile = files[0].key;
          }
          var a: Position = { line: 1, column: 0 };
          var b: SmartPosition = a;

          mappings.push({
            name: `location of ${message.channel} '${message.message}'`,
            source: sourceFile,
            generated: <Position>{ line: 1, column: 0 },
            original: path
          });
        }
        dataHandle.writeObject(message, mappings, files);
      }
    };
    return apiInitiator;
  }
}