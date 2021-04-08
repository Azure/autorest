import { AutorestRawConfiguration } from "../autorest-raw-configuration";
import { ConfigurationSchemaProcessor } from "./processor";

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
  "stats": { type: "boolean", description: "Output some statistics about current autorest run." },

  "message-format": { type: "string", enum: ["json", "yaml", "regular"] },
  "title": { type: "string" },
  "github-auth-token": { type: "string" },
} as const;

export const autorestConfigurationProcessor = new ConfigurationSchemaProcessor(AUTOREST_CONFIGURATION_SCHEMA);
const result = autorestConfigurationProcessor.processConfiguration({});
const config: AutorestRawConfiguration = result;
