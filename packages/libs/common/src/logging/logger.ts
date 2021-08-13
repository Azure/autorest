import { createLogFormatter, LogFormatter } from "./formatter";
import { LogSourceEnhancer } from "./log-source-enhancer";
import { AutorestDiagnostic, AutorestError, AutorestLogger, AutorestWarning, LogInfo, LogLevel } from "./types";
import { DataStore } from "@azure-tools/datastore";
import { LoggingSession } from "./logging-session";
import { color } from "../utils";

export abstract class AutorestLoggerBase implements AutorestLogger {
  public diagnostics: AutorestDiagnostic[] = [];

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
    const diag = {
      level: "warning",
      ...warning,
    } as const;
    this.diagnostics.push(diag);
    this.log(diag);
  }

  public trackError(error: AutorestError) {
    const diag = {
      level: "error",
      ...error,
    } as const;
    this.diagnostics.push(diag);
    this.log(diag);
  }

  public abstract log(log: LogInfo): void;
}

export interface AutorestCoreLoggerOptions {
  logger: AutorestLogger;
}

export class AutorestCoreLogger extends AutorestLoggerBase {
  private logInfoEnhancer: LogSourceEnhancer;
  private innerLogger: AutorestLogger;
  // private suppressor: Suppressor;

  public constructor(
    options: AutorestCoreLoggerOptions,
    private asyncLogManager: LoggingSession,
    dataStore: DataStore,
  ) {
    super();
    // this.suppressor = new Suppressor(config);
    this.logInfoEnhancer = new LogSourceEnhancer(dataStore);
    this.innerLogger = options.logger;
  }

  public log(log: LogInfo) {
    this.asyncLogManager.registerLog(() => this.logMessageAsync(log));
  }

  private async logMessageAsync(log: LogInfo) {
    const enhancedLog = await this.logInfoEnhancer.process(log);
    // eslint-disable-next-line no-console
    this.innerLogger.log(enhancedLog as any);
  }
}

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

export interface AutorestSimpleLoggerOptions {
  format?: "json" | "regular";
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
    this.formatter = createLogFormatter(options.format);
  }

  public log(log: LogInfo) {
    const line = this.formatter.log(log);

    // eslint-disable-next-line no-console
    console.log(color(line));
  }
}

/**
 * Logger that doesn't do anything.
 */
export class AutorestNoopLogger extends AutorestLoggerBase {
  public log(log: LogInfo) {
    // Nothing to do.
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
