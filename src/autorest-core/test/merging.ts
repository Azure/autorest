/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { matches } from "../lib/ref/jsonpath";
import { MergeOverwrite } from "../lib/source-map/merging";

@suite class Merging {
  @test async "MergeOverwrite"() {
    // list overwriting and concatenation
    assert.deepStrictEqual(MergeOverwrite(1, 2, _ => false), 1);
    assert.deepStrictEqual(MergeOverwrite(1, 2, _ => true), [1, 2]);
    assert.deepStrictEqual(MergeOverwrite(1, [2], _ => false), 1);
    assert.deepStrictEqual(MergeOverwrite(1, [2], _ => true), [1, 2]);
    assert.deepStrictEqual(MergeOverwrite([1], 2, _ => false), [1]);
    assert.deepStrictEqual(MergeOverwrite([1], 2, _ => true), [1, 2]);
    assert.deepStrictEqual(MergeOverwrite([1], [2], _ => false), [1]);
    assert.deepStrictEqual(MergeOverwrite([1], [2], _ => true), [1, 2]);

    // picky concatenation
    assert.deepStrictEqual(MergeOverwrite({ a: 1, b: 1 }, { a: 2, b: 2 }, _ => false), { a: 1, b: 1 });
    assert.deepStrictEqual(MergeOverwrite({ a: 1, b: 1 }, { a: 2, b: 2 }, _ => true), { a: [1, 2], b: [1, 2] });
    assert.deepStrictEqual(MergeOverwrite({ a: 1, b: 1 }, { a: 2, b: 2 }, p => matches("$.a", p)), { a: [1, 2], b: 1 });
    assert.deepStrictEqual(MergeOverwrite({ a: 1, b: 1 }, { a: 2, b: 2 }, p => matches("$.b", p)), { a: 1, b: [1, 2] });

    // complicated object
    assert.deepStrictEqual(MergeOverwrite(
      { a: 1, b: 1, c: { a: 1, b: { a: 1, b: 1 } }, d: [{ a: 1, b: 1 }] },
      { a: 2, bx: 2, c: { ax: 2, b: { c: 2 } }, d: [{ a: 2, b: 2 }] }),
      { a: 1, b: 1, bx: 2, c: { a: 1, ax: 2, b: { a: 1, b: 1, c: 2 } }, d: [{ a: 1, b: 1 }] });
  }
}