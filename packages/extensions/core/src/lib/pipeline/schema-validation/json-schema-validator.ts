import { CompilePosition, DataHandle, parseJsonPointer } from "@azure-tools/datastore";
import Ajv, { AnySchemaObject, ErrorObject } from "ajv";
import ajvErrors from "ajv-errors";
import { Position } from "source-map";

export type ValidationError = ErrorObject;

export interface PositionedValidationError extends ValidationError {
  position: Position;
}

export abstract class JsonSchemaValidator {
  protected ajv: Ajv;

  public constructor() {
    this.ajv = ajvErrors(
      new Ajv({ allErrors: true, strict: false, meta: require("ajv/lib/refs/json-schema-draft-06.json") }),
    );
  }

  public abstract get schema(): AnySchemaObject;

  public validate(spec: unknown): ErrorObject[] {
    const validate = this.ajv.compile(this.schema);
    const valid = validate(spec);
    if (valid || !validate.errors) {
      return [];
    } else {
      return validate.errors;
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
  const path = parseJsonPointer(error.dataPath);
  return {
    ...error,
    position: await CompilePosition({ path }, file),
  };
}
