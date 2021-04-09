import { IFileSystem } from "@azure-tools/datastore";
import { resolveUri, isUri, ensureIsFolderUri } from "@azure-tools/uri";
import { AutorestConfiguration } from "../autorest-configuration";
import { arrayOf } from "../utils";

/**
 * Resolve required configuration from the provided config.
 * @param resolveConfig Callback to resolve current config.
 * @param fileSystem Filesystem.
 * @param ignoreFiles Current state of files already resolved.
 */
export async function* getIncludedConfigurationFiles(
  resolveConfig: () => Promise<AutorestConfiguration>,
  fileSystem: IFileSystem,
  ignoreFiles: Set<string>,
) {
  let done = false;

  while (!done) {
    // get a fresh copy of the view every time we start the loop.
    const config = await resolveConfig();

    // if we make it thru the list, we're done.
    done = true;
    for (const each of arrayOf<string>(config["require"])) {
      const path = await resolveRequireAsPath(each, config, fileSystem);
      if (ignoreFiles.has(path)) {
        continue;
      }

      // looks like we found one that we haven't handled yet.
      done = false;
      ignoreFiles.add(path);
      yield await resolveRequireAsPath(each, config, fileSystem);
      break;
    }
  }

  done = false;
  while (!done) {
    // get a fresh copy of the view every time we start the loop.
    const config = await resolveConfig();

    // if we make it thru the list, we're done.
    done = true;
    for (const each of arrayOf<string>(config["try-require"])) {
      const path = await resolveRequireAsPath(each, config, fileSystem);
      if (ignoreFiles.has(path)) {
        continue;
      }

      // looks like we found one that we haven't handled yet.
      done = false;
      ignoreFiles.add(path);
      try {
        if (await fileSystem.read(path)) {
          yield path;
        }
      } catch {
        // do nothing
      }

      break;
    }
  }
}

const resolveRequireAsPath = (
  path: string,
  config: AutorestConfiguration,
  fileSystem: IFileSystem,
): Promise<string> => {
  // is there even a potential for a parent folder from the input configuruation
  const parentFolder = config.__parents?.[path];
  const fromBaseUri = resolveUri(getBaseFolderUri(config), path);

  // if it's an absolute uri already, give it back that way.
  if (isUri(path) || !parentFolder) {
    return Promise.resolve(fromBaseUri);
  }

  // let it try relative to the file that loaded it.
  // if the relative-to-parent path isn't valid, we fall back to original behavior
  // where the file path is relative to the base uri.
  // (and we don't even check to see if that's valid, try-require wouldn't need valid files)
  const fromLoadedFile = resolveUri(parentFolder, path);
  return fileSystem.read(fromLoadedFile).then(
    () => fromLoadedFile,
    () => fromBaseUri,
  );
};

const getBaseFolderUri = (config: AutorestConfiguration): string => {
  return ensureIsFolderUri(resolveUri(config.configFileFolderUri, <string>config["base-folder"]));
};
