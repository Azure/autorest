import Ajv, { ErrorObject } from "ajv";
import ajvErrors from "ajv-errors";
import addFormats from "ajv-formats";

export class SwaggerSchemaValidator {
  private ajv: Ajv;

  public constructor() {
    // eslint-disable-next-line node/no-missing-require
    this.ajv = ajvErrors(
      new Ajv({ allErrors: true, strict: false, meta: require("ajv/lib/refs/json-schema-draft-06.json") }),
    );
    addFormats(this.ajv);
    this.ajv.addSchema(
      require("C:/dev/azsdk/autorest/packages/libs/autorest-schemas/swagger.json"),
      "http://json.schemastore.org/swagger-2.0",
    );
    this.ajv.addSchema(
      require("C:/dev/azsdk/autorest/packages/libs/autorest-schemas/example-schema.json"),
      "https://raw.githubusercontent.com/Azure/autorest/master/schema/example-schema.json",
    );
  }

  public validate(spec: unknown): ErrorObject[] {
    const validate = this.ajv.compile(require(`@autorest/schemas/swagger-extensions.json`));
    const valid = validate(spec);
    if (valid || !validate.errors) {
      return [];
    } else {
      return validate.errors;
    }
  }
}
