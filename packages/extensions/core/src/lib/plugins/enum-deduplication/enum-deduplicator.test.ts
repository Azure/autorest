import { createDataHandle } from "@autorest/test-utils";
import * as oai3 from "@azure-tools/openapi";
import { JsonType } from "@azure-tools/openapi";
import { EnumDeduplicator } from "./enum-deduplicator";

async function runEnumDeduplicator(data: Partial<oai3.Model>): Promise<oai3.Model> {
  const source = createDataHandle(JSON.stringify(data));
  const deduplicator = new EnumDeduplicator(source);
  return await deduplicator.getOutput();
}

describe("EnumDeduplicator", () => {
  it("keeps distinct enums", async () => {
    const fooEnum = {
      "x-ms-metadata": { name: "Foo" },
      type: JsonType.String,
      enum: ["one", "two"],
    };

    const barEnum = {
      "x-ms-metadata": { name: "Bar" },
      type: JsonType.String,
      enum: ["three", "four", "five"],
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

  // Regression for https://github.com/Azure/autorest/issues/4294
  // where if x-ms-enum was passed it would use x-ms-enum.name for the name reglardless of it defined.
  it("keeps distinct enums if x-ms-enum is passed", async () => {
    const fooEnum = {
      "x-ms-metadata": { name: "Foo" },
      type: JsonType.String,
      enum: ["one", "two"],
      "x-ms-enum": { modelAsString: false },
    };

    const barEnum = {
      "x-ms-metadata": { name: "Bar" },
      type: JsonType.String,
      enum: ["three", "four", "five"],
      "x-ms-enum": { modelAsString: false },
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
      type: JsonType.String,
      enum: ["one", "two"],
    };

    const fooEnum2 = {
      "x-ms-metadata": { name: "Foo", apiVersions: "1.1.0" },
      type: JsonType.String,
      enum: ["three", "four", "five"],
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
      enum: ["one", "two", "three", "four", "five"],
      type: "string",
      "x-ms-metadata": { apiVersions: "1.0.0", name: "Foo" },
    });
  });

  it("merge x- properties of enums", async () => {
    const fooEnum1 = {
      "x-ms-metadata": { name: "Foo", apiVersions: "1.0.0" },
      type: JsonType.String,
      enum: ["one", "two"],
      "x-namespace": "My.Service",
    };

    const fooEnum2 = {
      "x-ms-metadata": { name: "Foo", apiVersions: "1.1.0" },
      type: JsonType.String,
      enum: ["one", "two"],
      "x-namespace": "My.Service",
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
      enum: ["one", "two"],
      type: "string",
      "x-ms-metadata": { apiVersions: "1.0.0", name: "Foo" },
      "x-namespace": "My.Service",
    });
  });

  describe("enum referencing other enums", () => {
    const fooEnum = {
      "x-ms-metadata": { name: "Foo" },
      type: JsonType.String,
      enum: ["one", "two"],
    };

    const barEnum = {
      "x-ms-metadata": { name: "Bar" },
      type: JsonType.String,
      enum: ["three", "four", "five"],
      allOf: [{ $ref: "#/components/schemas/schemas:0" }],
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
        allOf: [{ $ref: "#/components/schemas/Foo" }],
        enum: ["three", "four", "five"],
        type: "string",
        "x-ms-metadata": { name: "Bar" },
      });
    });
  });

  describe("2 boolean enums with same name", () => {
    const falseEnum: oai3.Schema = {
      "x-ms-metadata": { apiVersions: ["2021-01-01"] },
      type: "boolean",
      enum: [false],
      "x-ms-enum": {
        name: "FalseConst",
        modelAsString: false,
      },
    };

    it("combine into 1 keeping type: boolean", async () => {
      const result = await runEnumDeduplicator({
        components: {
          schemas: {
            "schemas:0": { ...falseEnum },
            "schemas:1": { ...falseEnum },
          },
        },
      });
      expect(Object.keys(result.components?.schemas ?? [])).toHaveLength(1);
      expect(result.components?.schemas?.["FalseConst"]).toEqual({
        enum: [false],
        type: "boolean",
        "x-ms-enum": { modelAsString: false, name: "FalseConst" },
        "x-ms-metadata": { apiVersions: ["2021-01-01"] },
      });
    });
  });

  describe("2 enums with format with same name", () => {
    const falseEnum: oai3.Schema = {
      "x-ms-metadata": { apiVersions: ["2021-01-01"] },
      type: "string",
      format: "decimal",
      enum: [123],
      "x-ms-enum": {
        name: "NumConst",
        modelAsString: false,
      },
    };

    it("combine into 1 keeping format property", async () => {
      const result = await runEnumDeduplicator({
        components: {
          schemas: {
            "schemas:0": { ...falseEnum },
            "schemas:1": { ...falseEnum },
          },
        },
      });
      expect(Object.keys(result.components?.schemas ?? [])).toHaveLength(1);
      expect(result.components?.schemas?.["NumConst"]).toEqual({
        enum: [123],
        type: "string",
        format: "decimal",
        "x-ms-enum": { modelAsString: false, name: "NumConst" },
        "x-ms-metadata": { apiVersions: ["2021-01-01"] },
      });
    });
  });
});
