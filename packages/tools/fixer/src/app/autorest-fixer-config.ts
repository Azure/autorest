export interface AutorestFixerConfig {
  include: string[];

  /**
   * If the fixer should just do a dry run.
   */
  dryRun?: boolean;
}
