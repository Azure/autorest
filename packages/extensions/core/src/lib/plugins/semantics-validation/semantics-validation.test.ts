import { SemanticErrorCodes, validateDiscriminator } from "./semantics-validation";
import oai3 from "@azure-tools/openapi";

const baseModel: oai3.Model = {
  info: {
    title: "Semantic Validation Unit Tests",
    version: "1.0",
  },
  openApi: "3.0.0",
  paths: {},
};

describe("Semantic Validation", () => {
  describe("discriminator validation", () => {
    it("resolve error if discrminator property is not required", () => {
      const errors = validateDiscriminator({
        ...baseModel,
        components: {
          schemas: {
            Pet: {
              discriminator: {
                propertyName: "type",
              },
            },
          },
        },
      });
      expect(errors).toEqual([
        {
          code: SemanticErrorCodes.DiscriminatorNotRequired,
          message: "Discriminator must be a required property.",
          params: { discriminator: { propertyName: "type" } },
          path: ["components", "schemas", "Pet"],
        },
      ]);
    });

    it("resolve no error if discrminator property is required", () => {
      const errors = validateDiscriminator({
        ...baseModel,
        components: {
          schemas: {
            Pet: {
              required: ["type"],
              discriminator: {
                propertyName: "type",
              },
            },
          },
        },
      });
      expect(errors).toHaveLength(0);
    });

    it("ignores validation if discriminator type use oneOf", () => {
      const errors = validateDiscriminator({
        ...baseModel,
        components: {
          schemas: {
            Pet: {
              discriminator: {
                propertyName: "type",
              },
              oneOf: [{ $ref: "#/components/schemas/Cat" }],
            },
          },
        },
      });
      expect(errors).toHaveLength(0);
    });
  });
});
