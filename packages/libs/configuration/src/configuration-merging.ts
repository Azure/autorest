import { evaluateGuard, mergeOverwriteOrAppend } from "@autorest/common";
import { AutorestRawConfiguration } from "./autorest-raw-configuration";

export const mergeConfigurations = (...configs: Array<AutorestRawConfiguration>): AutorestRawConfiguration => {
  let result: AutorestRawConfiguration = {};
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
  higherPriority: AutorestRawConfiguration,
  lowerPriority: AutorestRawConfiguration,
  forceAllVersionsMode = false,
): AutorestRawConfiguration => {
  // check guard
  if (lowerPriority.__info && !evaluateGuard(lowerPriority.__info, higherPriority, forceAllVersionsMode)) {
    // guard false? => skip
    return higherPriority;
  }

  // merge
  return mergeOverwriteOrAppend(higherPriority, lowerPriority);
};
