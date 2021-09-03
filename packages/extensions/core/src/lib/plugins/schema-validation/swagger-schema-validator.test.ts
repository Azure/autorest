import { createDataHandle } from "@autorest/test-utils";
import { DataHandle } from "@azure-tools/datastore";
import { omit } from "lodash";
import { SwaggerSchemaValidator } from "./swagger-schema-validator";
const baseSwaggerSpec = {
  swagger: "2.0",
  info: {
    title: "Base spec",
    version: "1.0",
  },
  paths: {},
};

describe("Swagger schema validator", () => {
  const validator = new SwaggerSchemaValidator();

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

  it("returns error if using type: file with non formData parameter", () => {
    const errors = validator.validate({
      ...baseSwaggerSpec,
      paths: {
        "/test": {
          post: {
            parameters: [{ in: "body", type: "file", name: "body", schema: { type: "string" } }],
            responses: { 200: { description: "Ok." } },
          },
        },
      },
    });
    expect(errors).toEqual([
      {
        instancePath: "/paths/~1test/post/parameters/0",
        keyword: "additionalProperties",
        message: "must NOT have additional properties",
        params: { additionalProperty: "type" },
        path: ["paths", "/test", "post", "parameters", "0"],
        schemaPath: "#/additionalProperties",
      },
    ]);
  });

  it("combines errors", () => {
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
});
