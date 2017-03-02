/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { JsonPath } from "../approved-imports/jsonpath";

export type Position = sourceMap.Position; /* line: 1-based, column: 0-based */
export type SmartPosition = Position | { path: JsonPath };

export interface Mapping {
  generated: SmartPosition;
  original: SmartPosition;
  source: string;
  name?: string;
}

export type Mappings = Iterable<Mapping>;