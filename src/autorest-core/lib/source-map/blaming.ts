/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { From } from "linq-es2015";
import * as sourceMap from "source-map";

export class BlameTree {
  public constructor(
    public readonly node: sourceMap.MappedPosition,
    public readonly blaming: BlameTree[]) { }

  public * blameInputs(): Iterable<sourceMap.MappedPosition> {
    // report self
    if (this.node.source.startsWith("input/")) {
      yield {
        column: this.node.column,
        line: this.node.line,
        name: this.node.name,
        source: decodeURIComponent(this.node.source.slice(6))
      };
    }
    // recurse
    yield* From(this.blaming).SelectMany(child => child.blameInputs());
  }
}