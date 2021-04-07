import { ConfigurationSchema, ProcessedConfiguration, RawConfiguration } from "./types";

export class ConfigurationSchemaProcessor<S extends ConfigurationSchema> {
  public constructor(private schema: S) {}

  public processConfiguration(configuration: RawConfiguration<S>): ProcessedConfiguration<S> {
    return {} as any;
  }
}

const processor = new ConfigurationSchemaProcessor({
  "input-file": {
    type: "string",
    array: true,
  },
});

const result = processor.processConfiguration({});
