import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import { ConfigurationSchemaProcessor } from "./processor";
import { RawConfiguration } from "./types";

export const AUTOREST_CONFIGURATION_SCHEMA = {
  "allow-no-input": { type: "boolean" },
  "input-file": { type: "string", array: true },
  "exclude-file": { type: "string", array: true },
  "base-folder": { type: "string" },
  "directive": {
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
  "declare-directive": {
    dictionary: true,
    type: "string",
  },
  "output-artifact": { type: "string", array: true },
  "require": { type: "string", array: true, description: "Additional configuration files to include." },
  "try-require": { type: "string", array: true, description: "Additional configuration files to include." },
  "stats": { type: "boolean", description: "Output some statistics about current autorest run." },
  "use": { type: "string", array: true },
  "use-extension": { type: "string", dictionary: true },
  "profile": { type: "string", array: true },
  "pass-thru": { type: "string", array: true },

  "message-format": { type: "string", enum: ["json", "yaml", "regular"] },
  "title": { type: "string" },
  "github-auth-token": { type: "string" },
  "output-file": { type: "string" },
  "output-folder": { type: "string" },

  // Feature flags
  "deduplicate-inline-models": { type: "boolean" },

  // Temporary flag to disable later.
  "mark-oai3-errors-as-warnings": {
    type: "boolean",
    deprecated: true,
    description:
      "Mark OpenAPI3 validation(schema) error as warnings. (Will be removed and OpenAPI3 validation errors will always fail the pipeline)",
  },
} as const;

export type AutorestRawConfiguration = RawConfiguration<typeof AUTOREST_CONFIGURATION_SCHEMA> & {
  [key: string]: any;
};

export const autorestConfigurationProcessor = new ConfigurationSchemaProcessor(AUTOREST_CONFIGURATION_SCHEMA);

export const AUTOREST_INITIAL_CONFIG: AutorestNormalizedConfiguration = autorestConfigurationProcessor.getInitialConfig();
