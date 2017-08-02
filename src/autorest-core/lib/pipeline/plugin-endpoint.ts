/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { LazyPromise } from "../lazy";
import { EventEmitter } from "../events";
import { fork, ChildProcess } from "child_process";
import { Mappings, RawSourceMap, SmartPosition } from "../ref/source-map";
import { CancellationToken } from "../ref/cancellation";
import { createMessageConnection, MessageConnection } from "../ref/jsonrpc";
import { DataHandleRead, DataSink, DataSource } from '../data-store/data-store';
import { IAutoRestPluginInitiator_Types, IAutoRestPluginTarget_Types, IAutoRestPluginInitiator } from "./plugin-api";
import { Exception } from "../exception";
import { Message } from "../message";

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

export class AutoRestExtension extends EventEmitter {
  private static lastSessionId: number = 0;
  private static CreateSessionId(): string { return `session_${++AutoRestExtension.lastSessionId}`; }

  public static async FromModule(modulePath: string): Promise<AutoRestExtension> {
    const childProc = fork(modulePath, [], <any>{ silent: true });
    return AutoRestExtension.FromChildProcess(modulePath, childProc);
  }

  public static async FromChildProcess(extensionName: string, childProc: ChildProcess): Promise<AutoRestExtension> {
    // childProc.on("error", err => { throw err; });
    const channel = createMessageConnection(
      childProc.stdout,
      childProc.stdin,
      console
    );
    childProc.stderr.pipe(process.stderr);
    const plugin = new AutoRestExtension(extensionName, channel);
    channel.listen();
    // poke the extension to detect trivial issues like process startup failure or protocol violations, ...
    if (!Array.isArray(await plugin.GetPluginNames(CancellationToken.None))) {
      throw new Exception(`Plugin '${extensionName}' violated the protocol ('GetPluginNames' returned unexpected object).`);
    }
    return plugin;
  }

  public constructor(extensionName: string, channel: MessageConnection) {
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

    const errorPromise = new Promise<never>((_, rej) => channel.onError(e => { rej(new Exception(`AutoRest extension '${extensionName}' reported error: ` + e)); }));
    const terminationPromise = new Promise<never>((_, rej) => channel.onClose(() => { rej(new Exception(`AutoRest extension '${extensionName}' terminated.`)); }));

    // target
    this.apiTarget = {
      async GetPluginNames(cancellationToken: CancellationToken): Promise<string[]> {
        return await Promise.race([errorPromise, terminationPromise, channel.sendRequest(IAutoRestPluginTarget_Types.GetPluginNames, cancellationToken)]);
      },
      async Process(pluginName: string, sessionId: string, cancellationToken: CancellationToken): Promise<boolean> {
        return await Promise.race([errorPromise, terminationPromise, channel.sendRequest(IAutoRestPluginTarget_Types.Process, pluginName, sessionId, cancellationToken)]);
      }
    };
  }

  private apiTarget: IAutoRestPluginTargetEndpoint;
  private apiInitiator: IAutoRestPluginInitiator;
  private apiInitiatorEndpoints: { [sessionId: string]: IAutoRestPluginInitiatorEndpoint } = {};

  public GetPluginNames(cancellationToken: CancellationToken): Promise<string[]> {
    return this.apiTarget.GetPluginNames(cancellationToken);
  }

  public async Process(pluginName: string, configuration: (key: string) => any, inputScope: DataSource, sink: DataSink, onFile: (data: DataHandleRead) => void, onMessage: (message: Message) => void, cancellationToken: CancellationToken): Promise<boolean> {
    const sid = AutoRestExtension.CreateSessionId();

    // register endpoint
    this.apiInitiatorEndpoints[sid] = AutoRestExtension.CreateEndpointFor(pluginName, configuration, inputScope, sink, onFile, onMessage, cancellationToken);

    // dispatch
    const result = await this.apiTarget.Process(pluginName, sid, cancellationToken);

    // wait for outstanding notifications
    await this.apiInitiatorEndpoints[sid].FinishNotifications();

    // unregister endpoint
    delete this.apiInitiatorEndpoints[sid];

    return result;
  }

  private static CreateEndpointFor(pluginName: string, configuration: (key: string) => any, inputScope: DataSource, sink: DataSink, onFile: (data: DataHandleRead) => void, onMessage: (message: Message) => void, cancellationToken: CancellationToken): IAutoRestPluginInitiatorEndpoint {
    const inputFileHandles = new LazyPromise(async () => {
      const names = await inputScope.Enum();
      return await Promise.all(names.map(fn => inputScope.ReadStrict(fn)));
    });

    let finishNotifications: Promise<void> = Promise.resolve();
    const apiInitiator: IAutoRestPluginInitiatorEndpoint = {
      FinishNotifications(): Promise<void> { return finishNotifications; },
      async ReadFile(filename: string): Promise<string> {
        const file = (await inputFileHandles).filter(h => h.Description === filename)[0];
        if (!file) {
          throw new Error(`Requested file '${filename}' not found.`);
        }
        return file.ReadData();
      },
      async GetValue(key: string): Promise<any> {
        const result = configuration(key);
        return result === undefined ? null : result;
      },
      async ListInputs(): Promise<string[]> {
        return (await inputFileHandles).map(x => x.Description);
      },

      async WriteFile(filename: string, content: string, sourceMap?: Mappings | RawSourceMap): Promise<void> {
        if (!sourceMap) {
          sourceMap = [];
        }
        const finishPrev = finishNotifications;
        let notify: () => void = () => { };
        finishNotifications = new Promise<void>(res => notify = res);

        // TODO: transform mappings so friendly names are replaced by internals
        if (typeof (sourceMap as any).mappings === "string") {
          onFile(await sink.WriteDataWithSourceMap(filename, content, () => sourceMap as any));
        } else {
          onFile(await sink.WriteData(filename, content, sourceMap as Mappings, await inputFileHandles));
        }

        await finishPrev;
        notify();
      },
      async Message(message: Message): Promise<void> {
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