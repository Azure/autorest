/* eslint-disable no-console */
import { EnumerateFiles, ReadUri, ResolveUri } from "@azure-tools/uri";
import chalk from "chalk";
import { dirname } from "path";
import { AutorestArgs } from "./args";
import { resolveEntrypoint, selectVersion } from "./autorest-as-a-service";
import * as vm from "vm";
import { Extension } from "@azure-tools/extension";

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
export const configurationSpecifiedVersion = async (args: AutorestArgs, selectedVersion: string | Extension) => {
  try {
    // we can either have a selectedVerison object or a path. See if we can find the AutoRest API
    const autorestApi = await resolveEntrypoint(
      typeof selectedVersion === "string" ? selectedVersion : await selectedVersion.modulePath,
      "main",
    );

    // things we need in the sandbox.
    const sandbox = {
      require: __non_webpack_require__,
      console,
      rfs: {
        EnumerateFileUris: async (folderUri: string): Promise<Array<string>> => {
          return EnumerateFiles(folderUri, ["readme.md"]);
        },
        ReadFile: (uri: string): Promise<string> => ReadUri(uri),
      },
      cfgfile: ResolveUri(`file://${cwd}`, args.configFileOrFolder || ""),
      switches: args,
    };

    // *sigh* ... there's a bug in most versions of autorest-core that to use the API you have to
    // have the current directory set to the package location. We'll fix this in the future versions.
    process.chdir(dirname(autorestApi));
    const configSpecifiedVersion = await vm.runInNewContext(
      `
          async function go() {
            // load the autorest api library
            const r = require('${autorestApi}');
            const api = new r.AutoRest(rfs,cfgfile);
            // don't let the version from the cmdline affect this!
            delete switches.version;
            api.AddConfiguration(switches);

            // resolve the configuration and return the version if there is one.
            return (await api.view).rawConfig.version;
          }
          go();
          `,
      sandbox,
    );

    // if we got back a result, lets return that.
    if (configSpecifiedVersion) {
      const newVersion = await selectVersion(configSpecifiedVersion, false);
      console.log(
        chalk.yellow(
          `NOTE: AutoRest core version selected from configuration: ${chalk.yellow.bold(configSpecifiedVersion)}.`,
        ),
      );
      return newVersion;
    }
    return undefined;
  } catch (e) {
    return undefined;
  }
};
