import { flatMap } from "lodash";
import {
  ConfigurationProperty,
  ConfigurationSchema,
  InferredPrimitiveType,
  InferredProcessedType,
  InferredRawPrimitiveType,
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

  public processConfiguration(configuration: RawConfiguration<S>): Result<ProcessedConfiguration<S>> {
    return processConfiguration(this.schema, [], configuration);
  }
}

type ErrorResult = {
  errors: ProcessingError[];
};

type ValueResult<T> = {
  value: T;
};

type Result<T> = ErrorResult | ValueResult<T>;

function processConfiguration<S extends ConfigurationSchema>(
  schema: S,
  path: string[],
  configuration: RawConfiguration<S>,
): Result<ProcessedConfiguration<S>> {
  const errors = [];
  const result: any = {};
  for (const [key, value] of Object.entries(configuration)) {
    const propertySchema = schema[key];
    const propertyPath = [...path, key];
    if (!propertySchema) {
      errors.push({
        code: ProcessingErrorCode.UnknownProperty,
        message: `Property ${key} is not defined in the schema.`,
        path: propertyPath,
      });
      continue;
    }

    const propertyResult = processProperty(propertySchema as any, propertyPath, value);
    if (isErrorResult(propertyResult)) {
      errors.push(...propertyResult.errors);
    } else {
      result[key] = propertyResult.value;
    }
  }

  return errors.length > 0 ? { errors } : { value: result };
}

function processProperty<T extends ConfigurationProperty>(
  schema: T,
  path: string[],
  value: InferredRawType<T>,
): Result<InferredProcessedType<T>> {
  if (schema.array) {
    if (value === undefined) {
      return { value: [] as any };
    }

    if (Array.isArray(value)) {
      const result = value.map((x, i) => processPrimitiveProperty(schema, [...path, i.toString()], x));
      const values = result.filter(isNotErrorResult).map((x) => x.value);
      const errors = flatMap(result.filter(isErrorResult).map((x) => x.errors));
      if (errors.length > 0) {
        return { errors };
      }
      return { value: values as any };
    } else {
      const result = processPrimitiveProperty(schema, path, value as InferredRawPrimitiveType<T>);
      if (isErrorResult(result)) {
        return result;
      } else {
        return { value: [result.value] as any };
      }
    }
  } else {
    return processPrimitiveProperty(schema, path, value as InferredRawPrimitiveType<T>) as any;
  }
}

function processPrimitiveProperty<T extends ConfigurationProperty>(
  schema: T,
  path: string[],
  value: InferredRawPrimitiveType<T>,
): Result<InferredPrimitiveType<T>> {
  if (schema.type === "number") {
    if (typeof value !== "number") {
      return {
        errors: [createInvalidTypeError(value, "number", path)],
      };
    }
    return { value } as any;
  }

  if (schema.type === "boolean") {
    if (typeof value !== "boolean") {
      return {
        errors: [createInvalidTypeError(value, "boolean", path)],
      };
    }
    return { value } as any;
  }

  if (schema.type === "string") {
    if (typeof value !== "string") {
      return {
        errors: [createInvalidTypeError(value, "string", path)],
      };
    }

    if (schema.enum) {
      if (!schema.enum.includes(value)) {
        return {
          errors: [
            {
              code: ProcessingErrorCode.InvalidType,
              message: `Expected a value to be in [${schema.enum.map((x) => `'${x}'`).join(",")}] but got '${value}'`,
              path,
            },
          ],
        };
      }
    }
    return { value } as any;
  }

  // Means this is a nested configuration schema
  return processConfiguration<any>(schema, path, value as any) as any;
}

function createInvalidTypeError(value: unknown, expectedType: string, path: string[]) {
  return {
    code: ProcessingErrorCode.InvalidType,
    message: `Expected a ${expectedType} but got ${typeof value}: '${value}'`,
    path,
  };
}

function isErrorResult<T>(value: Result<T>): value is ErrorResult {
  return "errors" in value;
}

function isNotErrorResult<T>(value: Result<T>): value is ValueResult<T> {
  return !("errors" in value);
}
