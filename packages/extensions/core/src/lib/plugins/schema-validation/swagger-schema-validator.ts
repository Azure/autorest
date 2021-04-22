import addFormats from "ajv-formats";
import { JsonSchemaValidator } from "./json-schema-validator";

export class SwaggerSchemaValidator extends JsonSchemaValidator {
  public constructor() {
    super();
    addFormats(this.ajv);

    this.ajv.addSchema(require("@autorest/schemas/swagger.json"), "http://json.schemastore.org/swagger-2.0");
    this.ajv.addSchema(
      require("@autorest/schemas/example-schema.json"),
      "https://raw.githubusercontent.com/Azure/autorest/master/schema/example-schema.json",
    );
  }

  public get schema() {
    return require(`@autorest/schemas/swagger-extensions.json`);
  }
}
