import { EnhancedPosition, PathPosition, Position } from "@azure-tools/datastore";

export type LogLevel = "debug" | "verbose" | "information" | "warning" | "error" | "fatal";

/**
 * Represent a location in a document.
 */
export interface SourceLocation {
  readonly document: string;
  readonly position: Position | PathPosition;
}

export interface LogInfo {
  /**
   * Log level
   */
  readonly level: LogLevel;

  /**
   * Message.
   */
  readonly message: string;

  /**
   * Reprensent the diagnostic code describing the type of issue.
   * Diagnostic codes could be documented to help user understand how to resolve this type of issue
   */
  readonly code?: string;

  /**
   * location where the problem was found.
   */
  readonly source?: SourceLocation[];

  /**
   * Additional details.
   */
  readonly details?: Error | unknown;

  /**
   * Name of the plugin currently emitting this warning
   * @example "emitter", "python", "m2r"
   */
  readonly pluginName?: string;

  /**
   * Name of the extension currently emitting this warning
   * @example "@autorest/modelerfour", "@autorest/pyton"
   */
  readonly extensionName?: string;
}

export interface AutorestDiagnostic {
  level: Extract<LogLevel, "error" | "warning">;

  /**
   * Reprensent the diagnostic code describing the type of issue.
   * Diagnostic codes could be documented to help user understand how to resolve this type of issue
   */
  readonly code: string;

  /**
   * Message.
   */
  readonly message: string;

  /**
   * location where the problem was found.
   */
  readonly source?: SourceLocation[];

  /**
   * Additional details.
   */
  readonly details?: Error | unknown;
}

export interface AutorestError extends Omit<AutorestDiagnostic, "level"> {}

export interface AutorestWarning extends Omit<AutorestDiagnostic, "level"> {}

export interface Progress {
  /**
   * Current step.
   */
  current: number;

  /**
   * Total number of steps.
   */
  total: number;

  /**
   * Optional name
   */
  name?: string;
}

export interface ProgressTracker {
  update(progress: Progress): void;
  stop(): void;
}

/**
 * AutorestLogger is an interface for the autorest logger that can be passed around in plugins.
 * This can be used to log information, debug logs or track errors and warnings.
 */
export interface IAutorestLogger {
  debug(message: string): void;

  verbose(message: string): void;

  info(message: string): void;

  fatal(message: string): void;

  /**
   * Track an error that occurred.
   */
  trackError(error: AutorestError): void;

  /**
   * Track an warning that occurred.
   */
  trackWarning(error: AutorestWarning): void;

  log(log: LogInfo): void;

  startProgress(initialName?: string): ProgressTracker;
}

export interface AutorestLogger extends IAutorestLogger {
  with(...processors: LoggerProcessor[]): AutorestLogger;

  diagnostics: AutorestDiagnostic[];
}

export interface LoggerProcessor {
  /**
   * Transform the provided log info.
   * Returns undefined if the log should not be emitted.
   * @param log Log entry to process.
   */
  process(log: LogInfo): LogInfo | undefined;
}

export interface LoggerAsyncProcessor {
  /**
   * Transform the provided log info.
   * Returns undefined if the log should not be emitted.
   * @param log Log entry to process.
   */
  process(log: LogInfo): Promise<LogInfo | undefined>;
}

export interface LoggerSink {
  log(info: LogInfo): void;
  startProgress(initialName?: string): ProgressTracker;
}

export type EnhancedLogInfo = Omit<LogInfo, "source"> & {
  readonly source?: EnhancedSourceLocation[];
};

export interface EnhancedSourceLocation {
  document: string;
  position: EnhancedPosition;
}
