import { mergeOverwriteOrAppend } from "@autorest/common";
import { AutorestRawConfiguration } from "./autorest-raw-configuration";

export const mergeConfigurations = (...configs: Array<AutorestRawConfiguration>): AutorestRawConfiguration => {
  return configs.reduce((result, config) => mergeOverwriteOrAppend(result, config), {});
};
