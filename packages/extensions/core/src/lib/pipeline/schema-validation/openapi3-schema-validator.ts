import addFormats from "ajv-formats";
import { JsonSchemaValidator } from "./json-schema-validator";

export class OpenApi3SchemaValidator extends JsonSchemaValidator {
  public constructor() {
    super();
    addFormats(this.ajv);
  }

  public get schema() {
    return require(`@autorest/schemas/openapi3-schema.json`);
  }
}
