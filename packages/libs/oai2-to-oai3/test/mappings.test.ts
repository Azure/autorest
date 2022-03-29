import { serializeJsonPointer } from "@azure-tools/json";
import { OpenAPI2Document } from "@azure-tools/openapi/v2";
import { ConverterLogger, Oai2ToOai3 } from "../src";

const defaultOpenApi2 = {
  swagger: "2.0",
  paths: {},
  definitions: {},
} as const;

const logger: ConverterLogger = {
  trackError: jest.fn(),
  trackWarning: jest.fn(),
};

const defaultMappings = new Set(["", "/swagger", "/paths"]);
async function convert(spec: Partial<OpenAPI2Document>) {
  const doc = { ...defaultOpenApi2, ...spec };
  const converter = new Oai2ToOai3(logger, "source.json", doc);
  await converter.convert();
  return converter.mappings
    .map((x) => ({
      original: serializeJsonPointer(x.original),
      generated: serializeJsonPointer(x.generated),
    }))
    .filter(({ original }) => !defaultMappings.has(original));
}

describe("Mappings", () => {
  it("create mappings for definitions", async () => {
    const mappings = await convert({
      definitions: {
        Foo: {
          type: "object",
          properties: {
            name: {
              type: "string",
            },
          },
        },
      },
    });
    expect(mappings).toEqual([
      { generated: "/components/schemas", original: "/definitions" },
      { generated: "/components/schemas/Foo", original: "/definitions/Foo" },
      { generated: "/components/schemas/Foo/type", original: "/definitions/Foo/type" },
      { generated: "/components/schemas/Foo/properties", original: "/definitions/Foo/properties" },
      { generated: "/components/schemas/Foo/properties/name", original: "/definitions/Foo/properties/name" },
      { generated: "/components/schemas/Foo/properties/name/type", original: "/definitions/Foo/properties/name/type" },
    ]);
  });
});
