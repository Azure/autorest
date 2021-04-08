import { ConfigurationSchema, ProcessedConfiguration, RawConfiguration } from "./types";

export enum ProcessingErrorCode {
  UnknownProperty = "unknownProperty",
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
