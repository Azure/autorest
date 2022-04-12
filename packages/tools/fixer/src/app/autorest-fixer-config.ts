import { FixCode } from "./types";

export const AllFixers = Symbol("AllFixer");

export interface AutorestFixerConfig {
  include: string[];

  /**
   * If the fixer should just do a dry run.
   */
  dryRun?: boolean;

  /**
   * List of fixers to run.
   */
  fixers: FixCode[] | typeof AllFixers;
}
