import { AutorestNormalizedConfiguration } from "./autorest-normalized-configuration";
import { IFileSystem } from "@azure-tools/datastore";
import { CreateFileOrFolderUri, EnsureIsFolderUri, IsUri, ResolveUri } from "@azure-tools/uri";
import { cwd } from "process";
import { mergeConfigurations } from "./configuration-merging";
import { arrayOf } from "./utils";

export interface AutorestConfiguration extends AutorestNormalizedConfiguration {
  /**
   * Raw configuration that was used to build this config
   */
  raw: AutorestNormalizedConfiguration;

  configFileFolderUri: string;

  inputFileUris: string[];

  /**
   * Path to the output folder.
   */
  outputFolderUri: string;

  /**
   * List of configuration files used to create this config.
   */
  configurationFiles: string[];

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

export const createAutorestConfiguration = async (
  configFileFolderUri: string,
  rawConfig: AutorestNormalizedConfiguration,
  configurationFiles: string[],
  fileSystem: IFileSystem,
): Promise<AutorestConfiguration> => {
  const config: AutorestConfiguration = createConfigFromRawConfig(configFileFolderUri, rawConfig, configurationFiles);

  const inputFiles = await Promise.all(
    arrayOf<string>(rawConfig["input-file"]).map((each) =>
      resolveAsPath(configFileFolderUri, config, each, fileSystem),
    ),
  );

  const filesToExclude = await Promise.all(
    arrayOf<string>(rawConfig["exclude-file"]).map((each) =>
      resolveAsPath(configFileFolderUri, config, each, fileSystem),
    ),
  );

  config.inputFileUris = inputFiles.filter((x) => !filesToExclude.includes(x));
  return config;
};

export const createConfigFromRawConfig = (
  configFileFolderUri: string,
  rawConfig: AutorestNormalizedConfiguration,
  configurationFiles: string[],
): AutorestConfiguration => {
  const baseFolderUri = getBaseFolderUri(configFileFolderUri, rawConfig);

  return {
    ...rawConfig,
    raw: rawConfig,
    configFileFolderUri: configFileFolderUri,
    inputFileUris: [],
    configurationFiles: configurationFiles,
    outputFolderUri: resolveAsWriteableFolder(baseFolderUri, <string>rawConfig["output-folder"]),
    help: Boolean(rawConfig.help),
    verbose: Boolean(rawConfig.verbose),
    cachingEnabled: Boolean(rawConfig.cache),
    cacheExclude: getCacheExclude(rawConfig),
    debug: Boolean(rawConfig.debug),
  };
};

const getCacheExclude = (config: AutorestNormalizedConfiguration) => {
  const cache = config["cache"];
  return cache && cache.exclude ? arrayOf<string>(cache.exclude) : [];
};

export const extendAutorestConfiguration = (
  config: AutorestConfiguration,
  overrides: AutorestNormalizedConfiguration[],
): AutorestConfiguration => {
  const rawConfig = mergeConfigurations([...overrides, config.raw]);
  const newConfig = createConfigFromRawConfig(config.configFileFolderUri, rawConfig, config.configurationFiles);
  newConfig.inputFileUris = config.inputFileUris;
  return newConfig;
};

export function* getNestedConfiguration(
  config: AutorestConfiguration,
  pluginName: string,
): Iterable<AutorestConfiguration> {
  const pp = pluginName.split(".");
  if (pp.length > 1) {
    const n = getNestedConfiguration(config, pp[0]);
    for (const s of n) {
      yield* getNestedConfiguration(s, pp.slice(1).join("."));
    }
    return;
  }

  for (const section of arrayOf<any>(config.raw[pluginName as keyof AutorestNormalizedConfiguration])) {
    if (section) {
      yield extendAutorestConfiguration(config, section === true ? [] : [section]);
    }
  }
}

export const resolveAsPath = (
  configFileFolderUri: string,
  config: AutorestConfiguration,
  path: string,
  fileSystem: IFileSystem,
): Promise<string> => {
  // is there even a potential for a parent folder from the input configuruation
  const parentFolder = config.__parents?.[path];
  const fromBaseUri = ResolveUri(getBaseFolderUri(configFileFolderUri, config), path);

  // if it's an absolute uri already, give it back that way.
  if (IsUri(path) || !parentFolder) {
    return Promise.resolve(fromBaseUri);
  }

  // let it try relative to the file that loaded it.
  // if the relative-to-parent path isn't valid, we fall back to original behavior
  // where the file path is relative to the base uri.
  // (and we don't even check to see if that's valid, try-require wouldn't need valid files)
  const fromLoadedFile = ResolveUri(parentFolder, path);
  return fileSystem.ReadFile(fromLoadedFile).then(
    () => fromLoadedFile,
    () => fromBaseUri,
  );
};

export const getBaseFolderUri = (configFileFolderUri: string, config: AutorestNormalizedConfiguration) =>
  EnsureIsFolderUri(ResolveUri(configFileFolderUri, <string>config["base-folder"]));

const resolveAsFolder = (baseFolderUri: string, path: string): string => {
  return EnsureIsFolderUri(ResolveUri(baseFolderUri, path));
};

const resolveAsWriteableFolder = (baseFolderUri: string, path: string): string => {
  // relative paths are relative to the local folder when the base-folder is remote.
  if (!baseFolderUri.startsWith("file:")) {
    return EnsureIsFolderUri(ResolveUri(CreateFileOrFolderUri(cwd() + "/"), path));
  }
  return resolveAsFolder(baseFolderUri, path);
};
