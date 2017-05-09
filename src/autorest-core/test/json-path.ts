/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
// polyfills for language support 
require("../lib/polyfill.min.js");

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

    assert.strictEqual(jp.paths({ x: { $ref: "x" }, y: { $re: "x" } }, "$[?(@.$ref)]").length, 1);
    assert.strictEqual(jp.paths({ a: { x: { $ref: "x" } }, b: { x: { $re: "x" } } }, "$..*[?(@.$ref)]").length, 1);
  }

  @test async "querying features"() {
    const obj = { a: 1, b: 2, c: 3, d: { a: [1, 2, 3], b: 2, c: 3 } };
    assert.strictEqual(jp.nodes(obj, "$.*").length, 4);
    assert.strictEqual(jp.nodes(obj, "$.*.*").length, 3);
    assert.strictEqual(jp.nodes(obj, "$..*.*").length, 6);
    assert.strictEqual(jp.nodes(obj, "$..*").length, 10);
    assert.strictEqual(jp.nodes(obj, "$..[*]").length, 10);
    assert.strictEqual(jp.nodes(obj, "$..['d']").length, 1);
    assert.strictEqual(jp.nodes(obj, "$..d").length, 1);
    assert.strictEqual(jp.nodes(obj, "$..[2]").length, 1);
    //assert.strictEqual(jp.nodes(obj, "$..[(@.length - 1)]").length, 1);
    //assert.strictEqual(jp.nodes(obj, "$..[(1 + 1)]").length, 1);
  }

  private roundTrip(s: string): string { return jp.stringify(jp.parse(s)); }

  @test "round trip identity"() {
    const roundTrips = (s: string) => assert.equal(this.roundTrip(s), s);
    roundTrips("$.asd.qwe[1].zxc");
    roundTrips("$[1][42][\"asd qwe\"]");
    roundTrips("$[1][\"1\"]");
  }

  @test "round trip simplification"() {
    assert.equal(this.roundTrip("$[\"definitely\"][\"add\"][\"more\"][\"cowbell\"]"), "$.definitely.add.more.cowbell");
    assert.equal(this.roundTrip("$[1][\"even\"][\"more cowbell\"]"), "$[1].even[\"more cowbell\"]");
  }
}