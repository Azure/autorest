import { ShadowedObject } from "@azure-tools/codegen";

export interface Position {
  line: number;
  column: number;
}

export interface PathPosition {
  /**
   * Path to the element. Either as a json pointer string or as an array of segements.
   */
  path: JsonPointerSegments | string;
}

export type JsonPointerSegments = Array<string | number>;

export interface SourceLocation {
  document: string;
  Position: Position | PathPosition;
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
  Information = "information",

  /** Warnings are considered important for best practices, but not catastrophic in nature. */
  Warning = "warning",

  /** Errors are considered blocking issues that block a successful operation.  */
  Error = "error",

  /** Debug messages are designed for the developer to communicate internal autorest implementation details. */
  Debug = "debug",

  /** Verbose messages give the user additional clarity on the process. */
  Verbose = "verbose",

  /** Catastrophic failure, likely abending the process.  */
  Fatal = "fatal",

  /** Hint messages offer guidance or support without forcing action. */
  Hint = "hint",

  /** File represents a file output from an extension. Details are a Artifact and are required.  */
  File = "file",

  /** content represents an update/creation of a configuration file. The final uri will be in the same folder as the primary config file. */
  Configuration = "configuration",

  /** Protect is a path to not remove during a clear-output-folder.  */
  Protect = "protect",
}

export interface Message {
  Channel: Channel;
  Key?: Iterable<string>;
  Details?: any;
  Text: string;
  Source?: SourceLocation[];
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

export type LogSource = string | Position | PathPosition | ShadowedObject<any>;
