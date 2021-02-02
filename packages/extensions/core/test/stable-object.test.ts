/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import assert from "assert";
import { NewEmptyObject } from "@azure-tools/datastore";

describe("StableObject", () => {
  it("insert order preservation", () => {
    const o = NewEmptyObject();
    o[3] = 0;
    o[1] = 1;
    o["asd"] = 2;
    o[2] = 3;
    o["zyx"] = 4;
    o["qwe"] = 5;
    o[-1] = 6;
    o[10] = 7;
    o[7] = 8;
    const keys = Object.getOwnPropertyNames(o);
    assert.strictEqual(keys.length, 9);
    for (let i = 0; i < 9; ++i) {
      assert.strictEqual(o[keys[i]], i);
    }
  });

  it("mutation order preservation", () => {
    const o = NewEmptyObject();
    o[8] = "a";
    o[7] = "a";
    o[6] = "a";
    o[5] = "a";
    o[4] = "a";
    o[3] = "a";
    o[2] = "a";
    o[1] = "a";
    o[0] = "a";

    o[4] = "b";
    o[3] = "b";
    o[2] = "b";
    o[6] = "b";
    o[3] = "b";
    o[8] = "b";

    const keys = Object.getOwnPropertyNames(o);
    assert.strictEqual(keys.length, 9);
    for (let i = 0; i < 9; ++i) {
      assert.strictEqual(keys[i], `${8 - i}`);
    }
  });

  it("delete order preservation", () => {
    const o = NewEmptyObject();
    o[3] = 0;
    o[1] = 1;
    o["asd"] = 2;
    o["cowbell"] = "delete me";
    o[2] = 3;
    o["zyx"] = 4;
    o["qwe"] = 5;
    o[5] = "delete me";
    o[-1] = 6;
    o[10] = 7;
    o["more"] = "delete me";
    o[7] = 8;

    delete o[5];
    delete o["more"];
    delete o["cowbell"];

    const keys = Object.getOwnPropertyNames(o);
    assert.strictEqual(keys.length, 9);
    for (let i = 0; i < 9; ++i) {
      assert.strictEqual(o[keys[i]], i);
    }
  });
});
