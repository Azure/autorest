import { SmartPosition, Position } from './ref/source-map';

export enum Channel {
  Information = <any>"information",
  Warning = <any>"warning",
  Error = <any>"error",
  Debug = <any>"debug",
  Verbose = <any>"verbose",
  Fatal = <any>"fatal",
}

export interface SourceLocation {
  document: string;
  Position: SmartPosition;
}

export interface Range {
  document: string;
  start: Position;
  end: Position;
}

export interface Message {
  Channel?: Channel;
  Key?: AsyncIterable<string>;
  Details?: any;
  Text: string;
  Source?: Array<SourceLocation>;
  Range?: AsyncIterable<Range>;
  Plugin?: string;
};
