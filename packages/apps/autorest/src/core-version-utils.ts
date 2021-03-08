import { AutorestArgs } from "./args";
import { ConfigurationLoader } from "@autorest/configuration";
import { AutorestLogger } from "../../../libs/configuration/node_modules/@autorest/common/dist";
import { CreateFileOrFolderUri, CreateFolderUri, ResolveUri } from "@azure-tools/uri";
import { AppRoot } from "./constants";

const inWebpack = typeof __webpack_require__ === "function";
const nodeRequire = inWebpack ? __non_webpack_require__ : require;
const defaultConfigUri = inWebpack
  ? ResolveUri(CreateFolderUri(AppRoot), `dist/resources/default-configuration.md`)
  : CreateFileOrFolderUri(nodeRequire.resolve("@autorest/configuration/resources/default-configuration.md"));

/**
 * Return the version requested of the core extension.
 * @param args ClI args.
 * @returns npm version/tag.
 */
export const getRequestedCoreVersion = (args: AutorestArgs): string => {
  return args.version || (args.latest && "latest") || (args.preview && "preview") || "latest-installed";
};

/**
 * Tries to load the version of autorest core from a config file.
 * @param args CLI Version.
 * @param selectedVersion Path to or loaded version of @autorest/core.
 */
export const findCoreVersionUsingConfiguration = async (args: AutorestArgs): Promise<string | undefined> => {
  const configFileOrFolder = args.configFileOrFolder;

  /* eslint-disable no-console */
  const logger: AutorestLogger = {
    fatal: (x) => console.error(x),
    info: (x) => console.log(x),
    verbose: (x) => args.verbose && console.log(x),
    trackError: (x) => console.error(x),
  };
  /* eslint-enable no-console */

  const loader = new ConfigurationLoader(logger, defaultConfigUri, configFileOrFolder);
  const { config } = await loader.load([args], false);
  return config.version;
};
