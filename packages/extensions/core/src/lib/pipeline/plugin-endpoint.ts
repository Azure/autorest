/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, LazyPromise, Mapping, SmartPosition } from "@azure-tools/datastore";
import { EnsureIsFolderUri } from "@azure-tools/uri";
import { ChildProcess, fork } from "child_process";
import { RawSourceMap } from "source-map";
import { Readable, Writable } from "stream";
import { CancellationToken, createMessageConnection } from "vscode-jsonrpc";
import { Artifact } from "../artifact";
import { AutorestContext } from "../context";
import { EventEmitter } from "../events";
import { Exception } from "@autorest/common";
import { ArtifactMessage, Channel, Message } from "../message";
import { IAutoRestPluginInitiator, IAutoRestPluginInitiatorTypes, IAutoRestPluginTargetTypes } from "./plugin-api";

interface IAutoRestPluginTargetEndpoint {
  GetPluginNames(cancellationToken: CancellationToken): Promise<Array<string>>;
  Process(pluginName: string, sessionId: string, cancellationToken: CancellationToken): Promise<boolean>;
}

interface IAutoRestPluginInitiatorEndpoint {
  FinishNotifications(): Promise<void>; // not exposed; necessary to ensure notifications are processed before

  ReadFile(filename: string): Promise<string>;
  GetValue(key: string): Promise<any>;
  ListInputs(artifactType?: string): Promise<Array<string>>;
  ProtectFiles(fileOrFolder: string): Promise<void>;

  WriteFile(filename: string, content: string, sourceMap?: Array<Mapping> | RawSourceMap): Promise<void>;
  Message(message: Message, path?: SmartPosition, sourceFile?: string): Promise<void>;
}

export class AutoRestExtension extends EventEmitter {
  private static lastSessionId = 0;
  private static CreateSessionId(): string {
    return `session_${++AutoRestExtension.lastSessionId}`;
  }
  private static processes = new Array<ChildProcess>();

  public kill() {
    if (!this.childProcess.killed) {
      this.childProcess.once("error", (e) => {
        /*shhh!*/
      });
      this.childProcess.kill();
    }
  }
  public static killAll() {
    for (const each of AutoRestExtension.processes) {
      if (!each.killed) {
        each.once("error", (e) => {
          /*shhh!*/
        });
        each.kill("SIGKILL");
      }
    }
    AutoRestExtension.processes.length = 0;
  }

  public static async FromModule(modulePath: string): Promise<AutoRestExtension> {
    const childProc = fork(modulePath, [], <any>{ silent: true });
    return AutoRestExtension.fromChildProcess(modulePath, "", childProc);
  }

  public static async fromChildProcess(
    extensionName: string,
    version: string,
    childProc: ChildProcess,
  ): Promise<AutoRestExtension> {
    if (childProc.stdout === null) {
      throw new Error("Child Process has no stdout pipe.");
    }
    if (childProc.stdin === null) {
      throw new Error("Child Process has no stdin pipe.");
    }
    const plugin = new AutoRestExtension(extensionName, version, childProc.stdout, childProc.stdin, childProc);
    if (childProc.stderr !== null) {
      childProc.stderr.pipe(process.stderr);
    }
    AutoRestExtension.processes.push(childProc);
    // poke the extension to detect trivial issues like process startup failure or protocol violations, ...
    if (!Array.isArray(await plugin.GetPluginNames(CancellationToken.None))) {
      throw new Exception(
        `Plugin '${extensionName}' violated the protocol ('GetPluginNames' returned unexpected object).`,
      );
    }

    return plugin;
  }

  // Exposed through __status and consumed by tools like autorest-interactive.
  private __inspectTraffic: Array<[number, boolean /*outgoing (core => ext)*/, string]> = [];

