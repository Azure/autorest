import { AutorestArgs } from "./args";
import { ConfigurationLoader } from "@autorest/configuration";
import { AutorestLogger } from "../../../libs/configuration/node_modules/@autorest/common/dist";
import { createFileOrFolderUri, createFolderUri, resolveUri } from "@azure-tools/uri";
import { AppRoot } from "./constants";
import { extensionManager } from "./autorest-as-a-service";
import chalk from "chalk";

const inWebpack = typeof __webpack_require__ === "function";
const nodeRequire = inWebpack ? __non_webpack_require__ : require;
const defaultConfigUri = inWebpack
  ? resolveUri(createFolderUri(AppRoot), `dist/resources/default-configuration.md`)
  : createFileOrFolderUri(nodeRequire.resolve("@autorest/configuration/resources/default-configuration.md"));

/**
 * Return the version requested of the core extension.
 * @param args ClI args.
 * @returns npm version/tag.
 */
export const getRequestedCoreVersion = (args: AutorestArgs): string => {
  return args.version || (args.latest && "latest") || (args.preview && "preview") || "latest-installed";
};

const cwd = process.cwd();

/**
 * Tries to load the version of autorest core from a config file.
 * @param args CLI Version.
 * @param selectedVersion Path to or loaded version of @autorest/core.
 */
export const findCoreVersionUsingConfiguration = async (args: AutorestArgs): Promise<string | undefined> => {
  const configFileOrFolder = resolveUri(createFolderUri(cwd), args.configFileOrFolder || ".");
  /* eslint-disable no-console */
  const logger: AutorestLogger = {
    fatal: (x) => console.error(x),
    info: (x) => console.log(x),
    verbose: (x) => args.verbose && console.log(x),
    trackError: (x) => console.error(x),
    trackWarning: (x) => console.error(x),
  };
  /* eslint-enable no-console */

  const loader = new ConfigurationLoader(logger, defaultConfigUri, configFileOrFolder, {
    extensionManager: await extensionManager,
  });
  const { config } = await loader.load([args], false);
  if (config.version) {
    // eslint-disable-next-line no-console
    console.log(
      chalk.yellow(`NOTE: AutoRest core version selected from configuration: ${chalk.yellow.bold(config.version)}.`),
    );
  }
  return config.version;
};
