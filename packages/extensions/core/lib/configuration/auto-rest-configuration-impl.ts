import { evaluateGuard } from "../parsing/literate-yaml";
import { MergeOverwriteOrAppend } from "../source-map/merging";
import { Directive } from "./directive";

export interface AutoRestConfigurationImpl {
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
  "use-extension"?: { [extensionName: string]: string };
  "require"?: Array<string> | string;
  "try-require"?: Array<string> | string;
  "help"?: any;
  "vscode"?: any; // activates VS Code specific behavior and does *NOT* influence the core's behavior (only consumed by VS Code extension)

  "override-info"?: any; // make sure source maps are pulling it! (see "composite swagger" method)
  "title"?: any;
  "description"?: any;

  "debug"?: boolean;
  "verbose"?: boolean;
  "time"?: boolean;

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
}

export const mergeConfigurations = (...configs: Array<AutoRestConfigurationImpl>): AutoRestConfigurationImpl => {
  let result: AutoRestConfigurationImpl = {};
  configs = configs
    .map((each, i, a) => ({ ...each, "load-priority": each["load-priority"] || -i }))
    .sort((a, b) => b["load-priority"] - a["load-priority"]);
  // if they say --profile: or --api-version: (or in config) then we force it to set the tag=all-api-versions
  // Some of the rest specs had a default tag set (really shouldn't have done that), which ... was problematic,
  // so this enables us to override that in the case they are asking for filtering to a profile or a api-verison

  const forceAllVersionsMode = !!configs.find((each) => each["api-version"]?.length || each.profile?.length || 0 > 0);
  for (const config of configs) {
    result = mergeConfiguration(result, config, forceAllVersionsMode);
  }
  result["load-priority"] = undefined;
  return result;
};

// TODO: operate on DataHandleRead and create source map!
export const mergeConfiguration = (
  higherPriority: AutoRestConfigurationImpl,
  lowerPriority: AutoRestConfigurationImpl,
  forceAllVersionsMode = false,
): AutoRestConfigurationImpl => {
  // check guard
  if (lowerPriority.__info && !evaluateGuard(lowerPriority.__info, higherPriority, forceAllVersionsMode)) {
    // guard false? => skip
    return higherPriority;
  }

  // merge
  return MergeOverwriteOrAppend(higherPriority, lowerPriority);
};
