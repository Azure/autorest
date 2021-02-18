import { AutorestRawConfiguration } from "../autorest-raw-configuration";

export interface ConfigurationFile {
  type: "file";

  /**
   * Full path to the file.
   */
  fullPath: string;

  /**
   * Set of raw configurations.
   */
  configs: ConditionalConfiguration[];
}

export interface ConditionalConfiguration {
  condition?: string;
  config: AutorestRawConfiguration;
}
