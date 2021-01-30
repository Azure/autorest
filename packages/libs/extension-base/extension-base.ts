import {
  createMessageConnection,
  Logger,
  RequestType0,
  RequestType1,
  RequestType2,
  NotificationType2,
  NotificationType4,
} from "vscode-jsonrpc";
import { Readable } from "stream";
import { Mapping, Message, RawSourceMap, Channel } from "./types";
import { basename, dirname } from "path";

namespace IAutoRestPluginTargetTypes {
  export const GetPluginNames = new RequestType0<Array<string>, Error, void>("GetPluginNames");
  export const Process = new RequestType2<string, string, boolean, Error, void>("Process");
}
interface IAutoRestPluginTarget {
  GetPluginNames(): Promise<Array<string>>;
  Process(pluginName: string, sessionId: string): Promise<boolean>;
}

namespace IAutoRestPluginInitiatorTypes {
  export const ReadFile = new RequestType2<string, string, string, Error, void>("ReadFile");
  export const GetValue = new RequestType2<string, string, any, Error, void>("GetValue");
  export const ListInputs = new RequestType2<string, string | undefined, Array<string>, Error, void>("ListInputs");
  export const ProtectFiles = new NotificationType2<string, string, void>("ProtectFiles");
  export const WriteFile = new NotificationType4<
    string,
    string,
    string,
    Array<Mapping> | RawSourceMap | undefined,
    void
  >("WriteFile");
  export const Message = new NotificationType2<string, Message, void>("Message");
}

export interface IAutoRestPluginInitiator {
  ReadFile(filename: string): Promise<string>;
  GetValue(key: string): Promise<any>;
  ListInputs(artifactType?: string): Promise<Array<string>>;
  ProtectFiles(path: string): Promise<void>;
  WriteFile(filename: string, content: string, sourceMap?: Array<Mapping> | RawSourceMap, artifactType?: string): void;
  Message(message: Message): void;
  UpdateConfigurationFile(filename: string, content: string): void;
  GetConfigurationFile(filename: string): Promise<string>;
}

export type AutoRestPluginHandler = (initiator: IAutoRestPluginInitiator) => Promise<void>;

export class AutoRestExtension {
  private readonly plugins: { [name: string]: AutoRestPluginHandler } = {};

  public Add(name: string, handler: AutoRestPluginHandler): void {
    this.plugins[name] = handler;
  }

  public async Run(
    input: NodeJS.ReadableStream = process.stdin,
    output: NodeJS.WritableStream = process.stdout,
  ): Promise<void> {
    // connection setup
    const channel = createMessageConnection(input, output, {
      error(message) {
        // eslint-disable-next-line no-console
        console.error("error: ", message);
      },
      info(message) {
        // eslint-disable-next-line no-console
        console.error("info: ", message);
      },
      log(message) {
        // eslint-disable-next-line no-console
        console.error("log: ", message);
      },
      warn(message) {
        // eslint-disable-next-line no-console
        console.error("warn: ", message);
      },
    });

    channel.onRequest(IAutoRestPluginTargetTypes.GetPluginNames, async () => Object.keys(this.plugins));
    channel.onRequest(IAutoRestPluginTargetTypes.Process, async (pluginName: string, sessionId: string) => {
      try {
        const handler = this.plugins[pluginName];
        if (!handler) {
          throw new Error(`Plugin host could not find requested plugin '${pluginName}'.`);
        }
        await handler({
          async ProtectFiles(path: string): Promise<void> {
            channel.sendNotification(IAutoRestPluginInitiatorTypes.ProtectFiles, sessionId, path);
          },
          UpdateConfigurationFile(filename: string, content: string): void {
            channel.sendNotification(IAutoRestPluginInitiatorTypes.Message, sessionId, {
              Channel: Channel.Configuration,
              Key: [filename],
              Text: content,
            });
          },
          async GetConfigurationFile(filename: string): Promise<string> {
            const configurations = await channel.sendRequest(
              IAutoRestPluginInitiatorTypes.GetValue,
              sessionId,
              "configurationFiles",
            );

            const filenames = Object.getOwnPropertyNames(configurations);
            if (filenames.length > 0) {
              const basePath = dirname(filenames[0]);
              for (const configFile of filenames) {
                if (configFile.startsWith(basePath) && filename === basename(configFile)) {
                  return configurations[configFile];
                }
              }
            }
            return "";
          },
          async ReadFile(filename: string): Promise<string> {
            return await channel.sendRequest(IAutoRestPluginInitiatorTypes.ReadFile, sessionId, filename);
          },
          async GetValue(key: string): Promise<any> {
            return await channel.sendRequest(IAutoRestPluginInitiatorTypes.GetValue, sessionId, key);
          },
          async ListInputs(artifactType?: string): Promise<Array<string>> {
            return await channel.sendRequest(IAutoRestPluginInitiatorTypes.ListInputs, sessionId, artifactType);
          },
          WriteFile(
            filename: string,
            content: string,
            sourceMap?: Array<Mapping> | RawSourceMap,
            artifactType?: string,
          ): void {
            if (artifactType) {
              channel.sendNotification(IAutoRestPluginInitiatorTypes.Message, sessionId, {
                Channel: Channel.File,
                Details: {
                  content: content,
                  type: artifactType,
                  uri: filename,
                  sourceMap: sourceMap,
                },
                Text: content,
                Key: [artifactType, filename],
              });
            } else {
              channel.sendNotification(
                IAutoRestPluginInitiatorTypes.WriteFile,
                sessionId,
                filename,
                content,
                sourceMap,
              );
            }
          },

          Message(message: Message): void {
            channel.sendNotification(IAutoRestPluginInitiatorTypes.Message, sessionId, message);
          },
        });
        return true;
      } catch (e) {
        if (await channel.sendRequest(IAutoRestPluginInitiatorTypes.GetValue, sessionId, "debug")) {
          // eslint-disable-next-line no-console
          console.error(`PLUGIN FAILURE: ${e.message}, ${e.stack}, ${JSON.stringify(e, null, 2)}`);
        }

        channel.sendNotification(IAutoRestPluginInitiatorTypes.Message, sessionId, <Message>{
          Channel: <any>"fatal",
          Text: "" + e,
          Details: e,
        });
        return false;
      }
    });

    // activate
    channel.listen();
  }
}
