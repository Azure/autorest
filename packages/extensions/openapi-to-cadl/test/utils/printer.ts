// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

/* eslint-disable @typescript-eslint/no-explicit-any */

import * as path from "path";
import * as chalk from "chalk";

const printModes = ["info", "warn", "error", "success", "debug"] as const;

export type Fn<T = void> = (...values: any[]) => T;
export type ModeMap<T> = { [k in typeof printModes[number]]: T };

// Compute the base directory of the dev-tool command package
// We must do this specially for the printer module because using
// the package resolution function from the utils/resolveProject
// module would create a difficult circular dependency.
const DEV_TOOL_PATH = (() => {
  const directoryFragment = path.sep + "dev-tool" + path.sep;
  const parts = __dirname.split(directoryFragment);
  // There might be "/dev-tool/" somewhere higher in the path, so
  // we will slice the end off of this array and re-join with "/dev-tool/"
  // to get the full directory part
  const baseDirectoryParts = parts.slice(0, -1);
  // Adding path.sep at the end makes the debug output a little cleaner by removing a leading "/"
  return path.resolve(baseDirectoryParts.join(directoryFragment) + directoryFragment) + path.sep;
})();

/**
 * The interface that describes the Printer produced by {@link createPrinter}
 */
export interface Printer extends ModeMap<Fn> {
  (...values: any[]): void;
}

export interface PrinterBackend {
  error: Fn;
  log: Fn;
  info: Fn;
  warn: Fn;
  trace: Fn;
}

/**
 * The object that is used to write output.
 */
let backend: PrinterBackend = {
  error: console.error,
  log: console.log,
  info: console.info,
  warn: console.warn,
  trace: console.trace,
};

/**
 * Change the backend used to print output. This function will
 * replace the methods of the existing backend with those specified
 * in `update`, but will leave unspecified methods intact.
 *
 * @param backend partial specification of a PrinterBackend
 */
export function updateBackend(update: Partial<PrinterBackend>): void {
  backend = {
    ...backend,
    ...update,
  };
}

/**
 * Gets the filename of the calling function
 */
function getCaller(): NodeJS.CallSite | undefined {
  const savedPrepareStackTrace = Error.prepareStackTrace;

  let caller: NodeJS.CallSite | undefined = undefined;
  try {
    const error = new Error() as any as { stack: NodeJS.CallSite[] };

    Error.prepareStackTrace = (_, stack) => stack;

    const next = () => error.stack.shift();

    const current = next();

    while (error.stack.length > 0 && current !== caller) {
      caller = next();
    }
    // eslint-disable-next-line no-empty
  } catch (_) {}

  Error.prepareStackTrace = savedPrepareStackTrace;

  return caller;
}

const colors: ModeMap<Fn<string>> = {
  info: chalk.blueBright,
  warn: chalk.yellow,
  error: chalk.red,
  debug: chalk.magenta,
  success: chalk.green,
};

const finalLogger: ModeMap<Fn> = {
  info(...values) {
    backend.info(...values);
  },
  warn(...values) {
    backend.warn(...values);
  },
  error(...values) {
    backend.error(...values);
  },
  debug(...values: string[]) {
    if (process.env.DEBUG) {
      const caller = getCaller();
      const fileName = caller?.getFileName()?.split(DEV_TOOL_PATH)?.[1];
      const callerInfo = `(@ ${fileName ? fileName : "<unknown>"}#${
        caller?.getFunctionName() ?? "<anonymous>"
      }:${caller?.getLineNumber()}:${caller?.getColumnNumber()})`;
      backend.error(values[0], colors.debug(callerInfo), ...values.slice(1));
    }
  },
  success: console.info,
};

/**
 * Create a pre-configured console printer for a given namespace.
 *
 * ```javascript
 * const log = createPrinter("my-command");
 * ```
 *
 * The printer can be called directly (`log("A message")`), or a
 * log level can be specified (`log.error("An error message")`).
 *
 * The printer outputs `[<name>]` before each message and colorizes terminal
 * output as appropriate using `chalk` according to the log level. The colors are:
 *
 * - no log level (called directly): white
 * - info: bright blue (ANSI #12)
 * - warn: yellow (ANSI #3)
 * - error: red (ANSI #1)
 * - debug: magenta (ANSI #5)
 * - success: green (ANSI #2)
 *
 * @param name the namespace to format log messages with
 */
export function createPrinter(name: string): Printer {
  const prefix = "[" + name + "]";
  const base = ((...values: string[]) => console.log(chalk.reset(prefix, ...values))) as Printer;

  for (const mode of printModes) {
    base[mode] = (...values: string[]) =>
      finalLogger[mode](...[prefix, ...values].map((value: string) => colors[mode](value)));
  }
  return base;
}
