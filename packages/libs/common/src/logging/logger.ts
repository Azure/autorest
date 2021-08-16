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
    this.trackDiagnostic({
      level: "warning",
      ...warning,
    });
  }

  public trackError(error: AutorestError) {
    this.trackDiagnostic({
      level: "error",
      ...error,
    });
  }

  public trackDiagnostic(diagnostic: AutorestDiagnostic) {
    this.diagnostics.push(diagnostic);
    this.log(diagnostic);
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
