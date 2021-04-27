import { MergeOptions, mergeOverwriteOrAppend } from "@autorest/common";

export function mergeConfigurations<T>(configs: Array<T>, options: MergeOptions = {}): T {
  return configs.reduce((result, config) => mergeOverwriteOrAppend(result, config), options) as T;
}
