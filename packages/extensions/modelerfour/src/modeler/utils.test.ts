import { Operation, Parameter, Schema, SchemaType } from "@autorest/codemodel";
import { isContentTypeParameterDefined } from "./utils";

const stringSchema = new Schema("string", "A String", SchemaType.Any);

describe("Modelerfour utils", () => {
  describe("isContentTypeParameterDefined()", () => {
    it("returns false if there is a no parameter in the operation", () => {
      const operation = new Operation("op-1", "Test operation 1", {});
      expect(isContentTypeParameterDefined(operation)).toBe(false);
    });

    it("returns false if there is a no parameter with the content-type name in the operation", () => {
      const operation = new Operation("op-1", "Test operation 1", {
        parameters: [
          new Parameter("OtherParm", "OtherParam header", stringSchema, {
            language: { default: { serializedName: "Other-Param" } },
            protocol: { http: { in: "header" } },
          }),
        ],
      });
      expect(isContentTypeParameterDefined(operation)).toBe(false);
    });

    it("returns false if there is a a parameter with the content-type name but is not a header", () => {
      const operation = new Operation("op-1", "Test operation 1", {
        parameters: [
          new Parameter("ContentTypeQuery", "Content type query", stringSchema, {
            language: { default: { serializedName: "Content-Type" } },
            protocol: { http: { in: "query" } },
          }),
        ],
      });
      expect(isContentTypeParameterDefined(operation)).toBe(false);
    });

    it("returns true if there is a parameter with the serialized Content-Type", () => {
      const operation = new Operation("op-1", "Test operation 1", {
        parameters: [
          new Parameter("ContentType", "Content type header", stringSchema, {
            language: { default: { serializedName: "Content-Type" } },
            protocol: { http: { in: "header" } },
          }),
        ],
      });
      expect(isContentTypeParameterDefined(operation)).toBe(true);
    });

    it("returns true if there is a parameter with the serialized Content-Type but different casing", () => {
      const operation = new Operation("op-1", "Test operation 1", {
        parameters: [
          new Parameter("ContentType", "Content type header", stringSchema, {
            language: { default: { serializedName: "conTEnt-TyPe" } },
            protocol: { http: { in: "header" } },
          }),
        ],
      });
      expect(isContentTypeParameterDefined(operation)).toBe(true);
    });
  });
});
