/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { values } from '@azure-tools/linq';
import { MappedPosition } from 'source-map';
import { DataStore } from '../data-store/data-store';
import { JsonPath } from '../jsonpath';
import { EncodeEnhancedPositionInName, TryDecodeEnhancedPositionFromName } from './source-map';


export class BlameTree {
  public static async Create(dataStore: DataStore, position: MappedPosition): Promise<BlameTree> {
    const data = dataStore.ReadStrictSync(position.source);
    const blames = await data.Blame(position);

    // propagate smart position
    const enhanced = TryDecodeEnhancedPositionFromName(position.name);
    if (enhanced !== undefined) {
      for (const blame of blames) {
        blame.name = EncodeEnhancedPositionInName(blame.name, { ...enhanced, ...TryDecodeEnhancedPositionFromName(blame.name) });
      }
    }

    const s = new Array<BlameTree>();
    for (const pos of blames) {
      s.push(await BlameTree.Create(dataStore, pos));
    }

    return new BlameTree(position, s);
  }

  private constructor(
    public readonly node: MappedPosition & { path?: JsonPath },
    public readonly blaming: Array<BlameTree>) { }

  public BlameLeafs(): Array<MappedPosition> {
    const result: Array<MappedPosition> = [];

    const todos: Array<BlameTree> = [this];
    let todo: BlameTree | undefined;
    while (todo = todos.pop()) {
      // report self
      if (todo.blaming.length === 0) {
        result.push({
          column: todo.node.column,
          line: todo.node.line,
          name: todo.node.name,
          source: todo.node.source
        });
      }
      // recurse
      todos.push(...todo.blaming);
    }
    return values(result).distinct(x => JSON.stringify(x)).toArray();
  }
}
