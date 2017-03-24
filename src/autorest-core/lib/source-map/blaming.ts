/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataStore } from "../data-store/data-store";
import { From } from "../ref/linq";

export class BlameTree {
  public static async Create(dataStore: DataStore, position: sourceMap.MappedPosition): Promise<BlameTree> {
    const data = await dataStore.ReadStrict(position.source);
    const blames = await data.Blame(position);
    return new BlameTree(position, await Promise.all(blames.map(pos => BlameTree.Create(dataStore, pos))));
  }

  private constructor(
    public readonly node: sourceMap.MappedPosition,
    public readonly blaming: BlameTree[]) { }

  public * BlameInputs(): Iterable<sourceMap.MappedPosition> {
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
    yield* From(this.blaming).SelectMany(child => child.BlameInputs()).Distinct(x => JSON.stringify(x));
  }

  public * All(): Iterable<sourceMap.MappedPosition> {
    yield this.node;
    // recurse
    yield* From(this.blaming).SelectMany(child => child.All());
  }
}

