import { parseJsonPointer, serializeJsonPointer } from "./json-pointer";

describe("Json Pointer", () => {
  it("serialize simple json path", () => {
    expect(serializeJsonPointer(["path", "to", "prop"])).toEqual("/path/to/prop");
  });

  it("serialize json path with / characters", () => {
    expect(serializeJsonPointer(["path", "/this/is/here", "prop"])).toEqual("/path/~1this~1is~1here/prop");
  });

  it("serialize json path with ~ characters", () => {
    expect(serializeJsonPointer(["path", "this~is~here", "prop"])).toEqual("/path/this~0is~0here/prop");
  });

  it("parse simple json path", () => {
    expect(parseJsonPointer("/path/to/prop")).toEqual(["path", "to", "prop"]);
  });

  it("parse json path with / characters", () => {
    expect(parseJsonPointer("/path/~1this~1is~1here/prop")).toEqual(["path", "/this/is/here", "prop"]);
  });

  it("parse json path with ~ characters", () => {
    expect(parseJsonPointer("/path/this~0is~0here/prop")).toEqual(["path", "this~is~here", "prop"]);
  });
});
