import { EnhancedPosition, Position, SmartPosition } from './ref/source-map';

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
  Source?: Array<SourceLocation>;
  Range?: Iterable<Range>;
  Plugin?: string;
};
