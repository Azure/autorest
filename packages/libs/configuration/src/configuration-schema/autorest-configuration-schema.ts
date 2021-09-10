import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import { ConfigurationSchemaProcessor } from "./processor";
import { RawConfiguration } from "./types";

export const AUTOREST_CONFIGURATION_SCHEMA = {
  "allow-no-input": { type: "boolean" },
  "input-file": { type: "string", array: true },
  "exclude-file": { type: "string", array: true },
  "base-folder": { type: "string" },
  directive: {
    array: true,
    type: {
      from: { type: "string", array: true },
      where: { type: "string", array: true },
      reason: { type: "string" },
      suppress: { type: "string", array: true, deprecated: true },
      set: { type: "string", array: true },
      transform: { type: "string", array: true },
      "text-transform": { type: "string", array: true },
      test: { type: "string", array: true },
      debug: {
        type: "boolean",
        description:
          "Debug this directive. When set to true autorest will log additional information regarding that directive.",
      },
    },
  },
  "declare-directive": {
    dictionary: true,
    type: "string",
  },
  "output-artifact": { type: "string", array: true },
  require: { type: "string", array: true, description: "Additional configuration files to include." },
  "try-require": { type: "string", array: true, description: "Additional configuration files to include." },
  stats: { type: "boolean", description: "Output some statistics about current autorest run." },
  use: { type: "string", array: true },
  "use-extension": { type: "string", dictionary: true },
  profile: { type: "string", array: true },
  "pass-thru": { type: "string", array: true },
  eol: {
    type: "string",
    enum: ["default", "lf", "crlf"],
    description: "Change the end of line character for generated output.",
  },

  "message-format": { type: "string", enum: ["json", "regular"] },
  verbose: { type: "boolean" },
  debug: { type: "boolean" },
  level: { type: "string", enum: ["debug", "verbose", "information", "warning", "error", "fatal"] },
  suppressions: {
    array: true,
    type: {
      code: { type: "string" },
      from: { type: "string", array: true },
      where: { type: "string", array: true },
      reason: { type: "string" },
    },
  },

  title: { type: "string" },
  "github-auth-token": { type: "string" },
  "output-file": { type: "string" },
  "output-folder": { type: "string" },
  force: {
    type: "boolean",
    description: "Force updating the version of core even if there is a local version satisfying the requirement.",
  },
  memory: { type: "string", description: "Configure max memory allowed for autorest process(s)" },

  // Feature flags
  "deduplicate-inline-models": { type: "boolean" },
} as const;

export type AutorestRawConfiguration = RawConfiguration<typeof AUTOREST_CONFIGURATION_SCHEMA> & {
  [key: string]: any;
};

export const autorestConfigurationProcessor = new ConfigurationSchemaProcessor(AUTOREST_CONFIGURATION_SCHEMA);

export const AUTOREST_INITIAL_CONFIG: AutorestNormalizedConfiguration =
  autorestConfigurationProcessor.getInitialConfig();
