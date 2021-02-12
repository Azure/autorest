import { AutorestRawConfiguration } from "./autorest-raw-configuration";

// TODO-TIM don't extend
export interface AutorestConfiguration extends AutorestRawConfiguration {
  /**
   * Raw configuration that was used to build this config
   */
  raw: AutorestRawConfiguration;

  configFileFolderUri: string;

  inputFileUris: string[];

  /**
   * Path to the output folder.
   */
  outputFolderUri: string;

  // TODO-TIM check type?
  configurationFiles: { [key: string]: any };

  /**
   * If help was requested.
   */
  help: boolean;

  /**
   * If logging should be verbose.
   */
  verbose: boolean;

  /**
   * If running in debug mode.
   */
  debug: boolean;

  /**
   * If running in caching mode.
   */
  cachingEnabled: boolean;

  /**
   * list of files to exclude from caching.
   */
  cacheExclude: string[];

  // TODO-TIM check those?
  name?: string;
  to?: string;
}
