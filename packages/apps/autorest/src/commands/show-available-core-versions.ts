/* eslint-disable no-console */
import chalk from "chalk";
import { AutorestArgs } from "../args";
import { availableVersions, newCorePackage } from "../autorest-as-a-service";

/**
 * Shows the valid available autorest core packages.
 * @param args CLI args
 * @returns Exit code.
 */
export const showAvailableCoreVersions = async (args: AutorestArgs): Promise<number> => {
  let table = "";
  let max = 10;
  const cores = await availableVersions();
  for (const v of cores) {
    max--;
    table += `\n ${chalk.cyan.bold(newCorePackage.padEnd(30, " "))} ${chalk.grey.bold(v.padEnd(14, " "))} `;
    if (!max) {
      break;
    }
  }
  if (args.json) {
    console.log(JSON.stringify(cores, null, "  "));
  } else {
    if (table) {
      console.log(
        `${chalk.green.bold.underline(" Extension Name".padEnd(30, " "))}  ${chalk.green.bold.underline(
          "Version".padEnd(14, " "),
        )}\n${table}`,
      );
    }
  }
  return 0;
};
