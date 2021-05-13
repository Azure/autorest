import { evaluateGuard, mergeOverwriteOrAppend } from "@autorest/common";
import { IFileSystem } from "@azure-tools/datastore";
import { AutorestConfiguration, createAutorestConfiguration } from "../autorest-configuration";
import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import { AUTOREST_INITIAL_CONFIG } from "../configuration-schema";
import { desugarRawConfig } from "../desugar";
import { ConditionalConfiguration, ConfigurationFile } from "./configuration-file";

const defaultConfig: AutorestNormalizedConfiguration = Object.freeze({
  "base-folder": ".",
  "output-folder": "generated",
  "debug": false,
  "verbose": false,
  "disable-validation": false,
});

interface SimpleConfiguration {
  type: "simple";
  config: AutorestNormalizedConfiguration;
}

type ConfigurationItem = ConfigurationFile | SimpleConfiguration;

/**
 * Class organizing configurations and merging them together.
 * Configuration should be added in order of higher priority to lower priority.
 * This means the first configs values will be able to be used in following configs.
 * This also means that if a property is defined in 2 config the first one will be the one kept.
 */
export class ConfigurationManager {
  private configItems: ConfigurationItem[] = [];

  public constructor(private configFileOrFolderUri: string, private fileSystem: IFileSystem) {}

  public async addConfig(config: AutorestNormalizedConfiguration) {
    this.configItems.push({ type: "simple", config: await desugarRawConfig(config) });
  }

  /**
   * Adds a configuration with high priority.
   * This means this configuration will be loaded first, its value will be able to be used in later configurations.
   * @param config Configuration.
   */
  public async addHighPriorityConfig(config: AutorestNormalizedConfiguration) {
    this.configItems.unshift({ type: "simple", config: await desugarRawConfig(config) });
  }

  /**
   * Adds a configuration.
   * @param config Configuration.
   */
  public addConfigFile(file: ConfigurationFile) {
    this.configItems.push(file);
  }

  /**
   * Resolve the @see AutorestConfiguration from all the configurations.
   * It will resolve potential condition for configuration file blocks to be included.
   */
  public async resolveConfig(): Promise<AutorestConfiguration> {
    let current = AUTOREST_INITIAL_CONFIG;

    const configFileNames = [];
    for (const configItem of this.configItems) {
      if (configItem.type === "file") {
        current = this.mergeConfigFile(current, configItem);
        configFileNames.push(configItem.fullPath);
      } else if (configItem.type === "simple") {
        current = mergeOverwriteOrAppend(current, configItem.config);
      }
    }

    // Finally apply default config.
    const finalConfig = mergeOverwriteOrAppend(current, defaultConfig);

    return createAutorestConfiguration(this.configFileOrFolderUri, finalConfig, configFileNames, this.fileSystem);
  }

  /**
   * Merge the given config file into the given config. Config file doesn't override values.
   * @param config Current config. Will be used to resolve values in the config file.(Such as condition or interpolate values).
   * @param configFile Config file.
   */
  private mergeConfigFile(
    config: AutorestNormalizedConfiguration,
    configFile: ConfigurationFile,
  ): AutorestNormalizedConfiguration {
    let currentFileResolution = { ...AUTOREST_INITIAL_CONFIG };
    const resolveConfig = () => mergeOverwriteOrAppend(config, currentFileResolution);

    for (const configBlock of configFile.configs) {
      const resolvedConfig = resolveConfig();
      // if they say --profile: or --api-version: (or in config) then we force it to set the tag=all-api-versions
      // Some of the rest specs had a default tag set (really shouldn't have done that), which ... was problematic,
      // so this enables us to override that in the case they are asking for filtering to a profile or a api-verison
      const forceAllVersionsMode = Boolean(resolvedConfig["api-version"]?.length || resolvedConfig.profile?.length);

      const shouldInclude = shouldIncludeConditionalConfig(resolvedConfig, configBlock, forceAllVersionsMode);
      if (shouldInclude) {
        currentFileResolution = mergeOverwriteOrAppend(configBlock.config, currentFileResolution, {
          arrayMergeStrategy: "low-pri-first", // We want arrays to be merged in the order of definition within the same file(First defined first in the array)
          interpolationContext: mergeOverwriteOrAppend(config, configBlock.config),
        });
      }
    }

    return resolveConfig();
  }
}

const shouldIncludeConditionalConfig = (
  context: AutorestNormalizedConfiguration,
  config: ConditionalConfiguration,
  forceAllVersionsMode: boolean,
) => (config.condition ? evaluateGuard(config.condition, context, forceAllVersionsMode) : true);
