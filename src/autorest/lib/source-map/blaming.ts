/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as sourceMap from "source-map";

export interface BlameTree {
  node: sourceMap.MappedPosition;
  blaming: BlameTree[];
}