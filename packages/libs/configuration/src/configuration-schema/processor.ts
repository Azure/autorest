import {
  ConfigurationProperty,
  ConfigurationSchema,
  InferredProcessedType,
  InferredRawType,
  ProcessedConfiguration,
  RawConfiguration,
} from "./types";

export enum ProcessingErrorCode {
  UnknownProperty = "unknownProperty",
  InvalidType = "invalidType",
}

export interface ProcessingError {
  code: ProcessingErrorCode;
  message: string;
  path: string[];
}

export class ConfigurationSchemaProcessor<S extends ConfigurationSchema> {
  public constructor(private schema: S) {}

  public processConfiguration(configuration: RawConfiguration<S>): ProcessedConfiguration<S> {
    const errors = [];
    for (const [key, value] of Object.entries(configuration)) {
      const propertySchema = this.schema[key];
      if (!propertySchema) {
        errors.push({
          code: ProcessingErrorCode.UnknownProperty,
          message: `Property ${key} is not defined in the schema.`,
          path: [key],
        });
        continue;
      }
    }

    return {} as any;
  }
}

type Result<T> =
  | {
      errors: ProcessingError[];
    }
  | {
      value: T;
    };

function processProperty<T extends ConfigurationProperty>(
  schema: T,
  path: string[],
  value: InferredRawType<T>,
): Result<InferredProcessedType<T>> {
  if (schema.array) {
    return null!;
  }

  if (schema.type === "number") {
    if (typeof value !== "number") {
      return {
        errors: [{ code: ProcessingErrorCode.InvalidType, message: `Expected a number but got ${typeof value}`, path }],
      };
    }
    return { value } as any;
  }

  if (schema.type === "boolean") {
    if (typeof value !== "boolean") {
      return {
        errors: [
          {
            code: ProcessingErrorCode.InvalidType,
            message: `Expected a boolean but got ${typeof value}`,
            path,
          },
        ],
      };
    }
    return { value } as any;
  }

  if (schema.type === "string") {
    if (typeof value !== "string") {
      return {
        errors: [
          {
            code: ProcessingErrorCode.InvalidType,
            message: `Expected a string but got ${typeof value}`,
            path,
          },
        ],
      };
    }

    if (schema.enum) {
      if (!schema.enum.includes(value)) {
        return {
          errors: [
            {
              code: ProcessingErrorCode.InvalidType,
              message: `Expected a value to be in [${schema.enum.join(",")}] but got ${typeof value}`,
              path,
            },
          ],
        };
      }
    }
    return { value } as any;
  }
}
