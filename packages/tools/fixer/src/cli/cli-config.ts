export interface CliConfig {
  // Logging
  verbose?: boolean;
  debug?: boolean;
  level?: string;

  /**
   * List of pattern containing definition files.
   */
  include: string[];

  /**
   * If this should just be a dry run.
   */
  "dry-run"?: boolean;

  /**
   * List of fixers to run.
   */
  fixers?: string;
}
