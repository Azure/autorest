import * as jp from "./json-path";

describe("JsonPath", () => {
  it("IsPrefix", () => {
    expect(jp.IsPrefix(jp.parse("$.a.b.c"), jp.parse("$.a.b.c.d"))).toEqual(true);
    expect(jp.IsPrefix(jp.parse("$.a.b.c"), jp.parse("$.a.b.c"))).toEqual(true);
    expect(jp.IsPrefix(jp.parse("$.a.b.c"), jp.parse("$.a.b"))).toEqual(false);
  });

  it("matches", async () => {
    expect(jp.matches("$..*", jp.parse("$.a.b.c"))).toEqual(true);
    expect(jp.matches("$..c", jp.parse("$.a.b.c"))).toEqual(true);
    expect(jp.matches("$..b", jp.parse("$.a.b.c"))).toEqual(false);
    expect(jp.matches("$.a.b.c", jp.parse("$.a.b.c"))).toEqual(true);
    expect(jp.matches("$.a.b", jp.parse("$.a.b.c"))).toEqual(false);
    expect(jp.matches("$.a..*", jp.parse("$.a.b.c"))).toEqual(true);
    expect(jp.matches("$.a.b.c.d", jp.parse("$.a.b.c"))).toEqual(false);
  });

  it("querying", () => {
    expect(jp.nodes({ a: 1, b: 2, c: 3 }, "$..*").length).toEqual(3);
    expect(jp.nodes({ a: 1, b: 2, c: 3 }, "$..a").length).toEqual(1);
    expect(jp.nodes({ a: 1, b: 2, c: 3 }, "$.a").length).toEqual(1);
    expect(jp.nodes({ a: 1, b: 2, c: 3 }, "$.d").length).toEqual(0);

    expect(jp.paths({ a: 1, b: 2, c: 3 }, "$..*").length).toEqual(3);
    expect(jp.paths({ a: 1, b: 2, c: 3 }, "$..a").length).toEqual(1);
    expect(jp.paths({ a: 1, b: 2, c: 3 }, "$.a").length).toEqual(1);
    expect(jp.paths({ a: 1, b: 2, c: 3 }, "$.d").length).toEqual(0);

    expect(jp.paths({ x: { $ref: "x" }, y: { $re: "x" } }, "$[?(@.$ref)]").length).toEqual(1);
    expect(jp.paths({ a: { x: { $ref: "x" } }, b: { x: { $re: "x" } } }, "$..*[?(@.$ref)]").length).toEqual(1);
  });

  it("querying features", () => {
    const obj = { a: 1, b: 2, c: 3, d: { a: [1, 2, 3], b: 2, c: 3 } };
    expect(jp.nodes(obj, "$.*").length).toEqual(4);
    expect(jp.nodes(obj, "$.*.*").length).toEqual(3);
    expect(jp.nodes(obj, "$..*.*").length).toEqual(6);
    expect(jp.nodes(obj, "$..*").length).toEqual(10);
    expect(jp.nodes(obj, "$..[*]").length).toEqual(10);
    expect(jp.nodes(obj, "$..['d']").length).toEqual(1);
    expect(jp.nodes(obj, "$..d").length).toEqual(1);
    expect(jp.nodes(obj, "$..[2]").length).toEqual(1);
    expect(jp.nodes(obj, "$..[?(@.a[2] === 3)]").length).toEqual(1);
    expect(jp.nodes(obj, "$..[?(@.a.reduce((x,y) => x+y, 0) === 6)]").length).toEqual(1);
  });
});
