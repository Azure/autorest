import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import { ConfigurationSchemaProcessor } from "./processor";
import { RawConfiguration } from "./types";

export const AUTOREST_CONFIGURATION_CATEGORIES = {
  logging: {
    name: "Logging",
  },
  installation: {
    name: "Manage installation",
  },
  core: {
    name: "Core Settings",
  },
  feature: {
    name: "Feature flags",
  },
  extensions: {
    name: "Generators and extensions",
    description:
      "> While AutoRest can be extended arbitrarily by 3rd parties (say, with a custom generator),\n> we officially support and maintain the following functionality.\n> More specific help is shown when combining the following switches with `--help` .",
  },
};

export const SUPPORTED_EXTENSIONS_SCHEMA = {
  csharp: {
    type: "boolean",
    category: "extensions",
    description: "Generate C# client code",
  },
  go: {
    type: "boolean",
    category: "extensions",
    description: "Generate Go client code",
  },
  java: {
    type: "boolean",
    category: "extensions",
    description: "Generate Java client code",
  },
  python: {
    type: "boolean",
    category: "extensions",
    description: "Generate Python client code",
  },
  az: {
    type: "boolean",
    category: "extensions",
    description: "Generate Az cli code",
  },
  typescript: {
    type: "boolean",
    category: "extensions",
    description: "Generate TypeScript client code",
  },
  azureresourceschema: {
    type: "boolean",
    category: "extensions",
    description: "Generate Azurer resource schemas",
  },
  "model-validator": {
    type: "boolean",
    category: "extensions",
    description:
      "Validates an OpenAPI document against linked examples (see https://github.com/Azure/azure-rest-api-specs/search?q=x-ms-examples ",
  },
  "azure-validator": {
    type: "boolean",
    category: "extensions",
    description:
      "Validates an OpenAPI document against guidelines to improve quality (and optionally Azure guidelines)",
  },
} as const;

