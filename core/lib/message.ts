/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Position, RawSourceMap } from "source-map";
import { EnhancedPosition, Mapping } from "@azure-tools/datastore";
import { Artifact } from "./artifact";

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

  Control = <any>"Control",
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
}

export interface ArtifactMessage extends Message {
  Details: Artifact & { sourceMap?: Array<Mapping> | RawSourceMap };
}
