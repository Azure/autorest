import { isDirectory, readdir, rmdir } from "@azure-tools/async-io";
import chalk from "chalk";
import { tmpdir } from "os";
import { join } from "path";

/**
 * Clears out all autorest-temp folders from the temp folder.
 */
export const clearTempData = async () => {
  const all = [];
  const tmp = tmpdir();
  for (const each of await readdir(tmp)) {
    if (each.startsWith("autorest")) {
      const name = join(tmp, each);
      if (await isDirectory(name)) {
        all.push(rmdir(name));
      }
    }
  }
  if (all.length > 0) {
    // eslint-disable-next-line no-console
    console.log(chalk.grey(`Clearing ${all.length} autorest temp data folders...`));
  }
  await Promise.all(all);
};
