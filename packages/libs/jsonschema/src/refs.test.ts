import { parseJsonRef, stringifyJsonRef } from "./refs";

describe("JsonSchema Refs", () => {
  describe("parseJsonRef", () => {
    it("parse path only when there is no file in ref", () => {
      expect(parseJsonRef("#/definitions/Foo")).toEqual({ path: "/definitions/Foo" });
    });

    it("parse file and path", () => {
      expect(parseJsonRef("bar.json#/definitions/Foo")).toEqual({ file: "bar.json", path: "/definitions/Foo" });
    });

    it("parse file only", () => {
      expect(parseJsonRef("bar.json")).toEqual({ file: "bar.json" });
    });
  });

  describe("stringifyJsonRef", () => {
    it("parse path only when there is no file in ref", () => {
      expect(stringifyJsonRef({ path: "/definitions/Foo" })).toEqual("#/definitions/Foo");
    });

    it("parse file and path", () => {
      expect(stringifyJsonRef({ file: "bar.json", path: "/definitions/Foo" })).toEqual("bar.json#/definitions/Foo");
    });

    it("parse file only", () => {
      expect(stringifyJsonRef({ file: "bar.json" })).toEqual("bar.json");
    });
  });
});
