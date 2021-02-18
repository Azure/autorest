import { AutorestLogger, evaluateGuard, mergeOverwriteOrAppend } from "@autorest/common";
import { DataSink, DataSource, DataStore, IFileSystem } from "@azure-tools/datastore";
import { AutorestConfiguration, createConfigFromRawConfig } from "../autorest-configuration";
import { AutorestRawConfiguration } from "../autorest-raw-configuration";
import { ConditionalConfiguration, ConfigurationFile, readConfigurationFile } from "./configuration-file";

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

interface SimpleConfiguration {
  type: "simple";
  config: AutorestRawConfiguration;
}

type ConfigurationItem = ConfigurationFile | SimpleConfiguration;

/**
 * Class organizing configurations and merging them together.
 */
export class ConfigurationManager {
  private configItems: ConfigurationItem[] = [];
  private fsView: DataSource;

  public constructor(private fileSystem: IFileSystem, private dataStore: DataStore, private logger: AutorestLogger) {
    this.fsView = dataStore.GetReadThroughScope(this.fileSystem);
  }

  public addConfig(config: AutorestRawConfiguration) {
    this.configItems.push({ type: "simple", config });
  }

  public addConfigFile(file: ConfigurationFile) {
    this.configItems.push(file);
  }

  public async addRawConfigFile(fileUri: string) {
    const data = await this.fsView.ReadStrict(fileUri);
    const file = await readConfigurationFile(data, this.logger, this.dataStore.getDataSink());
    this.configItems.push(file);
  }

  public resolveConfig(): AutorestConfiguration {
    let current = initialConfig;

    // TODO-TIM take into account load-priority
    for (const configItem of this.configItems) {
      if (configItem.type === "file") {
        current = this.mergeConfigFile(current, configItem);
      } else if (configItem.type === "simple") {
        current = mergeOverwriteOrAppend(current, configItem.config);
      }
    }

    // Finally apply default config.
    current = mergeOverwriteOrAppend(current, defaultConfig);

    // TODO-TIM check those params
    return createConfigFromRawConfig("", current, {});
  }

  /**
   * Merge the given config file into the given config. Config file doesn't override values.
   * @param config Current config. Will be used to resolve values in the config file.(Such as condition or interpolate values).
   * @param configFile Config file.
   */
  private mergeConfigFile(config: AutorestRawConfiguration, configFile: ConfigurationFile): AutorestRawConfiguration {
    let resolvedConfig = config;
    let current = {};

    for (const config of configFile.configs) {
      // if they say --profile: or --api-version: (or in config) then we force it to set the tag=all-api-versions
      // Some of the rest specs had a default tag set (really shouldn't have done that), which ... was problematic,
      // so this enables us to override that in the case they are asking for filtering to a profile or a api-verison
      const forceAllVersionsMode = Boolean(resolvedConfig["api-version"]?.length || resolvedConfig.profile?.length);

      const shouldInclude = shouldIncludeConditionalConfig(resolvedConfig, config, forceAllVersionsMode);
      if (shouldInclude) {
        current = mergeOverwriteOrAppend(config, current);
        resolvedConfig = mergeOverwriteOrAppend(config, current);
      }
    }

    return resolvedConfig;
  }
}

const shouldIncludeConditionalConfig = (
  context: AutorestRawConfiguration,
  config: ConditionalConfiguration,
  forceAllVersionsMode: boolean,
) => (config.condition ? evaluateGuard(config.condition, context, forceAllVersionsMode) : true);
