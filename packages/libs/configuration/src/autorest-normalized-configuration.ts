import { Directive } from "./directive";

/**
 * Represent a raw configuration provided by the user.
 * i.e. The mapping of values passed via a config block, cli arguments, etc.
 */
export interface AutorestNormalizedConfiguration extends AutorestRawConfigurationAlias {
  "__status"?: any;
  "__parents"?: any | undefined;

  /**
   * Version of @autorest/core.
   */
  "version"?: string;

  "allow-no-input"?: boolean;
  "input-file"?: Array<string>;
  "exclude-file"?: Array<string>;
  "base-folder"?: string;
  "directive"?: Array<Directive>;
  "declare-directive"?: { [name: string]: string };
  "output-artifact"?: Array<string>;
  "message-format"?: "json" | "yaml" | "regular";
  "use"?: string[] | string;
  "use-extension"?: { [extensionName: string]: string };
  "require"?: Array<string>;
  "try-require"?: Array<string>;
  "help"?: any;
  "pass-thru"?: any[];
  "disable-validation"?: boolean;
  "cache"?: any;
  "vscode"?: any; // activates VS Code specific behavior and does *NOT* influence the core's behavior (only consumed by VS Code extension)

  /**
   * Toggle outputting statistics for current specs.
   */
  "stats"?: boolean;

  /**
   * Skip the semantic validation plugin.
   */
  "skip-semantics-validation"?: boolean;

  "override-info"?: any; // make sure source maps are pulling it! (see "composite swagger" method)
  "title"?: string;
  "description"?: any;
  "run"?: any;

  "debug"?: boolean;
  "verbose"?: boolean;
  "time"?: boolean;
  "timestamp"?: boolean;
  "fast-mode"?: boolean;
  "header-definitions"?: any;
  "components"?: any;
  "batch"?: boolean;
  "resource-schema-batch"?: any;
  "perform-load"?: any;

  /**
   * Feature flags. Those flags enable/disable certain features
   */
  "deduplicate-inline-models"?: boolean;

  // --------------------------------------
  // Temporary flags to deprecate features:

  /**
   * Mark OpenAPI3 validation(schema) error as warnings. (Will be removed and OpenAPI3 validation errors will always fail the pipeline)
   */
  "mark-oai3-errors-as-warnings"?: boolean;
  // --------------------------------------

  // plugin specific
  "output-file"?: string;
  "output-folder"?: string;

  // from here on: CONVENTION, not cared about by the core
  "client-side-validation"?: boolean; // C#
  "fluent"?: boolean;
  "azure-arm"?: boolean;
  "namespace"?: string;
  "license-header"?: string;
  "add-credentials"?: boolean;
  "package-name"?: string; // Ruby, Python, ...
  "package-version"?: string;
  "sync-methods"?: "all" | "essential" | "none";
  "payload-flattening-threshold"?: number;
  "openapi-type"?: string; // the specification type (ARM/Data-Plane/Default)
  "tag"?: string;
  "simple-tree-shake"?: boolean;

  // multi-api specific
  "profiles"?: any;
  "profile"?: Array<string>;
  "api-version"?: Array<string>;

  "pipeline-model"?: string;

  "resolved-directive"?: any;
  "debugger"?: any;

  "github-auth-token"?: string;

  // TODO-TIM check what is this?
  "name"?: string;
  "to"?: string;

  /**
   * This is property compiled.
   */
  "used-extension"?: string[];
}

/**
 * Contains a set of alias that can be set and will be converted.
 */
export interface AutorestRawConfigurationAlias {
  /**
   * Alias for @see AutorestRawConfiguration["license-header"]
   */
  "licence-header"?: string;
}
