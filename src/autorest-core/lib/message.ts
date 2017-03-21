import { SmartPosition, Position } from './ref/source-map';

export type Channel = {
  readonly Information: "information",
  readonly Warning: "warning",
  readonly Error: "error",
  readonly Debug: "debug",
  readonly Verbose: "verbose",
  readonly Fatal: "fatal",
};

export const Channel: Channel = {
  Information: "information",
  Warning: "warning",
  Error: "error",
  Debug: "debug",
  Verbose: "verbose",
  Fatal: "fatal",
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
