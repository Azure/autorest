import { arrayOf } from "@autorest/configuration";
import { IFileSystem } from "@azure-tools/datastore";
import { AutorestContext } from "./autorest-context";

export async function* getIncludedConfigurationFiles(
  configView: () => Promise<AutorestContext>,
  fileSystem: IFileSystem,
  ignoreFiles: Set<string>,
) {
  let done = false;

  while (!done) {
    // get a fresh copy of the view every time we start the loop.
    const view = await configView();

    // if we make it thru the list, we're done.
    done = true;
    for (const each of arrayOf<string>(view.config["require"])) {
      if (ignoreFiles.has(each)) {
        continue;
      }

      // looks like we found one that we haven't handled yet.
      done = false;
      ignoreFiles.add(each);
      yield await view.ResolveAsPath(each);
      break;
    }
  }

  done = false;
  while (!done) {
    // get a fresh copy of the view every time we start the loop.
    const view = await configView();

    // if we make it thru the list, we're done.
    done = true;
    for (const each of arrayOf<string>(view.config["try-require"])) {
      if (ignoreFiles.has(each)) {
        continue;
      }

      // looks like we found one that we haven't handled yet.
      done = false;
      ignoreFiles.add(each);
      const path = await view.ResolveAsPath(each);
      try {
        if (await fileSystem.ReadFile(path)) {
          yield path;
        }
      } catch {
        // do nothing
      }

      break;
    }
  }
}