// Switch next 2 lines to have autocomplete when writting configuration. Make sure to revert otherwise it lose the detailed typing for each option.
// export const AUTOREST_CONFIGURATION_SCHEMA : RootConfigurationSchema<keyof typeof AUTOREST_CONFIGURATION_CATEGORIES> = {
export const AUTOREST_CONFIGURATION_SCHEMA = {
  /**
   * Verbosity category
   */
  verbose: { type: "boolean", category: "logging", description: "Display verbose logging information" },
  debug: { type: "boolean", category: "logging", description: "Display debug logging information" },
  level: {
    type: "string",
    category: "logging",
    enum: ["debug", "verbose", "information", "warning", "error", "fatal"],
    description: "Set logging level",
  },
  "message-format": {
    type: "string",
    category: "logging",
    description: "Format of logging messages",
    enum: ["json", "regular"],
  },

  /**
   * Manage installation category
   */
  info: {
    type: "boolean",
    category: "installation",
    description: "Display information about the installed version of autorest and its extensions",
  },
  "list-available": {
    type: "boolean",
    category: "installation",
    description: "Display available AutoRest versions",
  },
  reset: {
    type: "boolean",
    category: "installation",
    description: "Removes all autorest extensions and downloads the latest version of the autorest-core extension",
  },
  preview: {
    type: "boolean",
    category: "installation",
    description: "Enables using autorest extensions that are not yet released",
  },
  latest: {
    type: "boolean",
    category: "installation",
    description: "Install the latest autorest-core extension",
  },
  force: {
    type: "boolean",
    category: "installation",
    description: "Force the re-installation of the autorest-core extension and frameworks",
  },
  version: {
    type: "string",
    category: "installation",
    description: "Use the specified version of the autorest-core extension",
  },
  use: {
    type: "array",
    category: "installation",
    items: { type: "string" },
    description:
      "Specify an extension to load and use. Format: --use=<packagename>[@<version>] (e.g. --use=@autorest/modelerfour@~4.19.0)",
  },
  "use-extension": {
    type: "dictionary",
    category: "installation",
    description: `Specify extension to load and use. Format: {"<packageName>": "<version>"}`,
    items: { type: "string" },
  },

  /**
   * Core settings
   */
  help: {
    type: "boolean",
    category: "core",
    description: "Display help (combine with flags like --csharp to get further details about specific functionality)",
  },
  memory: { type: "string", category: "core", description: "Configure max memory allowed for autorest process(s)" },
  "input-file": {
    type: "array",
    category: "core",
    description: "OpenAPI file to use as input (use this setting repeatedly to pass multiple files at once)",
    items: { type: "string" },
  },
  "output-folder": {
    type: "string",
    category: "core",
    description: `Target folder for generated artifacts; default: "<base folder>/generated"`,
  },
  "github-auth-token": {
    type: "string",
    category: "core",
    description: "OAuth token to use when pointing AutoRest at files living in a private GitHub repository",
  },
  "azure-arm": {
    type: "boolean",
    category: "core",
    description: "Generate code in Azure flavor",
  },
  "header-text": {
    type: "string",
    category: "core",
    description:
      "Text to include as a header comment in generated files (magic strings:MICROSOFTMIT, MICROSOFT_APACHE, MICROSOFT_MIT_NO_VERSION, MICROSOFT_APACHE_NO_VERSION, MICROSOFT_MIT_NOCODEGEN)",
  },
  "openapi-type": {
    type: "string",
    category: "core",
    description: `Open API Type: "arm" or "data-plane"`,
  },
  "output-converted-oai3": {
    type: "boolean",
    category: "core",
    description: `If enabled and the input-files are swager 2.0 this will output the resulting OpenAPI3.0 converted files to the output-folder`,
  },
  eol: {
    type: "string",
    category: "core",
    enum: ["default", "lf", "crlf"],
    description: "Change the end of line character for generated output.",
  },
  title: {
    type: "string",
    category: "core",
    description: "Override the service client's name listed in the swagger under title.",
  },
  "override-client-name": {
    type: "string",
    category: "core",
    description:
      "Name to use for the generated client type. By default, uses the value of the 'Title' field from the input files",
  },
  directive: {
    type: "array",
    category: "core",
    items: {
      type: "object",
      properties: {
        from: { type: "array", items: { type: "string" } },
        // directive is also used in the powershell extension (where and set in particular are object there) https://github.com/Azure/autorest.powershell/blob/main/docs/directives.md
        // where: { type: "array", items: { type: "string" } },
        reason: { type: "array", items: { type: "string" } },
        suppress: { type: "array", deprecated: true, items: { type: "string" } },
        // set: { type: "array", items: { type: "string" } },
        transform: { type: "array", items: { type: "string" } },
        "text-transform": { type: "array", items: { type: "string" } },
        test: { type: "array", items: { type: "string" } },
        debug: {
          type: "boolean",
          description:
            "Debug this directive. When set to true autorest will log additional information regarding that directive.",
        },
      },
    },
  },
  require: {
    type: "array",
    category: "core",
    description: "Additional configuration file(s) to include.",
    items: { type: "string" },
  },
  "try-require": {
    type: "array",
    category: "core",
    description:
      "Additional configuration file(s) to try to include. Will not fail if the configuration file doesn't exist.",
    items: { type: "string", description: "Additional configuration files to include." },
  },
  "declare-directive": {
    type: "dictionary",
    category: "core",
    description:
      "Declare some reusable directives (https://github.com/Azure/autorest/blob/main/packages/libs/configuration/resources/directives.md#how-it-works)",
    items: { type: "string" },
  },
  "output-artifact": {
    type: "array",
    category: "core",
    description: "Additional artifact type to emit to the output-folder",
    items: { type: "string" },
  },

  "allow-no-input": { type: "boolean" },
  "exclude-file": { type: "array", items: { type: "string" } },
  "base-folder": { type: "string" },

  stats: { type: "boolean", category: "core", description: "Output some statistics about current autorest run." },

  profile: {
    type: "array",
    category: "core",
    description: "Reserved for future use.",
    items: { type: "string" },
  },

  suppressions: {
    type: "array",
    category: "core",
    description: "List of warning/error code to ignore.",
    items: {
      type: "object",
      properties: {
        code: { type: "string" },
        from: { type: "array", items: { type: "string" } },
        where: { type: "array", items: { type: "string" } },
        reason: { type: "string" },
      },
    },
  },

  "output-file": { type: "string" },

  /**
   * Feature flags
   */
  "deduplicate-inline-models": { type: "boolean", category: "feature", description: "Deduplicate inline models" },

  "include-x-ms-examples-original-file": {
    type: "boolean",
    category: "feature",
    description: "Include x-ms-original-file property in x-ms-examples",
  },

  /**
   * Ignore.
   */
  "pass-thru": {
    type: "array",
    items: { type: "string" },
  },
} as const;

export type AutorestRawConfiguration = RawConfiguration<typeof AUTOREST_CONFIGURATION_SCHEMA> & {
  [key: string]: any;
};

export const AUTOREST_CONFIGURATION_DEFINITION = {
  categories: AUTOREST_CONFIGURATION_CATEGORIES,
  schema: AUTOREST_CONFIGURATION_SCHEMA,
};
export const AUTOREST_CONFIGURATION_DEFINITION_FOR_HELP = {
  categories: AUTOREST_CONFIGURATION_CATEGORIES,
  // SUPPORTED_EXTENSIONS_SCHEMA can either be a flag to enable or a scope which cause issue with the validation.
  schema: { ...AUTOREST_CONFIGURATION_SCHEMA, ...SUPPORTED_EXTENSIONS_SCHEMA },
};

export const autorestConfigurationProcessor = new ConfigurationSchemaProcessor(AUTOREST_CONFIGURATION_DEFINITION);

export const AUTOREST_INITIAL_CONFIG: AutorestNormalizedConfiguration =
  autorestConfigurationProcessor.getInitialConfig();
