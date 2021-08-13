import { AutorestDiagnostic, AutorestError, AutorestLogger, AutorestWarning, LogInfo, LogLevel } from "./types";

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

/**
 * Logger that doesn't do anything.
 */
export class AutorestNoopLogger extends AutorestLoggerBase {
  public log(log: LogInfo) {
    // Nothing to do.
  }
}
