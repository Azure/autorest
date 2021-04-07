import { AutorestRawConfiguration } from "../autorest-raw-configuration";
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
  "directives": {
    array: true,
    type: {
      "from": {
        type: "string",
        array: true,
      },
      "where": {
        type: "string",
        array: true,
      },
      "reason": {
        type: "string",
      },

      "suppress": {
        type: "string",
        array: true,
      },
      "set": {
        type: "string",
        array: true,
      },
      "transform": {
        type: "string",
        array: true,
      },
      "text-transform": {
        type: "string",
        array: true,
      },
      "test": {
        type: "string",
        array: true,
      },
    },
  },
});

const result: AutorestRawConfiguration = processor.processConfiguration({});
