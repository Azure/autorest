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
 * Parse a list of command line arguments.
 * @param argv List of cli args(process.argv)
 */
export const parseArgs = (argv: string[]): AutorestArgs => {
  const cwd = process.cwd();
  
  const result: any = {};
  for (const arg of argv) {
    const match = /^--([^=:]+)([=:](.+))?$/g.exec(arg);
    if (match) {
      const key = match[1];
      let rawValue = match[3] || "true";
      if (rawValue.startsWith(".")) {
        // starts with a . or .. -> this is a relative path to current directory
        rawValue = join(cwd, rawValue);
      }

      // untildify!
      if (/^~[/|\\]/g.exec(rawValue)) {
        rawValue = join(homedir(), rawValue.substring(2));
      }

      let value;
      try {
        value = JSON.parse(rawValue);
        // restrict allowed types (because with great type selection comes great responsibility)
        if (typeof value !== "string" && typeof value !== "boolean") {
          value = rawValue;
        }
      } catch (e) {
        value = rawValue;
      }
      result[key] = value;
    }
  }
  return result;
}

