import { Package } from "@azure-tools/extension";
import { gt } from "semver";
import { AutorestArgs } from "../args";
import { extensionManager, networkEnabled } from "../autorest-as-a-service";
import { color } from "../coloring";
import { VERSION } from "../constants";

/**
 * Check if there is any updates to the autorest package and display message to use if there is.
 * @param args Autorest cli args.
 */
export const checkForAutoRestUpdate = async (args: AutorestArgs) => {
  if ((await networkEnabled) && !args["skip-upgrade-check"]) {
    try {
      const npmTag = args.preview ? "preview" : "latest";
      const newVersion = await isAutorestUpdateAvailable(npmTag);
      if (newVersion) {
        // eslint-disable-next-line no-console
        console.log(
          color(
            `\n## There is a new version of AutoRest available (${newVersion.version}).\n > You can install the newer version with with \`npm install -g autorest@${npmTag}\`\n`,
          ),
        );
      }
    } catch (e) {
      // no message then.
    }
  }
};

const isAutorestUpdateAvailable = async (npmTag: string): Promise<Package | undefined> => {
  const pkg = await (await extensionManager).findPackage("autorest", npmTag);
  return gt(pkg.version, VERSION) ? pkg : undefined;
};
