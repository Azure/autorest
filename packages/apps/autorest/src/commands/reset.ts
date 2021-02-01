/* eslint-disable no-console */
import { AutorestArgs } from "../args";
import { extensionManager, rootFolder } from "../autorest-as-a-service";
import { color } from "../coloring";

/**
 * Reset autorest, this will:
 * - Clear all installed extensions
 * - Cleared all installed core
 * @param args CLI args
 * @returns Exit code.
 */
export const resetAutorest = async (args: AutorestArgs): Promise<number> => {
  if (args.debug) {
    console.log(`Resetting autorest extension folder '${rootFolder}'`);
  }

  try {
    await (await extensionManager).reset();
    console.log(
      color(
        "\n\n## Cleared the AutoRest extension folder.\nOn the next run, extensions will be reacquired from the repository.",
      ),
    );
    return 0;
  } catch (e) {
    console.log(
      color(
        "\n\n## The AutoRest extension folder appears to be locked.\nDo you have a process that is currently using AutoRest (perhaps the vscode extension?).\n\nUnable to reset the extension folder, exiting.",
      ),
    );
    return 10;
  }
};
