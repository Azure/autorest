/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { EnhancedPosition, Position } from "./ref/source-map";

export enum Channel {
  Information = <any>"information",
  Warning = <any>"warning",
  Error = <any>"error",
  Debug = <any>"debug",
  Verbose = <any>"verbose",
  Fatal = <any>"fatal",
  Hint = <any>"hint",
}

export interface SourceLocation {
  document: string;
  Position: EnhancedPosition;
}

export interface Range {
  document: string;
  start: Position;
  end: Position;
}

export interface Message {
  Channel: Channel;
  Key?: Iterable<string>;
  Details?: any;
  Text: string;

  // injected or modified by core
  Source?: Array<SourceLocation>;
  Range?: Iterable<Range>;
  Plugin?: string;
  FormattedMessage?: string;
};
