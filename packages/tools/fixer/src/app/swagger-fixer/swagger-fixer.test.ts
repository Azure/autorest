import { FixCode } from "../types";
import { fixSwaggerMissingType } from "./swagger-fixer";

const ObjectMissingType = Object.freeze({
  properties: {
    type: "string",
  },
});

describe("Swagger fixer", () => {
  describe("Fix misisng type:object", () => {
    it("fix on a named definitions", () => {
      const result = fixSwaggerMissingType("test.json", {
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
        filename: "test.json",
        path: ["definitions", "Foo"],
      });
    });

    it("fix on a named definitions with additional properties", () => {
      const result = fixSwaggerMissingType("test.json", {
        definitions: {
          Foo: { additionalProperties: true },
        },
      });

      expect(result.spec).toEqual({
        definitions: {
          Foo: { additionalProperties: true, type: "object" },
        },
      });

      expect(result.fixes).toHaveLength(1);
      expect(result.fixes[0]).toEqual({
        code: FixCode.MissingTypeObject,
        message: "Schema is defining properties but is missing type: object.",
        filename: "test.json",
        path: ["definitions", "Foo"],
      });
    });

    it("fix on a nested definitions in properties", () => {
      const result = fixSwaggerMissingType("test.json", {
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
        filename: "test.json",
        path: ["definitions", "Foo", "properties", "Bar"],
      });
    });
    it("fix on a nested definitions in allOf", () => {
      const result = fixSwaggerMissingType("test.json", {
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
        filename: "test.json",
        path: ["definitions", "Foo", "allOf", "0"],
      });
    });
  });
});
