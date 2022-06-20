import { basename, dirname } from "path";
import { RequestType2, NotificationType2, NotificationType4, MessageConnection } from "vscode-jsonrpc";
import { AutorestExtensionLogger } from "./extension-logger";
import { Mapping, Message, RawSourceMap, Channel } from "./types";

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

/**
 * Sepecify that the source file and current file is a 1:1 mapping.
 */
export interface IdentitySourceMap {
  type: "identity";

  /**1
   * Name of the file that this file is mapping to.
   */
  source: string;
}

export interface WriteFileOptions {
  /**
   * @param filename Name of the file.
   */
  filename: string;

  /**
   * @param content Content of the file.
   */
  content: string;

  /**
   * @param sourceMap Source map that can be used to trace back source position in case of error.
   */
  sourceMap?: Mapping[] | RawSourceMap | IdentitySourceMap;

  /**
   * @param artifactType Artifact type
   */
  artifactType?: string;
}

export interface AutorestExtensionHost {
  logger: AutorestExtensionLogger;

  protectFiles(path: string): Promise<void>;
  readFile(filename: string): Promise<string>;
  getValue<T>(key: string): Promise<T | undefined>;
  listInputs(artifactType?: string): Promise<Array<string>>;
  writeFile({ filename, content, sourceMap, artifactType }: WriteFileOptions): void;
  message(message: Message): void;

  /**
   * @deprecated
   */
  UpdateConfigurationFile(filename: string, content: string): void;

  /**
   * @deprecated
   */
  GetConfigurationFile(filename: string): Promise<string>;

  /**
   * @deprecated use #writeFile
   */
  WriteFile(filename: string, content: string): void;

  /**
   * @deprecated use #getValue
   */
  GetValue(key: string): any;

  /**
   * @deprecated use #message
   */
  Message(message: Message): any;
}

export class AutorestExtensionRpcHost implements AutorestExtensionHost {
  public logger: AutorestExtensionLogger;

  public constructor(private channel: MessageConnection, private sessionId: string) {
    this.logger = new AutorestExtensionLogger((x) => this.message(x));
  }
  /**
   * Protect files that will not be cleared when using clear-output-folder.
   * @param path Path to the file/folder to protect.
   */
  public async protectFiles(path: string): Promise<void> {
    this.channel.sendNotification(IAutoRestPluginInitiatorTypes.ProtectFiles, this.sessionId, path);
  }

  public async readFile(filename: string): Promise<string> {
    return await this.channel.sendRequest(IAutoRestPluginInitiatorTypes.ReadFile, this.sessionId, filename);
  }

  /**
   * Get a configuration key form the resolved configuration.
   * @param key Path to the configuration entry. (Keys dot seperated)
   * @returns Value of the configuration.
   */
  public async getValue<T>(key: string): Promise<T | undefined> {
    return await this.channel.sendRequest(IAutoRestPluginInitiatorTypes.GetValue, this.sessionId, key);
  }

  /**
   * List inputs
   * @param artifactType @optional Filter by artifact type.
   * @returns name of the input files.
   */
  public async listInputs(artifactType?: string): Promise<Array<string>> {
    return await this.channel.sendRequest(IAutoRestPluginInitiatorTypes.ListInputs, this.sessionId, artifactType);
  }

  /**
   * Write a file.
   */
  public writeFile({ filename, content, sourceMap, artifactType }: WriteFileOptions): void {
    if (artifactType) {
      this.channel.sendNotification(IAutoRestPluginInitiatorTypes.Message, this.sessionId, {
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
      this.channel.sendNotification(
        IAutoRestPluginInitiatorTypes.WriteFile,
        this.sessionId,
        filename,
        content,
        sourceMap,
      );
    }
  }

  /**
   * Send a message.
   * @param message Message to send.
   */
  public message(message: Message): void {
    this.channel.sendNotification(IAutoRestPluginInitiatorTypes.Message, this.sessionId, message);
  }

  /**
   * @deprecated
   */
  public WriteFile(filename: string, content: string) {
    return this.writeFile({ filename, content });
  }

  /**
   * @deprecated
   */
  public GetValue(key: string) {
    return this.getValue(key);
  }

  /**
   * @deprecated
   */
  public Message(message: Message) {
    return this.message(message);
  }

  /**
   * @deprecated
   */
  public UpdateConfigurationFile(filename: string, content: string): void {
    this.channel.sendNotification(IAutoRestPluginInitiatorTypes.Message, this.sessionId, {
      Channel: Channel.Configuration,
      Key: [filename],
      Text: content,
    });
  }

  /**
   * @deprecated
   */
  public async GetConfigurationFile(filename: string): Promise<string> {
    const configurations = await this.channel.sendRequest(
      IAutoRestPluginInitiatorTypes.GetValue,
      this.sessionId,
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
  }
}
