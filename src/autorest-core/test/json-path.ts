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

  @test async "querying"() {
    assert.strictEqual(jp.nodes({ a: 1, b: 2, c: 3 }, "$..*").length, 3);
    assert.strictEqual(jp.nodes({ a: 1, b: 2, c: 3 }, "$..a").length, 1);
    assert.strictEqual(jp.nodes({ a: 1, b: 2, c: 3 }, "$.a").length, 1);
    assert.strictEqual(jp.nodes({ a: 1, b: 2, c: 3 }, "$.d").length, 0);

    assert.strictEqual(jp.paths({ a: 1, b: 2, c: 3 }, "$..*").length, 3);
    assert.strictEqual(jp.paths({ a: 1, b: 2, c: 3 }, "$..a").length, 1);
    assert.strictEqual(jp.paths({ a: 1, b: 2, c: 3 }, "$.a").length, 1);
    assert.strictEqual(jp.paths({ a: 1, b: 2, c: 3 }, "$.d").length, 0);
  }

  private roundTrip(s: string): string { return jp.stringify(jp.parse(s)); }

  @test "round trip identity"() {
    const roundTrips = (s: string) => assert.equal(this.roundTrip(s), s);
    roundTrips("$.asd.qwe[1].zxc");
    roundTrips("$[1][42][\"asd qwe\"]");
    roundTrips("$[1][\"1\"]");
  }

  @test "round trip simplification"() {
    assert.equal(this.roundTrip("$[\"asd\"]"), "$.asd");
    assert.equal(this.roundTrip("$[1][\"asd\"][\"asd qwe\"]"), "$[1].asd[\"asd qwe\"]");
  }
}