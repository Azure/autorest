import { createDataHandle } from "@autorest/test-utils";
import { EnumDeduplicator } from "./enum-deduplicator";
import * as oai3 from "@azure-tools/openapi";
import { JsonType } from "@azure-tools/openapi";

async function runEnumDeduplicator(data: Partial<oai3.Model>): Promise<oai3.Model> {
  const source = createDataHandle(JSON.stringify(data));
  const deduplicator = new EnumDeduplicator(source);
  return await deduplicator.getOutput();
}

describe("EnumDeduplicator", () => {
  it("keeps distinct enums", async () => {
    const fooEnum = {
      "x-ms-metadata": { name: "Foo" },
      "type": JsonType.String,
      "enum": ["one", "two"],
    };

    const barEnum = {
      "x-ms-metadata": { name: "Bar" },
      "type": JsonType.String,
      "enum": ["three", "four", "five"],
    };

    const result = await runEnumDeduplicator({
      components: {
        schemas: {
          "schemas:0": fooEnum,
          "schemas:1": barEnum,
        },
      },
    });

    // It should have use the name of the enum as the schema key.
    expect(result.components?.schemas).toHaveProperty("Foo");
    expect(result.components?.schemas).toHaveProperty("Bar");

    expect(result.components?.schemas?.["Foo"]).toEqual(fooEnum);
    expect(result.components?.schemas?.["Bar"]).toEqual(barEnum);
  });

  it("merge enums with same name", async () => {
    const fooEnum1 = {
      "x-ms-metadata": { name: "Foo", apiVersions: "1.0.0" },
      "type": JsonType.String,
      "enum": ["one", "two"],
    };

    const fooEnum2 = {
      "x-ms-metadata": { name: "Foo", apiVersions: "1.1.0" },
      "type": JsonType.String,
      "enum": ["three", "four", "five"],
    };

    const result = await runEnumDeduplicator({
      components: {
        schemas: {
          "schemas:0": fooEnum1,
          "schemas:1": fooEnum2,
        },
      },
    });

    expect(result.components?.schemas).toHaveProperty("Foo");
    expect(result.components?.schemas?.["Foo"]).toEqual({
      "enum": ["one", "two", "three", "four", "five"],
      "type": "string",
      "x-ms-metadata": { apiVersions: "1.0.0", name: "Foo" },
    });
  });

  describe("enum referencing other enums", () => {
    const fooEnum = {
      "x-ms-metadata": { name: "Foo" },
      "type": JsonType.String,
      "enum": ["one", "two"],
    };

    const barEnum = {
      "x-ms-metadata": { name: "Bar" },
      "type": JsonType.String,
      "enum": ["three", "four", "five"],
      "allOf": [{ $ref: "#/components/schemas/schemas:0" }],
    };

    it("updates the $ref to the renamed enum key", async () => {
      const result = await runEnumDeduplicator({
        components: {
          schemas: {
            "schemas:0": fooEnum,
            "schemas:1": barEnum,
          },
        },
      });
      expect(result.components?.schemas?.["Foo"]).toEqual(fooEnum);
      expect(result.components?.schemas?.["Bar"]).toEqual({
        "allOf": [{ $ref: "#/components/schemas/Foo" }],
        "enum": ["three", "four", "five"],
        "type": "string",
        "x-ms-metadata": { name: "Bar" },
      });
    });
  });
});
