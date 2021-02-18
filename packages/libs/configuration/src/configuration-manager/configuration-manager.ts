import { evaluateGuard, mergeOverwriteOrAppend } from "@autorest/common";
import { IFileSystem } from "@azure-tools/datastore";
import { AutorestConfiguration } from "../autorest-configuration";
import { AutorestRawConfiguration } from "../autorest-raw-configuration";
import { ConditionalConfiguration, ConfigurationFile } from "./configuration-file";

const initialConfig: AutorestRawConfiguration = Object.freeze({
  "directive": [],
  "input-file": [],
  "exclude-file": [],
  "profile": [],
  "output-artifact": [],
  "require": [],
  "try-require": [],
  "use": [],
  "pass-thru": [],
});

const defaultConfig: AutorestRawConfiguration = Object.freeze({
  "base-folder": ".",
  "output-folder": "generated",
  "debug": false,
  "verbose": false,
  "disable-validation": false,
});

/**
 * Class organizing configurations and merging them together.
 */
export class ConfigurationManager {
  private configFiles: ConfigurationFile[] = [];

  public constructor(private fileSystem: IFileSystem) {}

  public addConfigFile(file: ConfigurationFile) {
    this.configFiles.push(file);
  }

  public resolveConfig(): AutorestConfiguration {
    let current = initialConfig;

    // TODO-TIM take into account load-priority
    for (const configFile of this.configFiles) {
      current = this.mergeConfigFile(current, configFile);
    }
    return null!;
  }

  private mergeConfigFile(initial: AutorestRawConfiguration, configFile: ConfigurationFile) {
    let current = initial;
    for (const config of configFile.configs) {
      const shouldInclude = shouldIncludeConditionalConfig(current, config);
      if (shouldInclude) {
        current = mergeOverwriteOrAppend(config, current);
      }
    }

    return current;
  }
}

const shouldIncludeConditionalConfig = (context: AutorestRawConfiguration, config: ConditionalConfiguration) =>
  config.condition ? evaluateGuard(config.condition, context) : true;
