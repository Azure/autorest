import { Directive } from "./directive";

/**
 * Represent a raw configuration provided by the user.
 * i.e. The mapping of values passed via a config block, cli arguments, etc.
 */
export interface AutorestRawConfiguration {
  "__info"?: string | null;
  "__parents"?: any | undefined;
  "allow-no-input"?: boolean;
  "input-file"?: Array<string> | string;
  "exclude-file"?: Array<string> | string;
  "base-folder"?: string;
  "directive"?: Array<Directive> | Directive;
  "declare-directive"?: { [name: string]: string };
  "output-artifact"?: Array<string> | string;
  "message-format"?: "json" | "yaml" | "regular";
  "use"?: any[];
  "use-extension"?: { [extensionName: string]: string };
  "require"?: Array<string> | string;
  "try-require"?: Array<string> | string;
  "help"?: any;
  "pass-thru"?: any[];
  "disable-validation"?: boolean;
  "cache"?: any;
  "vscode"?: any; // activates VS Code specific behavior and does *NOT* influence the core's behavior (only consumed by VS Code extension)

  "override-info"?: any; // make sure source maps are pulling it! (see "composite swagger" method)
  "title"?: any;
  "description"?: any;

  "debug"?: boolean;
  "verbose"?: boolean;
  "time"?: boolean;

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
  "profile"?: Array<string> | string;
  "api-version"?: Array<string>;

  "pipeline-model"?: string;
  "load-priority"?: number;

  "resolved-directive"?: any;
  "debugger"?: any;

  "github-auth-token"?: string;

  // TODO-TIM check what is this?
  "name"?: string;
  "to"?: string;

  [key: string]: any;
}
