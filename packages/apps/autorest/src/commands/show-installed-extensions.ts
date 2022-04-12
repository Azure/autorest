/* eslint-disable no-console */
import chalk from "chalk";
import { AutorestArgs } from "../args";
import { extensionManager, newCorePackage, oldCorePackage } from "../autorest-as-a-service";

/**
 * Shows all the autorest extensions that are installed.
 * @param args CLI args
 * @returns Exit code.
 */
export const showInstalledExtensions = async (args: AutorestArgs): Promise<number> => {
  const extensions = await (await extensionManager).getInstalledExtensions();
  let table = "";
  if (extensions.length > 0) {
    for (const extension of extensions) {
      table += `\n ${chalk.cyan(
        (extension.name === newCorePackage || extension.name === oldCorePackage ? "core" : "extension").padEnd(10),
      )} ${chalk.cyan.bold(extension.name.padEnd(40))} ${chalk.cyan(extension.version.padEnd(12))} ${chalk.cyan(
        extension.location,
      )}`;
    }
  }
  if (args.json) {
    console.log(JSON.stringify(extensions, null, "  "));
  } else {
    const title = `\n\n${chalk.greenBright("Showing All Installed Extensions")}\n`;
    if (table) {
      console.log(
        `${title}\n ${chalk.underline("Type".padEnd(10))} ${chalk.underline(
          "Extension Name".padEnd(40),
        )} ${chalk.underline("Version".padEnd(12))} ${chalk.underline("Location")} ${table}\n\n`,
      );
    } else {
      console.log(`${title}\n ${chalk.cyan("No Extensions are currently installed.")}\n\n`);
    }
  }
  return 0;
};
