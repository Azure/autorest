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
}

export interface AutorestDiagnostic {
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

export interface AutorestError extends AutorestDiagnostic {}

export interface AutorestWarning extends AutorestDiagnostic {}

/**
 * AutorestLogger is an interface for the autorest logger that can be passed around in plugins.
 * This can be used to log information, debug logs or track errors and warnings.
 */
export interface AutorestLogger {
  /**
   * TODO-TIM:
   * Idea here is to have stage be able to report error and warning with a defined code + message.
   * The pipeline runner would then be able to fail if any error or warnings were reported either at the end of the stage or at the very end of the run.
   * Provide a way for the user to supress some warnings.
   */

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
}

export type EnhancedLogInfo = Omit<LogInfo, "source"> & {
  readonly source?: EnhancedSourceLocation[];
};

export interface EnhancedSourceLocation {
  document: string;
  position: EnhancedPosition;
}
