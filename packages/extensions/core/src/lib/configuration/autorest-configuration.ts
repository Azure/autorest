import { IFileSystem } from "@azure-tools/datastore";
import { CreateFileOrFolderUri, EnsureIsFolderUri, IsUri, ResolveUri } from "@azure-tools/uri";
import { cwd } from "process";
import { AutorestRawConfiguration, mergeConfigurations } from "./autorest-raw-configuration";
import { arrayOf } from "./utils";

// TODO-TIM don't extend
export interface AutorestConfiguration extends AutorestRawConfiguration {
  /**
   * Raw configuration that was used to build this config
   */
  raw: AutorestRawConfiguration;

  inputFileUris: string[];

  /**
   * Path to the output folder.
   */
  outputFolderUri: string;

  // TODO-TIM check type?
  configurationFiles: { [key: string]: any };
  name?: string;
  to?: string;
}

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
  const baseFolderUri = getBaseFolderUri(configFileFolderUri, rawConfig);

  const config: AutorestConfiguration = {
    ...rawConfig,
    raw: rawConfig,
    inputFileUris: [],
    configurationFiles: configurationFiles,
    outputFolderUri: resolveAsWriteableFolder(baseFolderUri, <string>rawConfig["output-folder"]),
  };

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

export const getNestedAutorestConfiguration = (
  config: AutorestConfiguration,
  scopes: AutorestRawConfiguration[],
): AutorestConfiguration => {
  const rawConfig = mergeConfigurations(...scopes, config);
  const newConfig: AutorestConfiguration = {
    ...rawConfig,
    raw: rawConfig,
    outputFolderUri: config.outputFolderUri,
    inputFileUris: config.inputFileUris,
    configurationFiles: config.configurationFiles,
  };
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
