import { EnhancedPosition } from "@azure-tools/datastore";

export interface SourceLocation {
  document: string;
  position: EnhancedPosition;
}

export interface AutorestError {
  code: string;
  message: string;
  source?: SourceLocation[];
}

// TODO-TIM check on design here.
export interface AutorestLogger {
  /**
   * TODO:
   * Idea here is to have stage be able to report error and warning with a defined code + message.
   * The pipeline runner would then be able to fail if any error or warnings were reported either at the end of the stage or at the very end of the run.
   * Provide a way for the user to supress some warnings.
   */

  /**
   * Track an error that occurred.
   */
  trackError(error: AutorestError): void;
}
