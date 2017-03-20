import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import * as jsonpath from "../lib/ref/jsonpath";

@suite class JsonPath {
  private roundTrip(s: string) { return jsonpath.stringify(jsonpath.parse(s)); }

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