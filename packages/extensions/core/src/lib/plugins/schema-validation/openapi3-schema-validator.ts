import addFormats from "ajv-formats";
import { JsonSchemaValidator } from "./json-schema-validator";

export class OpenApi3SchemaValidator extends JsonSchemaValidator {
  public constructor() {
    super();
    addFormats(this.ajv);
  }

  public get schema() {
    // eslint-disable-next-line @typescript-eslint/no-require-imports
    return require(`@autorest/schemas/openapi3-schema.json`);
  }
}
