import { AutoRestRawConfiguration, mergeConfigurations } from "./auto-rest-raw-configuration";

// TODO-TIM don't extend
export interface AutorestConfiguration extends AutoRestRawConfiguration {
  /**
   * Raw configuration that was used to build this config
   */
  raw: AutoRestRawConfiguration;

  inputFileUris: string[];

  // TODO-TIM check type?
  configurationFiles: { [key: string]: any };
  name?: string;
  to?: string;
}

export const createAutorestConfiguration = async (
  configurationFiles: { [key: string]: any },
  configs: AutoRestRawConfiguration[],
): Promise<AutorestConfiguration> => {
  const initialConfig: AutoRestRawConfiguration = {
    "directive": [],
    "input-file": [],
    "exclude-file": [],
    "profile": [],
    "output-artifact": [],
    "require": [],
    "try-require": [],
    "use": [],
    "pass-thru": [],
  };

  const defaultConfig: AutoRestRawConfiguration = {
    "base-folder": ".",
    "output-folder": "generated",
    "debug": false,
    "verbose": false,
    "disable-validation": false,
  };
  const rawConfig = mergeConfigurations(initialConfig, ...configs, defaultConfig);

  // const inputFiles = await Promise.all(
  //   arrayOf<string>(rawConfig["input-file"]).map((each) => ResolveAsPath(each)),
  // );
  // const filesToExclude = await Promise.all(
  //   arrayOf<string>(rawConfig["exclude-file"]).map((each) => ResolveAsPath(each)),
  // );
  const inputFileUris = [];
  // const inputFileUris = inputFiles.filter((x) => !filesToExclude.includes(x));
  const config: AutorestConfiguration = {
    ...rawConfig,
    raw: rawConfig,
    inputFileUris,
    configurationFiles: configurationFiles,
  };
  return config;
};

export const getNestedAutorestConfiguration = (
  config: AutorestConfiguration,
  scopes: AutoRestRawConfiguration[],
): AutorestConfiguration => {
  const rawConfig = mergeConfigurations(...scopes, config);
  const newConfig: AutorestConfiguration = {
    ...rawConfig,
    raw: rawConfig,
    inputFileUris: config.inputFileUris,
    configurationFiles: config.configurationFiles,
  };
  return newConfig;
};
