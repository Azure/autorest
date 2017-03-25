/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import * as jp from "../lib/ref/jsonpath";

@suite class JsonPath {
  @test async "IsPrefix"() {
    assert.strictEqual(jp.IsPrefix(jp.parse("$.a.b.c"), jp.parse("$.a.b.c.d")), true);
    assert.strictEqual(jp.IsPrefix(jp.parse("$.a.b.c"), jp.parse("$.a.b.c")), true);
    assert.strictEqual(jp.IsPrefix(jp.parse("$.a.b.c"), jp.parse("$.a.b")), false);
  }

  @test async "matches"() {
    assert.strictEqual(jp.matches("$..*", jp.parse("$.a.b.c")), true);
    assert.strictEqual(jp.matches("$..c", jp.parse("$.a.b.c")), true);
    assert.strictEqual(jp.matches("$..b", jp.parse("$.a.b.c")), false);
    assert.strictEqual(jp.matches("$.a.b.c", jp.parse("$.a.b.c")), true);
    assert.strictEqual(jp.matches("$.a.b", jp.parse("$.a.b.c")), false);
    assert.strictEqual(jp.matches("$.a..*", jp.parse("$.a.b.c")), true);
    assert.strictEqual(jp.matches("$.a.b.c.d", jp.parse("$.a.b.c")), false);
  }

  // TODO
}