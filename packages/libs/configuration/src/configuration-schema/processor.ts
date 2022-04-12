import { inspect } from "util";
import { AutorestLogger } from "@autorest/common";
import { flatMap } from "lodash";
import {
  ConfigurationProperty,
  ConfigurationSchema,
  InferredProcessedPrimitiveType,
  InferredProcessedType,
  InferredRawPrimitiveType,
  InferredRawType,
  ProcessedConfiguration,
  RawConfiguration,
  ConfigurationSchemaDefinition,
  PrimitiveConfigurationProperty,
} from "./types";
import { RootConfigurationSchema } from ".";

export enum ProcessingErrorCode {
  UnknownProperty = "unknownProperty",
  InvalidType = "invalidType",
}

export interface ProcessingError {
  code: ProcessingErrorCode;
  message: string;
  path: string[];
}

export interface ErrorResult {
  errors: ProcessingError[];
}

export interface ValueResult<T> {
  value: T;
}

export type Result<T> = ErrorResult | ValueResult<T>;

export interface ProcessConfigurationOptions {
  logger: AutorestLogger;
}

export class ConfigurationSchemaProcessor<C extends string, S extends RootConfigurationSchema<C>> {
  public constructor(private def: ConfigurationSchemaDefinition<C, S>) {}

  public processConfiguration(
    configuration: RawConfiguration<S>,
    options: ProcessConfigurationOptions,
  ): Result<ProcessedConfiguration<S>> {
    return processConfiguration(this.def.schema, [], configuration, options);
  }

  /**
   * Returns an empty config with all array property to be able to work with @see mergeConfigurations.
   */
  public getInitialConfig(): Readonly<ProcessedConfiguration<S>> {
    return getInitialConfig(this.def.schema);
  }
}

function getInitialConfig<S extends ConfigurationSchema>(schema: S): Readonly<ProcessedConfiguration<S>> {
  const config: any = {};

  for (const [key, value] of Object.entries(schema)) {
    if (value.type === "array") {
      config[key] = [];
    } else if (value.type === "object") {
      const nested = getInitialConfig(value.properties);
      if (Object.keys(nested).length > 0) {
        config[key] = nested;
      }
    }
  }
  return Object.freeze(config);
}

function processConfiguration<S extends ConfigurationSchema>(
  schema: S,
  path: string[],
  configuration: RawConfiguration<S>,
  options: ProcessConfigurationOptions,
): Result<ProcessedConfiguration<S>> {
  const errors = [];
  const result: any = {};
  for (const [key, value] of Object.entries(configuration)) {
    const propertySchema = schema[key];
    const propertyPath = [...path, key];
    if (!propertySchema) {
      // Don't fail for now as any property could be used. See if we can make use of this latter(Maybe using a flag)
      // errors.push({
      //   code: ProcessingErrorCode.UnknownProperty,
      //   message: `Property ${key} is not defined in the schema.`,
      //   path: propertyPath,
      // });
      result[key] = value;
      continue;
    }

    const propertyResult = processProperty(propertySchema, propertyPath, value, options);
    if (isErrorResult(propertyResult)) {
      errors.push(...propertyResult.errors);
    } else {
      result[key] = propertyResult.value;
      if (propertySchema.deprecated) {
        options.logger.trackWarning({
          code: "DeprecatedConfig",
          message: `Using ${propertyPath.join(".")} which is deprecated and will be removed in the future.`,
        });
      }
    }
  }

  return errors.length > 0 ? { errors } : { value: result };
}

function processProperty<T extends ConfigurationProperty>(
  schema: T,
  path: string[],
  value: InferredRawType<T>,
  options: ProcessConfigurationOptions,
): Result<InferredProcessedType<T>> {
  if (schema.type === "array") {
    if (value === undefined) {
      return { value: [] as any };
    }

    if (Array.isArray(value)) {
      const result = value.map((x, i) => processPrimitiveProperty(schema.items, [...path, i.toString()], x, options));
      const values = result.filter(isNotErrorResult).map((x) => x.value);
      const errors = flatMap(result.filter(isErrorResult).map((x) => x.errors));
      if (errors.length > 0) {
        return { errors };
      }
      return { value: values as any };
    } else {
      const result = processPrimitiveProperty(schema.items, path, value, options);
      if (isErrorResult(result)) {
        return result;
      } else {
        return { value: [result.value] as any };
      }
    }
  } else if (schema.type === "dictionary") {
    if (value === undefined) {
      return { value: {} as any };
    }

    if (typeof value !== "object") {
      return { errors: [createInvalidTypeError(value, "object", path)] };
    }
    const result: any = {};

    for (const [key, dictValue] of Object.entries<any>(value ?? {})) {
      const prop = processProperty(schema.items, [...path, key], dictValue, options);
      if ("errors" in prop) {
        return { errors: prop.errors };
      }
      result[key] = prop.value;
    }

    return { value: result };
  } else {
    if (value === undefined) {
      return { value: undefined as any };
    }
    return processPrimitiveProperty(schema, path, value as any, options) as any;
  }
}

function processPrimitiveProperty<T extends PrimitiveConfigurationProperty>(
  schema: T,
  path: string[],
  value: InferredRawPrimitiveType<T>,
  options: ProcessConfigurationOptions,
): Result<InferredProcessedPrimitiveType<T>> {
  switch (schema.type) {
    case "object":
      return processConfiguration<any>(schema.properties, path, value as any, options) as any;
    case "number": {
      if (typeof value !== "number") {
        return {
          errors: [createInvalidTypeError(value, "number", path)],
        };
      }
      return { value } as any;
    }
    case "boolean":
      if (typeof value !== "boolean") {
        return {
          errors: [createInvalidTypeError(value, "boolean", path)],
        };
      }
      return { value } as any;
    case "string": {
      if (typeof value !== "string") {
        return {
          errors: [createInvalidTypeError(value, "string", path)],
        };
      }

      if (schema.enum) {
        if (!schema.enum.includes(value)) {
          const serializedValue = inspect(value);
          return {
            errors: [
              {
                code: ProcessingErrorCode.InvalidType,
                message: `Expected a value to be in [${schema.enum
                  .map((x) => `'${x}'`)
                  .join(",")}] but got ${serializedValue}`,
                path,
              },
            ],
          };
        }
      }
      return { value } as any;
    }
  }
}

function createInvalidTypeError(value: unknown, expectedType: string, path: string[]) {
  const serializedValue = inspect(value);

  return {
    code: ProcessingErrorCode.InvalidType,
    message: `Expected a ${expectedType} but got ${typeof value}: ${serializedValue}`,
    path,
  };
}

function isErrorResult<T>(value: Result<T>): value is ErrorResult {
  return "errors" in value;
}

function isNotErrorResult<T>(value: Result<T>): value is ValueResult<T> {
  return !("errors" in value);
}
