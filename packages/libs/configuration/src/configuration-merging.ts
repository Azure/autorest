import { mergeOverwriteOrAppend } from "@autorest/common";
import { AutorestNormalizedConfiguration } from "./autorest-raw-configuration";

export const mergeConfigurations = (
  ...configs: Array<AutorestNormalizedConfiguration>
): AutorestNormalizedConfiguration => {
  return configs.reduce((result, config) => mergeOverwriteOrAppend(result, config), {});
};
