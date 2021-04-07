/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { values } from "@azure-tools/linq";
import { MappedPosition } from "source-map";
import { DataStore } from "../data-store/data-store";
import { encodeEnhancedPositionInName, tryDecodeEnhancedPositionFromName } from "./source-map";

/**
 * Represent a source mapping tree.
 */
export class BlameTree {
  public static async create(dataStore: DataStore, position: MappedPosition): Promise<BlameTree> {
    const data = dataStore.readStrictSync(position.source);
    const blames = await data.blame(position);

    // propagate smart position
    const enhanced = tryDecodeEnhancedPositionFromName(position.name);
    if (enhanced !== undefined) {
      for (const blame of blames) {
        blame.name = encodeEnhancedPositionInName(blame.name, {
          ...enhanced,
          ...tryDecodeEnhancedPositionFromName(blame.name),
        });
      }
    }

    const children = [];
    for (const pos of blames) {
      children.push(await BlameTree.create(dataStore, pos));
    }

    return new BlameTree(position, children);
  }

  private constructor(public readonly node: MappedPosition, public readonly blaming: BlameTree[]) {}

  /**
   * @returns List of mapped positions at the leaf of the tree.(i.e. the original file(s) posistions)
   */
  public getMappingLeafs(): Array<MappedPosition> {
    const result: Array<MappedPosition> = [];

    const todos: Array<BlameTree> = [this];
    let todo: BlameTree | undefined;
    while ((todo = todos.pop())) {
      // report self
      if (todo.blaming.length === 0) {
        result.push({
          column: todo.node.column,
          line: todo.node.line,
          name: todo.node.name,
          source: todo.node.source,
        });
      }
      // recurse
      todos.push(...todo.blaming);
    }
    return values(result)
      .distinct((x) => JSON.stringify(x))
      .toArray();
  }
}
