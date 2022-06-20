/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { uniqBy } from "lodash";
import { MappedPosition } from "source-map";
import { DataStore } from "../data-store/data-store";
import { PathMappedPosition } from "./path-source-map";

/**
 * Represent a source mapping tree.
 */
export class BlameTree {
  public static async create(dataStore: DataStore, position: MappedPosition | PathMappedPosition): Promise<BlameTree> {
    const data = dataStore.readStrictSync(position.source);

    const blames = await data.blame(position as any);
    const children = [];
    for (const pos of blames) {
      children.push(await BlameTree.create(dataStore, pos));
    }

    return new BlameTree(position, children);
  }

  private constructor(
    public readonly node: MappedPosition | PathMappedPosition,
    public readonly blaming: BlameTree[],
  ) {}

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
        if ("line" in todo.node) {
          result.push({
            column: todo.node.column,
            line: todo.node.line,
            source: todo.node.source,
          });
        }
      }
      // recurse
      todos.push(...todo.blaming);
    }

    // Return distrinct values.
    return uniqBy(result, (x) => JSON.stringify(x));
  }
}
