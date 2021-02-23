import { AutorestArgs } from "./args";
import { ConfigurationLoader } from "@autorest/configuration";
import { AutorestLogger } from "../../../libs/configuration/node_modules/@autorest/common/dist";

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

  const loader = new ConfigurationLoader(logger, configFileOrFolder);
  const { config } = await loader.load([args], false);
  return config.version;
};
