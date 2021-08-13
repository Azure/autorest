import { createLogFormatter, LogFormatter } from "./formatter";
import { LogSourceEnhancer } from "./log-source-enhancer";
import { AutorestError, AutorestLogger, AutorestWarning, LogInfo, LogLevel } from "./types";
import { DataStore } from "@azure-tools/datastore";
import { LoggingSession } from "./logging-session";
import { color } from "../utils";

export interface AutorestLoggerOptions {
  format?: "json" | "regular";
  level?: LogLevel;
}

export abstract class AutorestLoggerBase implements AutorestLogger {
  public constructor(private level: LogLevel = "information") {}

  public debug(message: string) {
    this.log({
      level: "debug",
      message,
    });
  }

  public verbose(message: string) {
    this.log({
      level: "verbose",
      message,
    });
  }

  public info(message: string) {
    this.log({
      level: "information",
      message,
    });
  }

  public fatal(message: string) {
    this.log({
      level: "fatal",
      message,
    });
  }

  public trackWarning(warning: AutorestWarning) {
    this.log({
      level: "warning",
      ...warning,
    });
  }

  public trackError(error: AutorestError) {
    this.log({
      level: "error",
      ...error,
    });
  }

  public log(log: LogInfo): void {
    if (!shouldLog(log, this.level)) {
      return;
    }
    this.logIgnoreLevel(log);
  }

  public abstract logIgnoreLevel(log: LogInfo): void;
}

export class AutorestCoreLogger extends AutorestLoggerBase {
  private logInfoEnhancer: LogSourceEnhancer;
  private simpleLogger: AutorestSimpleLogger;
  // private suppressor: Suppressor;

  public constructor(options: AutorestLoggerOptions, private asyncLogManager: LoggingSession, dataStore: DataStore) {
    super();
    // this.suppressor = new Suppressor(config);
    this.logInfoEnhancer = new LogSourceEnhancer(dataStore);
    this.simpleLogger = new AutorestSimpleLogger(options);
  }

  public logIgnoreLevel(log: LogInfo) {
    this.asyncLogManager.registerLog(() => this.logMessageAsync(log));
  }

  private async logMessageAsync(log: LogInfo) {
    const enhancedLog = await this.logInfoEnhancer.process(log);
    // eslint-disable-next-line no-console
    this.simpleLogger.logIgnoreLevel(enhancedLog as any);
  }
}

/**
 * Simple logger which takes log info as it is and logs it.
 * Doesn't resolve original source locations.
 */
export class AutorestSimpleLogger extends AutorestLoggerBase {
  private formatter: LogFormatter;
  // private suppressor: Suppressor;

  public constructor(options: AutorestLoggerOptions = {}) {
    super(options.level);
    this.formatter = createLogFormatter(options.format);
  }

  public logIgnoreLevel(log: LogInfo) {
    const line = this.formatter.log(log);

    // eslint-disable-next-line no-console
    console.log(color(line));
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
