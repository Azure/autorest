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
   * Track an actual error
   */
  trackError(error: AutorestError): void;
}
