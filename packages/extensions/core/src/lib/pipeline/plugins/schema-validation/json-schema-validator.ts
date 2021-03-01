import { CompilePosition, DataHandle, JsonPath, parseJsonPointer } from "@azure-tools/datastore";
import Ajv, { AnySchemaObject, ErrorObject } from "ajv";
import ajvErrors from "ajv-errors";
import { Position } from "source-map";

export interface ValidationError extends ErrorObject {
  path: JsonPath;
}

export interface PositionedValidationError extends ValidationError {
  position: Position;
}

export abstract class JsonSchemaValidator {
  protected ajv: Ajv;

  public constructor() {
    this.ajv = new Ajv({ allErrors: true, strict: false });
    ajvErrors(this.ajv, {});
  }

  public abstract get schema(): AnySchemaObject;

  public validate(spec: unknown): ValidationError[] {
    const validate = this.ajv.compile(this.schema);
    const valid = validate(spec);
    if (valid || !validate.errors) {
      return [];
    } else {
      return validate.errors.map((x) => ({ ...x, path: parseJsonPointer(x.dataPath) }));
    }
  }

  public async validateFile(file: DataHandle): Promise<PositionedValidationError[]> {
    const spec = await file.ReadObject();
    const errors = this.validate(spec);
    const mappedErrors = errors.map((x) => extendWithPosition(x, file));
    return Promise.all(mappedErrors);
  }
}

async function extendWithPosition(error: ValidationError, file: DataHandle): Promise<PositionedValidationError> {
  return {
    ...error,
    position: await CompilePosition({ path: error.path }, file),
  };
}
