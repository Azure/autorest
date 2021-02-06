import { AutorestConfiguration, AutorestRawConfiguration, arrayOf, valuesOf } from "@autorest/configuration";
import { IFileSystem } from "@azure-tools/datastore";
import { CreateFileOrFolderUri, EnsureIsFolderUri, IsUri, ResolveUri } from "@azure-tools/uri";
import { cwd } from "process";
import { mergeConfigurations } from "./configuration-merging";

export const createAutorestConfiguration = async (
  configFileFolderUri: string,
  configurationFiles: { [key: string]: any },
  configs: AutorestRawConfiguration[],
  fileSystem: IFileSystem,
): Promise<AutorestConfiguration> => {
  const initialConfig: AutorestRawConfiguration = {
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

  const defaultConfig: AutorestRawConfiguration = {
    "base-folder": ".",
    "output-folder": "generated",
    "debug": false,
    "verbose": false,
    "disable-validation": false,
  };
  const rawConfig = mergeConfigurations(initialConfig, ...configs, defaultConfig);

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

const createConfigFromRawConfig = (
  configFileFolderUri: string,
  rawConfig: AutorestRawConfiguration,
  configurationFiles: { [key: string]: string },
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

const getCacheExclude = (config: AutorestRawConfiguration) => {
  const cache = config["cache"];
  return cache && cache.exclude ? [...valuesOf<string>(cache.exclude)] : [];
};

export const extendAutorestConfiguration = (
  config: AutorestConfiguration,
  overrides: AutorestRawConfiguration[],
): AutorestConfiguration => {
  const rawConfig = mergeConfigurations(...overrides, config);
  const newConfig = createConfigFromRawConfig(config.configFileFolderUri, rawConfig, config.configurationFiles);
  newConfig.inputFileUris = config.inputFileUris;
  return newConfig;
};

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

export const getBaseFolderUri = (configFileFolderUri: string, config: AutorestRawConfiguration) =>
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
