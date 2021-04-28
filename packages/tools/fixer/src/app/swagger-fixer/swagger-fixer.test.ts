import { fixSwaggerMissingType } from ".";
import { FixCode } from "../types";

const ObjectMissingType = Object.freeze({
  properties: {
    type: "string",
  },
});

describe("Swagger fixer", () => {
  describe("Fix misisng type:object", () => {
    it("fix on a named definitions", () => {
      const result = fixSwaggerMissingType({
        definitions: {
          Foo: ObjectMissingType,
        },
      });

      expect(result.spec).toEqual({
        definitions: {
          Foo: { ...ObjectMissingType, type: "object" },
        },
      });

      expect(result.fixes).toHaveLength(1);
      expect(result.fixes[0]).toEqual({
        code: FixCode.MissingTypeObject,
        message: "Schema is defining properties but is missing type: object.",
        path: ["definitions", "Foo"],
      });
    });

    it("fix on a nested definitions in properties", () => {
      const result = fixSwaggerMissingType({
        definitions: {
          Foo: {
            type: "object",
            properties: {
              Bar: ObjectMissingType,
            },
          },
        },
      });

      expect(result.spec).toEqual({
        definitions: {
          Foo: {
            type: "object",
            properties: {
              Bar: { ...ObjectMissingType, type: "object" },
            },
          },
        },
      });

      expect(result.fixes).toHaveLength(1);
      expect(result.fixes[0]).toEqual({
        code: FixCode.MissingTypeObject,
        message: "Schema is defining properties but is missing type: object.",
        path: ["definitions", "Foo", "properties", "Bar"],
      });
    });
    it("fix on a nested definitions in allOf", () => {
      const result = fixSwaggerMissingType({
        definitions: {
          Foo: {
            type: "object",
            allOf: [ObjectMissingType],
          },
        },
      });

      expect(result.spec).toEqual({
        definitions: {
          Foo: {
            type: "object",
            allOf: [{ ...ObjectMissingType, type: "object" }],
          },
        },
      });

      expect(result.fixes).toHaveLength(1);
      expect(result.fixes[0]).toEqual({
        code: FixCode.MissingTypeObject,
        message: "Schema is defining properties but is missing type: object.",
        path: ["definitions", "Foo", "allOf", "0"],
      });
    });
  });
});
