import { Range } from '../message';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/* line: 1-based, column: 0-based */
export { Position } from "source-map";
import { Position } from "source-map";
export { RawSourceMap } from "source-map";
import { JsonPath } from "../ref/jsonpath";

// information to attach to line/column based to get a richer experience
export interface PositionEnhancements {
  path?: JsonPath;
  length?: number;
  valueOffset?: number;
  valueLength?: number;
}

export type EnhancedPosition = Position & PositionEnhancements;

export type SmartPosition = Position | { path: JsonPath };

export interface Mapping {
  generated: SmartPosition;
  original: SmartPosition;
  source: string;
  name?: string;
}

export type Mappings = Array<Mapping>;