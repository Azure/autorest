/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Mappings, Mapping, RawSourceMap, SmartPosition, Position } from "../approved-imports/sourceMap";
import { CancellationToken } from "../approved-imports/cancallation";
import { createMessageConnection, MessageConnection } from "../approved-imports/jsonrpc";
import { RequestType0, RequestType1, RequestType2 } from "../approved-imports/jsonrpc";
import { NotificationType0, NotificationType1, NotificationType2, NotificationType3, NotificationType4 } from "../approved-imports/jsonrpc";
import { DataStoreViewReadonly, DataStoreView, DataHandleRead } from "../data-store/dataStore";

import { NotificationHandler4 } from "../approved-imports/jsonrpc";
/**
 * API
 */

export type MessageChannel =
  // exception
  "FATAL" |

  // your input is invalid
  "ERROR" |
  // we think you could do better
  "WARNING" |
  // hey there!
  "INFO" |
  // so I was thinking about...
  "VERBOSE" |

  // information about internals
  "DEBUG";

export interface Message<T> {
  channel: MessageChannel;
  message: string;
  payload: T;
}


const IAutoRestPluginTarget_GetPluginNames = new RequestType0<string[], Error, void>("GetPluginNames");
const IAutoRestPluginTarget_Process = new RequestType2<string, string, boolean, Error, void>("Process");
export interface IAutoRestPluginTarget {
  GetPluginNames(): Promise<string[]>;
  Process(pluginName: string, sessionId: string): Promise<boolean>;
}

const IAutoRestPluginInitiator_ReadFile = new RequestType2<string, string, string, Error, void>("ReadFile");
const IAutoRestPluginInitiator_GetValue = new RequestType2<string, string, any, Error, void>("GetValue");
const IAutoRestPluginInitiator_ListInputs = new RequestType1<string, string[], Error, void>("ListInputs");
const IAutoRestPluginInitiator_WriteFile = new NotificationType4<string, string, string, Mappings | RawSourceMap | undefined, void>("WriteFile");
const IAutoRestPluginInitiator_Message = new NotificationType4<string, Message<any>, SmartPosition | undefined, string | undefined, void>("Message");
export interface IAutoRestPluginInitiator {
  ReadFile(sessionId: string, filename: string): Promise<string>;
  GetValue(sessionId: string, key: string): Promise<any>;
  ListInputs(sessionId: string): Promise<string[]>;

  WriteFile(sessionId: string, filename: string, content: string, sourceMap?: Mappings | RawSourceMap): void;
  Message(sessionId: string, message: Message<any>, path?: SmartPosition, sourceFile?: string): void;
}

/**
 * Controller
 */

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
    channel.onRequest(IAutoRestPluginInitiator_ReadFile, this.apiInitiator.ReadFile);
    channel.onRequest(IAutoRestPluginInitiator_GetValue, this.apiInitiator.GetValue);
    channel.onRequest(IAutoRestPluginInitiator_ListInputs, this.apiInitiator.ListInputs);
    channel.onNotification(IAutoRestPluginInitiator_WriteFile, this.apiInitiator.WriteFile);
    channel.onNotification(IAutoRestPluginInitiator_Message, this.apiInitiator.Message);

    // target
    this.apiTarget = {
      async GetPluginNames(cancellationToken: CancellationToken): Promise<string[]> {
        return await channel.sendRequest(IAutoRestPluginTarget_GetPluginNames, cancellationToken);
      },
      async Process(pluginName: string, sessionId: string, cancellationToken: CancellationToken): Promise<boolean> {
        return await channel.sendRequest(IAutoRestPluginTarget_Process, pluginName, sessionId, cancellationToken);
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