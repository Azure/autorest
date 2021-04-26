import { CreateObject, Parse } from "@azure-tools/datastore";
import { join } from "path";
import untildify from "untildify";

interface CliArgs {
  positional: string[];
  /**
   * Options with the name as they are passed.
   * If the same flag is passed multiple times the latest overrides the values.
   * @example --foo.bar=true  -> {"foo.bar": true}
   */
  options: Record<string, any>;

  /**
   * Options list with the name as they are passed.
   * if the same flag is passed multiple times all the values are included in this list.
   * @example --foo.bar=true  -> [{key: "foo.bar", value: true}]
   */
  optionList: Array<{ key: string; value: "string" }>;
}

export function parseArgs(cliArgs: string[]): CliArgs {
  const result: CliArgs = {
    positional: [],
    options: {},
    optionList: [],
  };

  for (const arg of cliArgs) {
    const match = /^--([^=:]+)([=:](.+))?$/g.exec(arg);

    // configuration file?
    if (match === null) {
      result.positional.push(arg);
      continue;
    }

    // switch
    const key = match[1];
    const rawValue = resolvePathArg(match[3] || "true");
    const value = parseValue(rawValue);
    result.options[key] = value;
    result.optionList.push({ key, value });
  }

  return result;
}

const cwd = process.cwd();

/**
 * Check if the argument raw value is a relative path or using ~ for user home dir
 * and then convert it to an aboluste one.
 * @param rawValue Raw argument value.
 * @returns string value
 */
function resolvePathArg(rawValue: string): string {
  if (rawValue.startsWith(".")) {
    // starts with a . or .. -> this is a relative path to current directory
    rawValue = join(cwd, rawValue);
  }

  return untildify(rawValue);
}

/**
 * Parse the flag value.
 * @param rawValue Raw flag value
 * @returns
 */
function parseValue(rawValue: string): any {
  rawValue = rawValue.startsWith("@") ? `'${rawValue}'` : rawValue;
  rawValue = rawValue.match(/20\d\d-\d+-\d+/) ? `'${rawValue}'` : rawValue;
  // quote numbers with decimal point, we don't have any use for non-integer numbers (while on the other hand version strings may look like decimal numbers)
  rawValue = !isNaN(parseFloat(rawValue)) && rawValue.includes(".") ? `'${rawValue}'` : rawValue;
  return Parse(rawValue);
}
