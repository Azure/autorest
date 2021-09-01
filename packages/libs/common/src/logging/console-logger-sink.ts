import { createLogFormatter, LogFormatter } from "./formatter";
import { AutorestSyncLogger } from "./logger";
import { LoggerSink, LogInfo } from "./types";

export interface ConsoleLoggerSinkOptions {
  format?: "json" | "regular";
  color?: boolean;
  timestamp?: boolean;
}

/**
 * Logger sink to output logs to the console.
 */
export class ConsoleLoggerSink implements LoggerSink {
  private formatter: LogFormatter;

  public constructor(options: ConsoleLoggerSinkOptions = {}) {
    this.formatter = createLogFormatter(options.format, options);
  }

  public log(log: LogInfo) {
    const line = this.formatter.log(log);
    // eslint-disable-next-line no-console
    console.log(line);
  }
}

/**
 * Simple logger which takes log info as it is and logs it.
 * Doesn't resolve original source locations.
 */
export class ConsoleLogger extends AutorestSyncLogger {
  public constructor(options: ConsoleLoggerSinkOptions = {}) {
    super({ sinks: [new ConsoleLoggerSink(options)] });
  }
}
