/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { RequestType0, RequestType1, RequestType2 } from "vscode-jsonrpc";
import { NotificationType2, NotificationType4 } from "vscode-jsonrpc";
import { SmartPosition } from "@azure-tools/datastore";
import { Mapping, RawSourceMap } from "source-map";
import { Message } from "../message";

export namespace IAutoRestPluginTargetTypes {
  export const GetPluginNames = new RequestType0<Array<string>, Error, void>("GetPluginNames");
  export const Process = new RequestType2<string, string, boolean, Error, void>("Process");
}
export interface IAutoRestPluginTarget {
  GetPluginNames(): Promise<Array<string>>;
  Process(pluginName: string, sessionId: string): Promise<boolean>;
}

export namespace IAutoRestPluginInitiatorTypes {
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
  /* @internal */ export const Message = new NotificationType4<
    string,
    Message,
    SmartPosition | undefined,
    string | undefined,
    void
  >("Message");
}
export interface IAutoRestPluginInitiator {
  ReadFile(sessionId: string, filename: string): Promise<string>;
  GetValue(sessionId: string, key: string): Promise<any>;
  ProtectFiles(sessionId: string, fileOrFolder: string): Promise<void>;
  ListInputs(sessionId: string, artifactType?: string): Promise<Array<string>>;

  WriteFile(sessionId: string, filename: string, content: string, sourceMap?: Array<Mapping> | RawSourceMap): void;
  Message(sessionId: string, message: Message, path?: SmartPosition, sourceFile?: string): void;
}
