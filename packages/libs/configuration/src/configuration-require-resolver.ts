import { IFileSystem } from "@azure-tools/datastore";
import { ResolveUri, IsUri, EnsureIsFolderUri } from "@azure-tools/uri";
import { AutorestConfiguration } from "./autorest-configuration";
import { arrayOf } from "./utils";

export async function* getIncludedConfigurationFiles(
  configView: () => Promise<AutorestConfiguration>,
  fileSystem: IFileSystem,
  ignoreFiles: Set<string>,
) {
  let done = false;

  while (!done) {
    // get a fresh copy of the view every time we start the loop.
    const config = await configView();

    // if we make it thru the list, we're done.
    done = true;
    for (const each of arrayOf<string>(config["require"])) {
      if (ignoreFiles.has(each)) {
        continue;
      }

      // looks like we found one that we haven't handled yet.
      done = false;
      ignoreFiles.add(each);
      yield await resolveRequireAsPath(each, config, fileSystem);
      break;
    }
  }

  done = false;
  while (!done) {
    // get a fresh copy of the view every time we start the loop.
    const config = await configView();

    // if we make it thru the list, we're done.
    done = true;
    for (const each of arrayOf<string>(config["try-require"])) {
      if (ignoreFiles.has(each)) {
        continue;
      }

      // looks like we found one that we haven't handled yet.
      done = false;
      ignoreFiles.add(each);
      const path = await resolveRequireAsPath(each, config, fileSystem);
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

const resolveRequireAsPath = (
  path: string,
  config: AutorestConfiguration,
  fileSystem: IFileSystem,
): Promise<string> => {
  // is there even a potential for a parent folder from the input configuruation
  const parentFolder = config.__parents?.[path];
  const fromBaseUri = ResolveUri(getBaseFolderUri(config), path);

  // if it's an absolute uri already, give it back that way.
  if (IsUri(path) || !parentFolder) {
    return Promise.resolve(fromBaseUri);
  }

  // let it try relative to the file that loaded it.
  // if the relative-to-parent path isn't valid, we fall back to original behavior
  // where the file path is relative to the base uri.
  // (and we don't even check to see if that's valid, try-require wouldn't need valid files)
  const fromLoadedFile = ResolveUri(parentFolder, path);
  return fileSystem.ReadFile(fromLoadedFile).then(
    () => fromLoadedFile,
    () => fromBaseUri,
  );
};

const getBaseFolderUri = (config: AutorestConfiguration): string => {
  return EnsureIsFolderUri(ResolveUri(config.configFileFolderUri, <string>config["base-folder"]));
};
