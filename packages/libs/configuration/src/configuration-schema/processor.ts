import { AutorestRawConfiguration } from "../autorest-raw-configuration";
import { ConfigurationSchema, EnumType, ProcessedConfiguration, RawConfiguration } from "./types";

export class ConfigurationSchemaProcessor<S extends ConfigurationSchema> {
  public constructor(private schema: S) {}

  public processConfiguration(configuration: RawConfiguration<S>): ProcessedConfiguration<S> {
    return {} as any;
  }
}

export type Foo<S extends ConfigurationSchema> = S;

const schema = {
  "allow-no-input": { type: "boolean" },
  "input-file": { type: "string", array: true },
  "exclude-file": { type: "string", array: true },
  "base-folder": { type: "string" },
  "directives": {
    array: true,
    type: {
      "from": { type: "string", array: true },
      "where": { type: "string", array: true },
      "reason": { type: "string" },
      "suppress": { type: "string", array: true },
      "set": { type: "string", array: true },
      "transform": { type: "string", array: true },
      "text-transform": { type: "string", array: true },
      "test": { type: "string", array: true },
    },
  },
  "output-artifact": { type: "string", array: true },
  "require": { type: "string", array: true, description: "Additional configuration files to include." },
  "stats": { type: "boolean", description: "Output some statistics about current autorest run." },

  "message-format": { type: "string", enum: ["json", "yaml", "regular"] },
  "title": { type: "string" },
  "github-auth-token": { type: "string" },
} as const;

const processor = new ConfigurationSchemaProcessor(schema);
const result = processor.processConfiguration({});
const config: AutorestRawConfiguration = result;
