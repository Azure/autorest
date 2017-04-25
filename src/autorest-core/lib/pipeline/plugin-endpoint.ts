import { LazyPromise } from '../lazy';
import { EventEmitter, IEvent } from '../events';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { MultiPromise, MultiPromiseUtility } from '../multi-promise';
import { fork, ChildProcess } from "child_process";
import { Mappings, Mapping, RawSourceMap, SmartPosition, Position } from "../ref/source-map";
import { CancellationToken } from "../ref/cancallation";
import { createMessageConnection, MessageConnection } from "../ref/jsonrpc";
import { DataStoreViewReadonly, DataStoreView, DataHandleRead } from "../data-store/data-store";
import { IAutoRestPluginInitiator_Types, IAutoRestPluginTarget_Types, IAutoRestPluginInitiator } from "./plugin-api";
import { Channel, Message } from "../message";

interface IAutoRestPluginTargetEndpoint {
  GetPluginNames(cancellationToken: CancellationToken): Promise<string[]>;
  Process(pluginName: string, sessionId: string, cancellationToken: CancellationToken): Promise<boolean>;
}

interface IAutoRestPluginInitiatorEndpoint {
  FinishNotifications(): Promise<void>; // not exposed; necessary to ensure notifications are processed before 

  ReadFile(filename: string): Promise<string>;
  GetValue(key: string): Promise<any>;
  ListInputs(): Promise<string[]>;

  WriteFile(filename: string, content: string, sourceMap?: Mappings | RawSourceMap): Promise<void>;
  Message(message: Message, path?: SmartPosition, sourceFile?: string): Promise<void>;
}

export class AutoRestPlugin extends EventEmitter {
  private static lastSessionId: number = 0;
  private static CreateSessionId(): string { return `session_${++AutoRestPlugin.lastSessionId}`; }

  public static async FromModule(modulePath: string): Promise<AutoRestPlugin> {
    const childProc = fork(modulePath, [], <any>{ silent: true });
    return AutoRestPlugin.FromChildProcess(childProc);
  }

  public static async FromChildProcess(childProc: ChildProcess): Promise<AutoRestPlugin> {
    // childProc.on("error", err => { throw err; });
    const channel = createMessageConnection(
      childProc.stdout,
      childProc.stdin,
      console
    );
    childProc.stderr.pipe(process.stderr);
    const plugin = new AutoRestPlugin(channel);
    channel.onClose(() => { throw "AutoRest plugin terminated."; });
    channel.listen();
    return plugin;
  }

  public constructor(channel: MessageConnection) {
    super();
    // initiator
    const dispatcher = (fnName: string) => async (sessionId: string, ...rest: any[]) => {
      try {
        const endpoint = this.apiInitiatorEndpoints[sessionId];
        if (endpoint) {
          return await (endpoint as any)[fnName](...rest);
        }
      } catch (e) {
        if (e != "Cancellation requested.") {
          console.error(`Error occurred in handler for '${fnName}' in session '${sessionId}':`);
          console.error(e);
        }
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
  private apiInitiatorEndpoints: { [sessionId: string]: IAutoRestPluginInitiatorEndpoint } = {};

  public GetPluginNames(cancellationToken: CancellationToken): Promise<string[]> {
    return this.apiTarget.GetPluginNames(cancellationToken);
  }

  public async Process(pluginName: string, configuration: (key: string) => any, inputScope: DataStoreViewReadonly, outputScope: DataStoreView, onMessage: (message: Message) => void, cancellationToken: CancellationToken): Promise<boolean> {
    const sid = AutoRestPlugin.CreateSessionId();

    // register endpoint
    this.apiInitiatorEndpoints[sid] = AutoRestPlugin.CreateEndpointFor(pluginName, configuration, inputScope, outputScope, onMessage, cancellationToken);

    // dispatch
    const result = await this.apiTarget.Process(pluginName, sid, cancellationToken);

    // wait for outstanding notifications
    await this.apiInitiatorEndpoints[sid].FinishNotifications();

    // unregister endpoint
    delete this.apiInitiatorEndpoints[sid];

    return result;
  }

  private static CreateEndpointFor(pluginName: string, configuration: (key: string) => any, inputScope: DataStoreViewReadonly, outputScope: DataStoreView, onMessage: (message: Message) => void, cancellationToken: CancellationToken): IAutoRestPluginInitiatorEndpoint {
    let messageId: number = 0;

    const inputFileNames = new LazyPromise(async () => inputScope.Enum());
    const inputFileHandles = new LazyPromise(async () => {
      const names = await inputFileNames;
      return await Promise.all(names.map(fn => inputScope.ReadStrict(fn)));
    });

    let finishNotifications: Promise<void> = Promise.resolve();
    const apiInitiator: IAutoRestPluginInitiatorEndpoint = {
      FinishNotifications(): Promise<void> { return finishNotifications; },
      async ReadFile(filename: string): Promise<string> {
        const file = await inputScope.ReadStrict(filename);
        return file.ReadData();
      },
      async GetValue(key: string): Promise<any> {
        const result = configuration(key);
        return result === undefined ? null : result;
      },
      async ListInputs(): Promise<string[]> {
        return await inputFileNames;
      },

      async WriteFile(filename: string, content: string, sourceMap?: Mappings | RawSourceMap): Promise<void> {
        if (!sourceMap) {
          sourceMap = [];
        }
        const finishPrev = finishNotifications;
        let notify: () => void = () => { };
        finishNotifications = new Promise<void>(res => notify = res);

        const file = await outputScope.Write(filename);
        if (typeof (sourceMap as any).mappings === "string") {
          await file.WriteDataWithSourceMap(content, () => sourceMap as any);
        } else {
          await file.WriteData(content, sourceMap as Mappings, await inputFileHandles);
        }

        await finishPrev;
        notify();
      },
      async Message(message: Message, path?: SmartPosition, sourceFile?: string): Promise<void> {
        const finishPrev = finishNotifications;
        let notify: () => void = () => { };
        finishNotifications = new Promise<void>(res => notify = res);

        message.Plugin = pluginName;
        onMessage(message);

        await finishPrev;
        notify();
      }
    };
    return apiInitiator;
  }
}