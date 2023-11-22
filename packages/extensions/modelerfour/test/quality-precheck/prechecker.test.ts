/* eslint-disable @typescript-eslint/no-non-null-assertion */
import assert from "assert";
import { Model, Refable, Dereferenced, dereference, Schema } from "@azure-tools/openapi";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { QualityPreChecker } from "../../src/quality-precheck/prechecker";
import { addSchema, createTestSessionFromModel, createTestSpec } from "../utils";

class PreCheckerClient {
  private constructor(
    private input: Model,
    public result: Model,
  ) {}

  resolve<T extends {} | undefined>(item: Refable<T>): Dereferenced<T> {
    return dereference(this.input, item);
  }

  static async create(spec: Model, config: ModelerFourOptions = {}): Promise<PreCheckerClient> {
    const { session, errors } = await createTestSessionFromModel<Model>({ modelerfour: config }, spec);
    const prechecker = new QualityPreChecker(session);
    expect(errors.length).toBe(0);

    return new PreCheckerClient(prechecker.input, prechecker.process());
  }
}

describe("Prechecker", () => {
  it("removes empty object schemas from allOf list when other parents are present", async () => {
    const spec = createTestSpec();

    addSchema(spec, "ParentSchema", {
      type: "object",
      nullable: true,
      properties: {
        hack: {
          type: "boolean",
        },
      },
    });

    addSchema(spec, "ChildSchema", {
      type: "object",
      allOf: [{ type: "object" }, { $ref: "#/components/schemas/ParentSchema" }],
      properties: {
        childOfHack: {
          type: "integer",
        },
      },
    });

    const client = await PreCheckerClient.create(spec);
    const model = client.result;

    const childSchemaRef = model.components?.schemas && model.components?.schemas["ChildSchema"];
    assert(childSchemaRef);
    const childSchema = client.resolve<Schema>(childSchemaRef);
    expect(childSchema.instance.allOf?.length).toEqual(1);
    const parent = client.resolve(childSchema.instance.allOf && childSchema.instance.allOf[0]);
    expect(parent.name).toEqual("ParentSchema");
  });

  it("remove the sibling schema with the $ref", async () => {
    const spec = createTestSpec();

    addSchema(spec, "SiblingSchema", {
      $ref: "#/components/schemas/MainSchema",
    });

    addSchema(spec, "MainSchema", {
      type: "object",
      "x-ms-client-name": "MainSchema",
      properties: {
        name: {
          type: "string",
        },
      },
    });

    const client = await PreCheckerClient.create(spec);
    const model = client.result;
    const schemas = model.components!.schemas!;
    expect(schemas["SiblingSchema"]).toBeUndefined();
    expect(schemas["MainSchema"]).not.toBeUndefined();
    const mainSchema: Schema = schemas["MainSchema"] as any;
    expect((mainSchema.properties?.name as any).type).toEqual("string");
  });

  describe("Remove child types with no additional properties", () => {
    let spec: any;

    beforeEach(() => {
      spec = createTestSpec();
      addSchema(spec, "ChildSchema", {
        allOf: [{ $ref: "#/components/schemas/ParentSchema" }],
      });

      addSchema(spec, "ParentSchema", {
        type: "object",
        properties: {
          name: {
            type: "string",
          },
        },
      });
      addSchema(spec, "Foo", {
        type: "object",
        properties: {
          child: { $ref: "#/components/schemas/ChildSchema" },
        },
      });
    });

    it("Doesn't touch it by default", async () => {
      const client = await PreCheckerClient.create(spec);
      const schemas = client.result.components!.schemas!;
      expect(schemas["ChildSchema"]).not.toBeUndefined();
      expect(schemas["ParentSchema"]).not.toBeUndefined();
      const foo = schemas["Foo"] as any;
      expect(foo).not.toBeUndefined();
      expect(foo.properties.child.$ref).toEqual("#/components/schemas/ChildSchema");
    });

    it("Remove the child type and points reference to it to its parent", async () => {
      const client = await PreCheckerClient.create(spec, {
        "remove-empty-child-schemas": true,
      });
      const schemas = client.result.components!.schemas!;
      expect(schemas["ChildSchema"]).toBeUndefined();
      expect(schemas["ParentSchema"]).not.toBeUndefined();
      const foo = schemas["Foo"] as any;
      expect(foo).not.toBeUndefined();
      expect(foo.properties.child.$ref).toEqual("#/components/schemas/ParentSchema");
    });
  });

  describe("Validate allOf schemas are the same types", () => {
    let spec: any;

    beforeEach(() => {
      spec = createTestSpec();
    });

    it("Log error if allOf is string and base is object", async () => {
      addSchema(
        spec,
        "ChildSchema",
        {
          type: "object",
          properties: {
            id: { type: "string" },
          },
          allOf: [{ $ref: "#/components/schemas/StringSchema" }],
        },
        { name: "ChildSchema" },
      );

      addSchema(
        spec,
        "StringSchema",
        {
          type: "string",
        },
        { name: "StringSchema" },
      );

      const { session, errors } = await createTestSessionFromModel<Model>({}, spec);
      const prechecker = new QualityPreChecker(session);
      prechecker.process();
      expect(errors).toHaveLength(1);
      expect(errors[0]).toEqual({
        Channel: "error",
        Details: undefined,
        Key: ["PreCheck", "AllOfTypeDifferent"],
        Text: [
          "Schema 'ChildSchema' has an allOf reference to 'StringSchema' but those schema have different types:",
          "  - ChildSchema: object",
          "  - StringSchema: string",
        ].join("\n"),
        Source: [
          { Position: { path: ["components", "schemas", "ChildSchema", "allOf", 0] }, document: "openapi-3.json" },
        ],
      });
    });
  });

  describe("Validate auto-correct allOf/oneOf/anyOf", () => {
    let spec: any;

    beforeEach(() => {
      spec = createTestSpec();
    });

    it("Auto-corrects schema with no type and allOf to type: object", async () => {
      addSchema(
        spec,
        "Widget",
        {
          description: "A widget",
          allOf: [{ $ref: "#/components/schemas/BaseWidget" }, { required: ["id"] }],
        },
        { name: "Widget" },
      );

      addSchema(
        spec,
        "BaseWidget",
        {
          type: "object",
          properties: {
            id: { type: "string" },
            color: { type: "string" },
          },
        },
        { name: "BaseWidget" },
      );

      const { session, errors, warnings } = await createTestSessionFromModel<Model>({}, spec);
      const prechecker = new QualityPreChecker(session);
      prechecker.process();
      expect(errors).toHaveLength(0);
      // Filter to get the warning about the auto-correct
      const autoCorrectWarnings = warnings.filter((w) => w.Key[1] === "SchemaMissingType");
      expect(autoCorrectWarnings).toHaveLength(1);
      expect(autoCorrectWarnings[0]).toEqual({
        Channel: "warning",
        Details: undefined,
        Key: ["PreCheck", "SchemaMissingType"],
        Text: "The schema 'Widget' with an undefined type and 'allOf'/'anyOf'/'oneOf' is a bit ambiguous. This has been auto-corrected to 'type:object'",
        Source: [{ Position: { path: ["components", "schemas", "Widget"] }, document: "openapi-3.json" }],
      });
    });

    it("Does not auto-correct schema with no type and oneOf with elements that are not type: object", async () => {
      addSchema(
        spec,
        "Prompt",
        {
          description: "Prompt",
          oneOf: [{ type: "string" }, { type: "array", items: { type: "string" } }],
        },
        { name: "Prompt" },
      );

      const { session, errors, warnings } = await createTestSessionFromModel<Model>({}, spec);
      const prechecker = new QualityPreChecker(session);
      prechecker.process();
      expect(errors).toHaveLength(0);
      // Filter to get the warning about the auto-correct
      const autoCorrectWarnings = warnings.filter((w) => w.Key[1] === "SchemaMissingType");
      expect(autoCorrectWarnings).toHaveLength(0);
    });
  });
});