  public constructor(
    public extensionName: string,
    public extensionVersion: string,
    reader: Readable,
    writer: Writable,
    private childProcess: ChildProcess,
  ) {
    super();

    // hook in inspectors
    reader.on("data", (chunk) => {
      try {
        this.__inspectTraffic.push([Date.now(), false, chunk.toString()]);
      } catch {
        // no worries
      }
    });
    const writerProxy = new Writable({
      write: (chunk: string | Buffer, encoding: BufferEncoding, callback: Function) => {
        try {
          this.__inspectTraffic.push([Date.now(), true, chunk.toString()]);
        } catch {
          // no worries
        }
        return writer.write(chunk, encoding, <any>callback);
      },
    });

    // create channel
    const channel = createMessageConnection(reader, writerProxy, console);
    channel.listen();

    // initiator
    const dispatcher = (fnName: string) => async (sessionId: string, ...rest: Array<any>) => {
      try {
        const endpoint = this.apiInitiatorEndpoints[sessionId];
        if (endpoint) {
          return await (<any>endpoint)[fnName](...rest);
        }
      } catch (e) {
        if (e != "Cancellation requested.") {
          // Suppress this from hitting the console.
          // todo: we should see if we can put it out as an event.
        }
      }
    };
    this.apiInitiator = {
      ReadFile: dispatcher("ReadFile"),
      GetValue: dispatcher("GetValue"),
      ListInputs: dispatcher("ListInputs"),
      ProtectFiles: dispatcher("ProtectFiles"),

      WriteFile: dispatcher("WriteFile"),
      Message: dispatcher("Message"),
    };
    channel.onRequest(IAutoRestPluginInitiatorTypes.ReadFile, this.apiInitiator.ReadFile);
    channel.onRequest(IAutoRestPluginInitiatorTypes.GetValue, this.apiInitiator.GetValue);
    channel.onRequest(IAutoRestPluginInitiatorTypes.ListInputs, this.apiInitiator.ListInputs);
    channel.onNotification(IAutoRestPluginInitiatorTypes.ProtectFiles, this.apiInitiator.ProtectFiles);
    channel.onNotification(IAutoRestPluginInitiatorTypes.WriteFile, this.apiInitiator.WriteFile);
    channel.onNotification(IAutoRestPluginInitiatorTypes.Message, this.apiInitiator.Message);

    const errorPromise = new Promise<never>((_, rej) =>
      channel.onError((e) => {
        rej(new Exception(`AutoRest extension '${extensionName}' reported error: ` + e));
      }),
    );
    const terminationPromise = new Promise<never>((_, rej) =>
      channel.onClose(() => {
        rej(new Exception(`AutoRest extension '${extensionName}' terminated.`));
      }),
    );

    // target
    this.apiTarget = {
      async GetPluginNames(cancellationToken: CancellationToken): Promise<Array<string>> {
        return Promise.race([
          errorPromise,
          terminationPromise,
          channel.sendRequest(IAutoRestPluginTargetTypes.GetPluginNames, cancellationToken),
        ]);
      },
      async Process(pluginName: string, sessionId: string, cancellationToken: CancellationToken): Promise<boolean> {
        return Promise.race([
          errorPromise,
          terminationPromise,
          channel.sendRequest(IAutoRestPluginTargetTypes.Process, pluginName, sessionId, cancellationToken),
        ]);
      },
    };
  }

  private apiTarget: IAutoRestPluginTargetEndpoint;
  private apiInitiator: IAutoRestPluginInitiator;
  private apiInitiatorEndpoints: { [sessionId: string]: IAutoRestPluginInitiatorEndpoint } = {};

  public GetPluginNames(cancellationToken: CancellationToken): Promise<Array<string>> {
    return this.apiTarget.GetPluginNames(cancellationToken);
  }

  public async Process(
    pluginName: string,
    configuration: (key: string) => any,
    context: AutorestContext,
    inputScope: DataSource,
    sink: DataSink,
    onFile: (data: DataHandle) => void,
    onMessage: (message: Message) => void,
    cancellationToken: CancellationToken,
  ): Promise<boolean> {
    const sid = AutoRestExtension.CreateSessionId();

    // register endpoint
    this.apiInitiatorEndpoints[sid] = AutoRestExtension.CreateEndpointFor(
      pluginName,
      configuration,
      context,
      inputScope,
      sink,
      onFile,
      onMessage,
      cancellationToken,
    );

    // dispatch
    const result = await this.apiTarget.Process(pluginName, sid, cancellationToken);

    // wait for outstanding notifications
    await this.apiInitiatorEndpoints[sid].FinishNotifications();

    // unregister endpoint
    delete this.apiInitiatorEndpoints[sid];

    return result;
  }

