import { createLogFormatter, LogFormatter } from "./formatter";
import { AutorestLoggerBase } from "./logger";
import { LogInfo } from "./types";

export interface ConsoleLoggerOptions {
  format?: "json" | "regular";
  color?: boolean;
  timestamp?: boolean;
}

/**
 * Simple logger which takes log info as it is and logs it.
 * Doesn't resolve original source locations.
 */
export class ConsoleLogger extends AutorestLoggerBase {
  private formatter: LogFormatter;

  public constructor(options: ConsoleLoggerOptions = {}) {
    super();
    this.formatter = createLogFormatter(options.format, options);
  }

  public log(log: LogInfo) {
    const line = this.formatter.log(log);
    // eslint-disable-next-line no-console
    console.log(line);
  }
}
