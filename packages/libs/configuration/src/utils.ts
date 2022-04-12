import { LogLevel } from "@autorest/common";
import { AutorestNormalizedConfiguration } from "./autorest-normalized-configuration";

export function isIterable(target: any): target is Iterable<any> {
  return !!target && typeof target[Symbol.iterator] === "function";
}

/**
 * Takes a configuration value that can be either an array, a single value or empty and returns an array with all values.
 * @param value Value to wrap in an array.
 * @returns Array of all the values.
 */
export function arrayOf<T>(value: T | T[] | undefined): T[] {
  if (value === undefined) {
    return [];
  }

  switch (typeof value) {
    case "string": // Need to do this case as String is iterable.
      return [value];
    case "object":
      if (isIterable(value)) {
        return [...value];
      }
      break;
  }
  return [value];
}

export interface LogOptions {
  debug?: boolean;
  verbose?: boolean;
  level?: LogLevel | string;
}

export function getLogLevel(config: LogOptions): LogLevel {
  return config.debug
    ? "debug"
    : config.verbose
    ? "verbose"
    : config.level && isValidLogLevel(config.level)
    ? config.level
    : "information";
}

export function isValidLogLevel(level: string): level is LogLevel {
  switch (level) {
    case "debug":
    case "verbose":
    case "information":
    case "warning":
    case "error":
    case "fatal":
      return true;
    default:
      return false;
  }
}