  private static CreateEndpointFor(
    pluginName: string,
    configuration: (key: string) => any,
    context: AutorestContext,
    inputScope: DataSource,
    sink: DataSink,
    onFile: (data: DataHandle) => void,
    onMessage: (message: Message) => void,
    cancellationToken: CancellationToken,
  ): IAutoRestPluginInitiatorEndpoint {
    const inputFileHandles = new LazyPromise(async () => {
      const names = await inputScope.Enum();
      return Promise.all(names.map((fn) => inputScope.ReadStrict(fn)));
    });

    // name transformation
    // decodeUriComponent horsehockey is there because we may have an over-decoded URI from the plugin.
    const friendly2internal: (name: string) => Promise<string | undefined> = async (name) =>
      (
        (await inputFileHandles).filter(
          (h) => h.Description === name || decodeURIComponent(h.Description) === decodeURIComponent(name),
        )[0] || {}
      ).key;
    const internal2friendly: (name: string) => Promise<string | undefined> = async (key) =>
      ((await inputScope.Read(key)) || <any>{}).Description;

    const writeFileToSinkAndNotify = async (
      filename: string,
      content: string,
      artifactType?: string,
      sourceMap?: Array<Mapping> | RawSourceMap,
    ): Promise<Artifact> => {
      if (!sourceMap) {
        sourceMap = [];
      }
      // TODO: transform mappings so friendly names are replaced by internals
      let handle: DataHandle;
      if (typeof (<any>sourceMap).mappings === "string") {
        onFile(
          (handle = await sink.WriteDataWithSourceMap(
            filename,
            content,
            artifactType,
            ["fix-me-here"],
            () => <any>sourceMap,
          )),
        );
      } else {
        onFile(
          (handle = await sink.WriteData(
            filename,
            content,
            ["fix-me-here2"],
            artifactType,
            <Array<Mapping>>sourceMap,
            await inputFileHandles,
          )),
        );
      }
      return {
        uri: handle.key,
        type: handle.artifactType,
        content: await handle.ReadData(),
      };
    };

    let finishNotifications: Promise<void> = Promise.resolve();
    const apiInitiator: IAutoRestPluginInitiatorEndpoint = {
      FinishNotifications(): Promise<void> {
        return finishNotifications;
      },
      async ReadFile(filename: string): Promise<string> {
        try {
          const file = await inputScope.ReadStrict((await friendly2internal(filename)) || filename);
          return await file.ReadData();
        } catch (E) {
          // try getting the file from the output-folder
          try {
            const result = await context.fileSystem.ReadFile(`${context.config.outputFolderUri}${filename}`);
            return result;
          } catch (E2) {
            // no file there!
            throw E;
          }
        }
      },
      async GetValue(key: string): Promise<any> {
        try {
          const result = configuration(key);
          return result === undefined ? null : result;
        } catch (e) {
          return null;
        }
      },
      async ProtectFiles(fileOrFolder: string): Promise<void> {
        // protect files from being removed.
        const finishPrev = finishNotifications;
        let notify: () => void = () => {};
        finishNotifications = new Promise<void>((res) => (notify = res));

        onMessage(<Message>{
          Channel: Channel.Protect,
          Details: fileOrFolder,
          Text: fileOrFolder,
          Plugin: pluginName,
          Key: [],
        });

        await finishPrev;
        notify();
      },

      async ListInputs(artifactType?: string): Promise<Array<string>> {
        if (artifactType && typeof artifactType !== "string") {
          artifactType = undefined;
        }
        const inputs = (await inputFileHandles)
          .filter((x) => {
            return typeof artifactType !== "string" || artifactType === x.artifactType;
          })
          .map((x) => x.Description);

        // if the request returned items, or they didn't specify a path/artifacttype
        if (inputs.length > 0 || artifactType === null || artifactType === undefined) {
          return inputs;
        }

        // we'd like to be able to ask the host for a file directly (but only if it's supposed to be in the output-folder)
        const t = context.config.outputFolderUri.length;
        return (
          await context.fileSystem.EnumerateFileUris(
            EnsureIsFolderUri(`${context.config.outputFolderUri}${artifactType || ""}`),
          )
        ).map((each) => each.substr(t));
      },

      async WriteFile(filename: string, content: string, sourceMap?: Array<Mapping> | RawSourceMap): Promise<void> {
        if (!sourceMap) {
          sourceMap = [];
        }
        const finishPrev = finishNotifications;
        let notify: () => void = () => {};
        finishNotifications = new Promise<void>((res) => (notify = res));

        const artifact = await writeFileToSinkAndNotify(filename, content, undefined, sourceMap);
        onMessage(<ArtifactMessage>{
          Channel: Channel.File,
          Details: artifact,
          Text: artifact.content,
          Plugin: pluginName,
          Key: [artifact.type, artifact.uri],
        });

        await finishPrev;
        notify();
      },
      async Message(message: Message): Promise<void> {
        const finishPrev = finishNotifications;
        let notify: () => void = () => {};
        finishNotifications = new Promise<void>((res) => (notify = res));

        message.Plugin = message.Plugin || pluginName;
        // transform friendly with internals
        if (Array.isArray(message.Source)) {
          for (const source of message.Source) {
            if (source.document) {
              source.document = (await friendly2internal(source.document)) || source.document;
            }
          }
        }

        if (message.Channel === Channel.Configuration) {
          // special case. route the output to the config
          if (message.Key && message.Text) {
            const key = [...message.Key];
            if (key.length > 0) {
              context.updateConfigurationFile(key[0], message.Text);
            }
          }

          await finishPrev;
          notify();
        }

        if (message.Channel === Channel.File) {
          // wire through `sink` in order to retrieve default artifact type
          const artifactMessage = <ArtifactMessage>message;
          const artifact = artifactMessage.Details;

          await writeFileToSinkAndNotify(artifact.uri, artifact.content, artifact.type, artifact.sourceMap);
        }

        onMessage(message);

        await finishPrev;
        notify();
      },
    };
    return apiInitiator;
  }
}
