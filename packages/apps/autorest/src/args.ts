import { homedir } from "os";
import { join } from "path";

export interface AutorestArgs {
  // Versioning
  v3?: boolean;
  preview?: boolean;
  version?: string;
  latest?: boolean;

  reset?: boolean;
  debug?: boolean;
  info?: boolean;
  json?: boolean;
  configFileOrFolder?: string;
  force?: boolean;
}

/**
 * Regex to parse flags in format:
 * --foo:bar
 * --foo=bar
 * --foo
 */
const FLAG_REGEX = /^--([^=:]+)([=:](.+))?$/;

/**
 * Parse a list of command line arguments.
 * @param argv List of cli args(process.argv)
 */
export const parseArgs = (argv: string[]): AutorestArgs => {
  const result: any = {};
  for (const arg of argv) {
    const match = FLAG_REGEX.exec(arg);
    if (match) {
      const key = match[1];
      const rawValue = resolvePathArg(match[3] || "true");
      result[key] = parseValue(rawValue);
    }
  }
  return result;
};

const cwd = process.cwd();

/**
 * Check if the argument raw value is a relative path or using ~ for user home dir
 * and then convert it to an aboluste one.
 * @param rawValue Raw argument value.
 * @returns string value
 */
const resolvePathArg = (rawValue: string): string => {
  if (rawValue.startsWith(".")) {
    // starts with a . or .. -> this is a relative path to current directory
    rawValue = join(cwd, rawValue);
  }

  // untildify!
  if (/^~[/|\\]/g.exec(rawValue)) {
    rawValue = join(homedir(), rawValue.substring(2));
  }
  return rawValue;
};

const parseValue = (rawValue: string) => {
  try {
    const value = JSON.parse(rawValue);
    // restrict allowed types (because with great type selection comes great responsibility)
    if (typeof value !== "string" && typeof value !== "boolean") {
      return rawValue;
    }
    return value;
  } catch (e) {
    return rawValue;
  }
};
