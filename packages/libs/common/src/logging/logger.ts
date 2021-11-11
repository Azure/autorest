import { LoggingSession } from "./logging-session";
import {
  AutorestDiagnostic,
  AutorestError,
  AutorestLogger,
  AutorestWarning,
  LoggerAsyncProcessor,
  LoggerProcessor,
  LoggerSink,
  LogInfo,
} from "./types";
import { Progress } from ".";

export interface AutorestLoggerBaseOptions<T> {
  processors?: T[];
  sinks: LoggerSink[];
}

export abstract class AutorestLoggerBase<T> implements AutorestLogger {
  public diagnostics: AutorestDiagnostic[] = [];
  protected sinks: LoggerSink[];
  protected processors: T[];

  public constructor(options: AutorestLoggerBaseOptions<T>) {
    this.sinks = options.sinks;
    this.processors = options.processors ?? [];
  }

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

  public startProgress(initialName?: string) {
    const sinkProgressTrackers = this.sinks.map((x) => x.startProgress(initialName));

    const update = (progress: Progress) => {
      for (const tracker of sinkProgressTrackers) {
        tracker.update(progress);
      }
    };

    const stop = () => {
      for (const tracker of sinkProgressTrackers) {
        tracker.stop();
      }
    };

    return {
      update,
      stop,
    };
  }

  protected emitLog(log: LogInfo) {
    for (const sink of this.sinks) {
      sink.log(log);
    }
  }

  public abstract with(...processors: LoggerProcessor[]): AutorestLogger;
  public abstract trackDiagnostic(diagnostic: AutorestDiagnostic): void;
  public abstract log(log: LogInfo): void;
}

export interface AutorestLoggerOptions extends AutorestLoggerBaseOptions<LoggerProcessor> {}

export class AutorestSyncLogger extends AutorestLoggerBase<LoggerProcessor> {
  public diagnostics: AutorestDiagnostic[] = [];

  public constructor(options: AutorestLoggerOptions) {
    super(options);
  }

  public with(...processors: LoggerProcessor[]) {
    return new AutorestSyncLogger({
      sinks: this.sinks,
      processors: [...processors, ...this.processors],
    });
  }

  public override trackDiagnostic(diagnostic: AutorestDiagnostic) {
    const processed = this.process(diagnostic);
    if (processed === undefined) {
      return;
    }
    this.diagnostics.push(processed as any);
    this.emitLog(processed);
  }

  public override log(log: LogInfo) {
    const processed = this.process(log);
    if (processed === undefined) {
      return;
    }
    this.emitLog(processed);
  }

  protected emitLog(log: LogInfo) {
    for (const sink of this.sinks) {
      sink.log(log);
    }
  }

  protected process(log: LogInfo): LogInfo | undefined {
    let current = log;

    for (const processor of this.processors) {
      const processed = processor.process(log);
      if (processed === undefined) {
        return undefined;
      } else {
        current = processed;
      }
    }

    return current;
  }
}

export interface AutorestAsyncLoggerOptions extends AutorestLoggerBaseOptions<LoggerProcessor | LoggerAsyncProcessor> {
  asyncSession: LoggingSession;
}

export class AutorestAsyncLogger extends AutorestLoggerBase<LoggerProcessor | LoggerAsyncProcessor> {
  public diagnostics: AutorestDiagnostic[] = [];
  private asyncSession: LoggingSession;

  public constructor(options: AutorestAsyncLoggerOptions) {
    super(options);
    this.asyncSession = options.asyncSession;
  }

  public with(...processors: Array<LoggerProcessor | LoggerAsyncProcessor>) {
    return new AutorestAsyncLogger({
      asyncSession: this.asyncSession,
      sinks: this.sinks,
      processors: [...processors, ...this.processors],
    });
  }

  protected emitLog(log: LogInfo) {
    for (const sink of this.sinks) {
      sink.log(log);
    }
  }

  public override log(log: LogInfo) {
    this.asyncSession.registerLog(() => this.logMessageAsync(log));
  }

  public override trackDiagnostic(diagnostic: AutorestDiagnostic) {
    this.asyncSession.registerLog(() => this.trackDiagnosticAsync(diagnostic));
  }

  private async logMessageAsync(log: LogInfo) {
    const processed = await this.process(log);
    if (processed === undefined) {
      return;
    }
    this.emitLog(processed);
  }

  private async trackDiagnosticAsync(diagnostic: AutorestDiagnostic) {
    const processed = await this.process(diagnostic);
    if (processed === undefined) {
      return;
    }
    this.diagnostics.push(processed as any);
    this.emitLog(processed);
  }

  protected async process(log: LogInfo): Promise<LogInfo | undefined> {
    let current = log;
    for (const processor of this.processors) {
      const processed = await processor.process(log);
      if (processed === undefined) {
        return undefined;
      } else {
        current = processed;
      }
    }

    return current;
  }
}
