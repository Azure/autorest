/* line: 1-based, column: 0-based */
export type Position =
  | {
      line: number; // 1-based
      column: number; // 0-based
    }
  | { path?: JsonPath };

export type JsonPath = Array<string | number>;

export interface SourceLocation {
  document: string;
  Position: Position;
}

export interface Artifact {
  uri: string;
  type: string;
  content: string;
}

/**
 * The Channel that a message is registered with.
 */
export enum Channel {
  /** Information is considered the mildest of responses; not necesarily actionable. */
  Information = <any>"information",

  /** Warnings are considered important for best practices, but not catastrophic in nature. */
  Warning = <any>"warning",

  /** Errors are considered blocking issues that block a successful operation.  */
  Error = <any>"error",

  /** Debug messages are designed for the developer to communicate internal autorest implementation details. */
  Debug = <any>"debug",

  /** Verbose messages give the user additional clarity on the process. */
  Verbose = <any>"verbose",

  /** Catastrophic failure, likely abending the process.  */
  Fatal = <any>"fatal",

  /** Hint messages offer guidance or support without forcing action. */
  Hint = <any>"hint",

  /** File represents a file output from an extension. Details are a Artifact and are required.  */
  File = <any>"file",

  /** content represents an update/creation of a configuration file. The final uri will be in the same folder as the primary config file. */
  Configuration = <any>"configuration",

  /** Protect is a path to not remove during a clear-output-folder.  */
  Protect = <any>"protect",
}

export interface Message {
  Channel: Channel;
  Key?: Iterable<string>;
  Details?: any;
  Text: string;
  Source?: Array<SourceLocation>;
}

export interface ArtifactMessage extends Message {
  Details: Artifact & { sourceMap?: Array<Mapping> | RawSourceMap };
}

export interface RawSourceMap {
  file?: string;
  sourceRoot?: string;
  version: string;
  sources: Array<string>;
  names: Array<string>;
  sourcesContent?: Array<string>;
  mappings: string;
}

export interface Mapping {
  generated: Position;
  original: Position;
  source: string;
  name?: string;
}
