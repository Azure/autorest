/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { matches } from "@azure-tools/datastore";
import { mergeOverwriteOrAppend } from "./merging";

describe("Merging", () => {
  describe("mergeOverwriteOrAppend", () => {
    it("keeps the higher priority value if it is a primitive", () => {
      expect(mergeOverwriteOrAppend(1, 2, { concatListPathFilter: (_) => false })).toEqual(1);
    });

    it("creates an array with both value if concat filter is true for the given path", () => {
      expect(mergeOverwriteOrAppend(1, 2, { concatListPathFilter: (_) => true })).toEqual([1, 2]);
    });

    it("creates an array with both values if any value is already an array", () => {
      expect(mergeOverwriteOrAppend(1, [2], { concatListPathFilter: (_) => false })).toEqual([1, 2]);
      expect(mergeOverwriteOrAppend(1, [2], { concatListPathFilter: (_) => true })).toEqual([1, 2]);
      expect(mergeOverwriteOrAppend([1], 2, { concatListPathFilter: (_) => false })).toEqual([1, 2]);
      expect(mergeOverwriteOrAppend([1], 2, { concatListPathFilter: (_) => true })).toEqual([1, 2]);
    });

    it("creates an array with both values if they are already arrays", () => {
      expect(mergeOverwriteOrAppend([1], [2], { concatListPathFilter: (_) => false })).toEqual([1, 2]);
      expect(mergeOverwriteOrAppend([1], [2], { concatListPathFilter: (_) => true })).toEqual([1, 2]);
    });

    it("keeps the higher priority properties first for an object", () => {
      expect(mergeOverwriteOrAppend({ a: 1, b: 1 }, { a: 2, b: 2 }, { concatListPathFilter: (_) => false })).toEqual({
        a: 1,
        b: 1,
      });
    });

    it("combines values into arrays if requested", () => {
      expect(mergeOverwriteOrAppend({ a: 1, b: 1 }, { a: 2, b: 2 }, { concatListPathFilter: (_) => true })).toEqual({
        a: [1, 2],
        b: [1, 2],
      });
    });

    it("combines arrays higher priority values first by default", () => {
      expect(mergeOverwriteOrAppend({ a: [1, 2] }, { a: [3, 4] })).toEqual({
        a: [1, 2, 3, 4],
      });
    });

    it("combines arrays lower priority values first if requested", () => {
      expect(mergeOverwriteOrAppend({ a: [1, 2] }, { a: [3, 4] }, { arrayMergeStrategy: "low-pri-first" })).toEqual({
        a: [3, 4, 1, 2],
      });
    });

    it("combines values into arrays only for the requested path", () => {
      expect(
        mergeOverwriteOrAppend({ a: 1, b: 1 }, { a: 2, b: 2 }, { concatListPathFilter: (p) => matches("$.a", p) }),
      ).toEqual({
        a: [1, 2],
        b: 1,
      });
      expect(
        mergeOverwriteOrAppend({ a: 1, b: 1 }, { a: 2, b: 2 }, { concatListPathFilter: (p) => matches("$.b", p) }),
      ).toEqual({
        a: 1,
        b: [1, 2],
      });
    });

    it("combine a complex object", () => {
      const value = mergeOverwriteOrAppend(
        { a: 1, b: 1, c: { a: 1, b: { a: 1, b: 1 } }, d: [{ a: 1, b: 1 }] },
        { a: 2, bx: 2, c: { ax: 2, b: { c: 2 } }, d: [{ a: 2, b: 2 }] },
      );
      expect(value).toEqual({
        a: 1,
        b: 1,
        bx: 2,
        c: { a: 1, ax: 2, b: { a: 1, b: 1, c: 2 } },
        d: [
          { a: 1, b: 1 },
          { a: 2, b: 2 },
        ],
      });
    });
  });
});
