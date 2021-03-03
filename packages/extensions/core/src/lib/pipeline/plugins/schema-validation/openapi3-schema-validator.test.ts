import { DataHandle } from "@azure-tools/datastore";
import { omit } from "lodash";
import { createDataHandle } from "@autorest/test-utils";
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
        dataPath: "",
        keyword: "required",
        message: "should have required property 'info'",
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
        dataPath: "/info",
        keyword: "additionalProperties",
        message: "should NOT have additional properties",
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
        dataPath: "/paths/foo~1bar",
        keyword: "errorMessage",
        message: 'should only have path names that start with `/` but found "foo/bar"',
        params: expect.anything(),
        path: ["paths", "foo/bar"],
        schemaPath: "#/additionalProperties/errorMessage",
      },
    ]);
  });

  describe("when validating a file", () => {
    let file: DataHandle;
    beforeEach(() => {
      const spec = {
        ...baseSwaggerSpec,
        info: {
          ...baseSwaggerSpec.info,
          unexpectedProperty: "value",
        },
      };
      file = createDataHandle(JSON.stringify(spec, null, 2));
    });

    it("returns the line number where the error is", async () => {
      const errors = await validator.validateFile(file);

      expect(errors).toHaveLength(1);
      expect(errors[0].position).toEqual(
        expect.objectContaining({
          column: 2,
          length: 6,
        }),
      );
    });
  });
});
