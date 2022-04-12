import { omit } from "lodash";
import { OpenApi3SchemaValidator } from "./openapi3-schema-validator";
const baseSwaggerSpec = {
  openapi: "3.0.0",
  info: {
    title: "Base spec",
    version: "1.0",
  },
  paths: {},
};

describe("OpenAPI3 schema validator", () => {
  const validator = new OpenApi3SchemaValidator();

  it("returns no errors if the spec is valid", () => {
    expect(validator.validate(baseSwaggerSpec)).toHaveLength(0);
  });

  it("returns error if the info field is missing", () => {
    const errors = validator.validate(omit(baseSwaggerSpec, "info"));
    expect(errors).toEqual([
      {
        instancePath: "",
        keyword: "required",
        message: "must have required property 'info'",
        params: { missingProperty: "info" },
        path: [],
        schemaPath: "#/required",
      },
    ]);
  });

  it("combines erros", () => {
    const errors = validator.validate({
      ...baseSwaggerSpec,
      info: { ...baseSwaggerSpec.info, invalidProp: "foo", otherProp: "bar" },
    });
    expect(errors).toEqual([
      {
        instancePath: "/info",
        keyword: "additionalProperties",
        message: "must NOT have additional properties",
        params: { additionalProperty: ["invalidProp", "otherProp"] },
        path: ["info"],
        schemaPath: "#/additionalProperties",
      },
    ]);
  });

  it("returns custom error if path is not starting with /", () => {
    const errors = validator.validate({ ...baseSwaggerSpec, paths: { "foo/bar": {} } });
    expect(errors).toEqual([
      {
        instancePath: "/paths/foo~1bar",
        keyword: "errorMessage",
        message: 'must only have path names that start with `/` but found "foo/bar"',
        params: expect.anything(),
        path: ["paths", "foo/bar"],
        schemaPath: "#/additionalProperties/errorMessage",
      },
    ]);
  });

  it("returns custom error if both example and examples are used  in parameter", () => {
    const errors = validator.validate({
      ...baseSwaggerSpec,
      paths: {
        "/test": {
          get: {
            parameters: [
              {
                in: "query",
                name: "foo",
                example: {},
                examples: {},
              },
            ],
            responses: { 200: { description: "ok" } },
          },
        },
      },
    });
    expect(errors).toEqual([
      {
        instancePath: "/paths/~1test/get/parameters/0",
        keyword: "errorMessage",
        message: "must not have both `example` and `examples`, as they are mutually exclusive",
        params: expect.anything(),
        path: ["paths", "/test", "get", "parameters", "0"],
        schemaPath: "#/definitions/ExampleXORExamples/errorMessage",
      },
    ]);
  });
});
