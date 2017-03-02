import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import * as jsonpath from "../lib/approved-imports/jsonpath";

@suite class JsonPath {
  private roundTrip(s: string) { return jsonpath.stringify(jsonpath.parse(s)); }

  @test "round trip identity"() {
    const roundTrips = (s: string) => assert.equal(s, this.roundTrip(s));
    roundTrips("$.asd.qwe[1].zxc");
    roundTrips("$[1][42][\"asd qwe\"]");
    roundTrips("$[1][\"1\"]");
  }

  @test "round trip simplification"() {
    assert.equal("$.asd", this.roundTrip("$[\"asd\"]"));
    assert.equal("$[1].asd[\"asd qwe\"]", this.roundTrip("$[1][\"asd\"][\"asd qwe\"]"));
  }
}