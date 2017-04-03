import { IsUri } from '../ref/uri';
import { JsonPath } from '../ref/jsonpath';
import { EncodeEnhancedPositionInName, TryDecodeEnhancedPositionFromName } from './source-map';
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

    // propagate smart position
    const enhanced = TryDecodeEnhancedPositionFromName(position.name);
    if (enhanced !== undefined) {
      for (const blame of blames) {
        blame.name = EncodeEnhancedPositionInName(blame.name, Object.assign(
          JSON.parse(JSON.stringify(enhanced)),
          TryDecodeEnhancedPositionFromName(blame.name) || {}));
      }
    }

    return new BlameTree(position, await Promise.all(blames.map(pos => BlameTree.Create(dataStore, pos))));
  }

  private constructor(
    public readonly node: sourceMap.MappedPosition & { path?: JsonPath },
    public readonly blaming: BlameTree[]) { }

  public * BlameInputs(): Iterable<sourceMap.MappedPosition> {
    // report self
    if (IsUri(this.node.source) && !this.node.source.startsWith(DataStore.BaseUri)) {
      yield {
        column: this.node.column,
        line: this.node.line,
        name: this.node.name,
        source: this.node.source
      };
    }
    // recurse
    yield* From(this.blaming).SelectMany(child => child.BlameInputs()).Distinct(x => JSON.stringify(x));
  }
}

