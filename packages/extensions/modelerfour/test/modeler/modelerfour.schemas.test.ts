import { JsonType } from "@azure-tools/openapi";
import assert from "assert";
import { ChoiceSchema, ConstantSchema, SealedChoiceSchema } from "../../../../libs/codemodel/dist/exports";
import { addSchema, createTestSpec, findByName } from "../utils";
import { runModeler } from "./modelerfour-utils";

describe("Modelerfour.Schemas", () => {
  describe("additionalProperties", () => {
    it("support reference to itself(circular dependency", async () => {
      const spec = createTestSpec();

      addSchema(spec, "SelfRefSchema", {
        additionalProperties: {
          $ref: "#/components/schemas/SelfRefSchema",
        },
      });

      const codeModel = await runModeler(spec);

      const schema = codeModel.schemas.dictionaries?.[0];
      expect(schema).not.toBeNull();
      expect(schema?.language.default.name).toEqual("SelfRefSchema");
      expect(schema?.elementType).toEqual(schema);
    });

    it("additionalProperties=true should produce element of type Any", async () => {
      const spec = createTestSpec();

      addSchema(spec, "AdditionalPropertiesTrue", {
        additionalProperties: true,
      });

      const codeModel = await runModeler(spec);
      const schema = codeModel.schemas.dictionaries?.[0];
      assert(schema);
      expect(schema.language.default.name).toEqual("AdditionalPropertiesTrue");
      expect(schema.elementType).toEqual(codeModel.schemas.any?.[0]);
    });

    it("additionalProperties={} should produce element of type Any", async () => {
      const spec = createTestSpec();

      addSchema(spec, "AdditionalPropertiesEmpty", {
        additionalProperties: {},
      });

      const codeModel = await runModeler(spec);
      const schema = codeModel.schemas.dictionaries?.[0];
      assert(schema);
      expect(schema.language.default.name).toEqual("AdditionalPropertiesEmpty");
      expect(schema.elementType).toEqual(codeModel.schemas.any?.[0]);
    });
  });

  describe("polymorhism discriminator", () => {
    it("support openapi3 discriminator mapping", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Pet", {
        type: "object",
        properties: {
          name: { type: "string" },
          pet_type: { type: "string" },
        },
        required: ["name", "pet_type"],
        discriminator: {
          propertyName: "pet_type",
          mapping: {
            catType: "#/components/schemas/Cat",
            dogType: "#/components/schemas/Dog",
          },
        },
      });

      addSchema(spec, "Dog", {
        allOf: [
          { $ref: "#/components/schemas/Pet" },
          {
            type: "object",
            properties: { bark: { type: "boolean" } },
          },
        ],
      });

      addSchema(spec, "Cat", {
        allOf: [
          { $ref: "#/components/schemas/Pet" },
          {
            type: "object",
            properties: { hunting: { type: "boolean" } },
          },
        ],
      });

      const codeModel = await runModeler(spec);

      const cat = findByName("Cat", codeModel.schemas.objects);
      expect(cat).toBeDefined();
      expect(cat?.discriminatorValue).toEqual("catType");

      const dog = findByName("Dog", codeModel.schemas.objects);
      expect(dog).toBeDefined();
      expect(dog?.discriminatorValue).toEqual("dogType");
    });

    it("support OpenAPI 2 custom x-ms-discriminator-value", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Pet", {
        type: "object",
        properties: {
          name: { type: "string" },
          pet_type: { type: "string" },
        },
        required: ["name", "pet_type"],
        discriminator: {
          propertyName: "pet_type",
        },
      });

      addSchema(spec, "Dog", {
        "x-ms-discriminator-value": "dogType",
        "allOf": [
          { $ref: "#/components/schemas/Pet" },
          {
            type: "object",
            properties: { bark: { type: "boolean" } },
          },
        ],
      });

      addSchema(spec, "Cat", {
        "x-ms-discriminator-value": "catType",
        "allOf": [
          { $ref: "#/components/schemas/Pet" },
          {
            type: "object",
            properties: { hunting: { type: "boolean" } },
          },
        ],
      });

      const codeModel = await runModeler(spec);

      const cat = findByName("Cat", codeModel.schemas.objects);
      expect(cat).toBeDefined();
      expect(cat?.discriminatorValue).toEqual("catType");

      const dog = findByName("Dog", codeModel.schemas.objects);
      expect(dog).toBeDefined();
      expect(dog?.discriminatorValue).toEqual("dogType");
    });
  });

  describe.only("enums", () => {
    it("enums referencing other any with allOf include all their properties", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        type: "string",
        enum: ["one", "two"],
      });
      addSchema(spec, "Bar", {
        type: "string",
        enum: ["three", "four", "five"],
        allOf: [{ $ref: "#/components/schemas/Foo" }],
      });

      const codeModel = await runModeler(spec);

      const bar = findByName("Bar", codeModel.schemas.choices);
      expect(bar).toBeDefined();
      expect(bar?.choices.map((x) => x.value)).toEqual(["one", "two", "three", "four", "five"]);

      // Parent should not have changed
      const foo = findByName("Foo", codeModel.schemas.choices);
      expect(foo).toBeDefined();
      expect(foo?.choices.map((x) => x.value)).toEqual(["one", "two"]);
    });

    it("enums just using other enum in allOf makes a copy", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        type: "string",
        enum: ["one", "two"],
      });
      addSchema(spec, "Bar", {
        type: "string",
        allOf: [{ $ref: "#/components/schemas/Foo" }],
      });

      const codeModel = await runModeler(spec);

      const bar = findByName("Bar", codeModel.schemas.choices);
      expect(bar).toBeDefined();
      expect(bar?.choices.map((x) => x.value)).toEqual(["one", "two"]);

      // Parent should not have changed
      const foo = findByName("Foo", codeModel.schemas.choices);
      expect(foo).toBeDefined();
      expect(foo?.choices.map((x) => x.value)).toEqual(["one", "two"]);
    });

    it("default to type:string if all values are string", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        enum: ["one", "two"],
      });

      const codeModel = await runModeler(spec);
      const foo = findByName("Foo", codeModel.schemas.choices);
      expect(foo).toBeDefined();
      expect(foo?.choiceType.type).toEqual("string");
      expect(foo?.choices.map((x) => x.value)).toEqual(["one", "two"]);
    });

    it("creates an ChoiceSchema by default for single value enums", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        enum: ["one"],
      });

      const codeModel = await runModeler(spec);
      const foo = findByName("Foo", codeModel.schemas.choices);
      expect(foo).toBeInstanceOf(ChoiceSchema);
    });

    it("creates an Constant by default for single value enums if `seal-single-value-enum-by-default` is ON", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        enum: ["one"],
      });

      const codeModel = await runModeler(spec, {
        modelerfour: {
          "seal-single-value-enum-by-default": true,
        },
      });
      expect(findByName("Foo", codeModel.schemas.choices)).toBeUndefined();
      const foo = findByName("Foo", codeModel.schemas.constants);
      expect(foo).toBeInstanceOf(ConstantSchema);
    });

    it("creates an Constant if enum is marked modelAsString=false for single value enums", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        "enum": ["one"],
        "x-ms-enum": {
          modelAsString: false,
        },
      });

      const codeModel = await runModeler(spec);
      expect(findByName("Foo", codeModel.schemas.choices)).toBeUndefined();
      const foo = findByName("Foo", codeModel.schemas.constants);
      expect(foo).toBeInstanceOf(ConstantSchema);
    });

    it("creates an ChoiceSchema by default for multi value enums", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        enum: ["one", "two"],
      });

      const codeModel = await runModeler(spec);
      const foo = findByName("Foo", codeModel.schemas.choices);
      expect(foo).toBeInstanceOf(ChoiceSchema);
    });

    it("creates an SealedChoice if enum is marked modelAsString=false for multu value enums", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Foo", {
        "enum": ["one", "two"],
        "x-ms-enum": {
          modelAsString: false,
        },
      });

      const codeModel = await runModeler(spec);
      expect(findByName("Foo", codeModel.schemas.choices)).toBeUndefined();
      const foo = findByName("Foo", codeModel.schemas.sealedChoices);
      expect(foo).toBeInstanceOf(SealedChoiceSchema);
    });
  });

  describe("Deprecation", () => {
    it("doesn't set deprecated info by default", async () => {
      const spec = createTestSpec();

      addSchema(spec, "RegularModel", {
        type: "object",
        properties: { name: { type: JsonType.String } },
      });

      const codeModel = await runModeler(spec);
      const model = findByName("RegularModel", codeModel.schemas.objects);
      expect(model?.deprecated).toEqual(undefined);
    });

    it("mark model as deprecated if deprecated:true", async () => {
      const spec = createTestSpec();

      addSchema(spec, "DeprecatedModel", {
        type: "object",
        deprecated: true,
        properties: { name: { type: JsonType.String } },
      });

      const codeModel = await runModeler(spec);
      const model = findByName("DeprecatedModel", codeModel.schemas.objects);
      expect(model?.deprecated).toEqual({});
    });
  });

  describe("Circular Dependency", () => {
    it("works when allOf reference back to child.", async () => {
      const spec = createTestSpec();

      addSchema(spec, "Child", {
        type: "object",
        allOf: [
          {
            $ref: "#/components/schemas/Parent",
          },
        ],
      });

      addSchema(spec, "Parent", {
        type: "object",
        properties: {
          child: {
            $ref: "#/components/schemas/Child",
          },
        },
      });

      const codeModel = await runModeler(spec);

      const child = findByName("Child", codeModel.schemas.objects);
      expect(child).toBeDefined();
      const parent = findByName("Parent", codeModel.schemas.objects);
      expect(parent).toBeDefined();

      expect(child?.parents?.immediate).toContain(parent);
      expect(parent?.properties?.find((x) => x.serializedName === "child")?.schema).toEqual(child);
    });
  });
});
