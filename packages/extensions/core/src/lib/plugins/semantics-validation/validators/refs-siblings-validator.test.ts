import oai3 from "@azure-tools/openapi";
import { SemanticErrorCodes } from "../types";
import { validateDiscriminator } from "./discriminator-validator";
import { validateRefsSiblings } from "./refs-siblings-validator";

const baseModel: oai3.Model = {
  info: {
    title: "Semantic Validation Unit Tests",
    version: "1.0",
  },
  openApi: "3.0.0",
  paths: {},
};

describe("Semantic Validation: $ref siblings", () => {
  it("returns warnings when using property next to $ref NOT allowed", () => {
    const errors = validateRefsSiblings({
      ...baseModel,
      components: {
        schemas: {
          Pet: {
            properties: {
              foo: {
                $ref: "#/components/schemas/Bar",
                type: "object",
              },
            },
          },
        },
      },
    });
    expect(errors).toEqual([
      {
        level: "warn",
        code: SemanticErrorCodes.IgnoredPropertyNextToRef,
        message:
          "Sibling values alongside $ref will be ignored. See https://github.com/Azure/autorest/blob/master/docs/openapi/howto/$ref-siblings.md for allowed values",
        params: { keys: ["type"] },
        path: ["components", "schemas", "Pet", "properties", "foo"],
      },
    ]);
  });

  it("returns no arnings when using property next to $ref that is allowed", () => {
    const errors = validateRefsSiblings({
      ...baseModel,
      components: {
        schemas: {
          Pet: {
            properties: {
              foo: {
                $ref: "#/components/schemas/Bar",
                description: "This is a description for the property",
              },
            },
          },
        },
      },
    });
    expect(errors).toHaveLength(0);
  });

  it("returns no warning when using a custom extension next to $ref", () => {
    const errors = validateRefsSiblings({
      ...baseModel,
      components: {
        schemas: {
          Pet: {
            properties: {
              foo: {
                "$ref": "#/components/schemas/Bar",
                "x-custom": "This is a description for the property",
              },
            },
          },
        },
      },
    });
    expect(errors).toHaveLength(0);
  });
});
