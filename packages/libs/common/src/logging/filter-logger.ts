import { AutorestLoggerBase } from "./logger";
import { AutorestLogger, LogInfo, LogLevel } from "./types";

export interface AutorestFilterLoggerOptions {
  level: LogLevel;
  logger: AutorestLogger;
}

/**
 * Logger adding filtering functionality based on:
 *  - level: only show log with level higher than the configuration.
 */
export class AutorestFilterLogger extends AutorestLoggerBase {
  private level: LogLevel;
  private innerLogger: AutorestLogger;

  public constructor(options: AutorestFilterLoggerOptions) {
    super();
    this.level = options.level;
    this.innerLogger = options.logger;
  }

  public log(log: LogInfo): void {
    if (!shouldLog(log, this.level)) {
      return;
    }
    this.innerLogger.log(log);
  }
}

const LOG_LEVEL: Record<LogLevel, number> = {
  debug: 10,
  verbose: 20,
  information: 30,
  warning: 40,
  error: 50,
  fatal: 60,
};

export function shouldLog(log: LogInfo, level: LogLevel) {
  return LOG_LEVEL[log.level] >= LOG_LEVEL[level];
}
