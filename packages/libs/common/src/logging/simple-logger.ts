import { createLogFormatter, LogFormatter } from "./formatter";
import { AutorestLoggerBase } from "./logger";
import { LogInfo } from "./types";

export interface AutorestSimpleLoggerOptions {
  format?: "json" | "regular";
  color?: boolean;
  timestamp?: boolean;
}

/**
 * Simple logger which takes log info as it is and logs it.
 * Doesn't resolve original source locations.
 */
export class AutorestSimpleLogger extends AutorestLoggerBase {
  private formatter: LogFormatter;
  // private suppressor: Suppressor;

  public constructor(options: AutorestSimpleLoggerOptions = {}) {
    super();
    this.formatter = createLogFormatter(options.format, options);
  }

  public log(log: LogInfo) {
    const line = this.formatter.log(log);
    // eslint-disable-next-line no-console
    console.log(line);
  }
}
