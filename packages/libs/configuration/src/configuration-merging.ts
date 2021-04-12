import { mergeOverwriteOrAppend } from "@autorest/common";

export function mergeConfigurations<T>(...configs: Array<T>): T {
  return configs.reduce((result, config) => mergeOverwriteOrAppend(result, config), {}) as T;
}
