/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { RequestType0, RequestType1, RequestType2 } from "../ref/jsonrpc";
import { NotificationType0, NotificationType1, NotificationType2, NotificationType3, NotificationType4 } from "../ref/jsonrpc";
import { Mapping, RawSourceMap, SmartPosition } from "../ref/source-map";


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


export module IAutoRestPluginTarget_Types {
  export const GetPluginNames = new RequestType0<string[], Error, void>("GetPluginNames");
  export const Process = new RequestType2<string, string, boolean, Error, void>("Process");
}
export interface IAutoRestPluginTarget {
  GetPluginNames(): Promise<string[]>;
  Process(pluginName: string, sessionId: string): Promise<boolean>;
}

export module IAutoRestPluginInitiator_Types {
  export const ReadFile = new RequestType2<string, string, string, Error, void>("ReadFile");
  export const GetValue = new RequestType2<string, string, any, Error, void>("GetValue");
  export const ListInputs = new RequestType1<string, string[], Error, void>("ListInputs");
  export const WriteFile = new NotificationType4<string, string, string, Mapping[] | RawSourceMap | undefined, void>("WriteFile");
  export const Message = new NotificationType4<string, Message<any>, SmartPosition | undefined, string | undefined, void>("Message");
}
export interface IAutoRestPluginInitiator {
  ReadFile(sessionId: string, filename: string): Promise<string>;
  GetValue(sessionId: string, key: string): Promise<any>;
  ListInputs(sessionId: string): Promise<string[]>;

  WriteFile(sessionId: string, filename: string, content: string, sourceMap?: Mapping[] | RawSourceMap): void;
  Message(sessionId: string, message: Message<any>, path?: SmartPosition, sourceFile?: string): void;
}
