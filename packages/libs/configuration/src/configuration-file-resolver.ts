import { AutorestLogger } from "@autorest/common";
import { IFileSystem, ParseToAst } from "@azure-tools/datastore";
import { EnsureIsFolderUri, ResolveUri } from "@azure-tools/uri";
import { DefaultConfiguration, MagicString } from "./contants";

/**
 * Get the path to the configuration file.
 * @param fileSystem Filesystem.
 * @param configFileOrFolderUri Uri/folder to check
 * @param logger
 * @param walkUpFolders If it should try to check parent folder recursively.
 */
export const detectConfigurationFile = async (
  fileSystem: IFileSystem,
  configFileOrFolderUri: string | null,
  logger?: AutorestLogger,
  walkUpFolders = false,
): Promise<string | undefined> => {
  const files = await detectConfigurationFiles(fileSystem, configFileOrFolderUri, logger, walkUpFolders);

  return (
    files.filter((x) => x.toLowerCase().endsWith("/" + DefaultConfiguration))[0] ||
    files.sort((a, b) => a.length - b.length)[0]
  );
};

/**
 * Get the paths to all the configuration files.
 * @param fileSystem Filesystem.
 * @param configFileOrFolderUri Uri/folder to check
 * @param logger
 * @param walkUpFolders If it should try to check parent folder recursively.
 */
export const detectConfigurationFiles = async (
  fileSystem: IFileSystem,
  configFileOrFolderUri: string | null,
  logger?: AutorestLogger,
  walkUpFolders = false,
): Promise<Array<string>> => {
  const originalConfigFileOrFolderUri = configFileOrFolderUri;

  // null means null!
  if (!configFileOrFolderUri) {
    return [];
  }

  // try querying the Uri directly
  let content: string | null;
  try {
    content = await fileSystem.ReadFile(configFileOrFolderUri);
  } catch {
    // didn't get the file successfully, move on.
    content = null;
  }
  if (content !== null) {
    if (content.indexOf(MagicString) > -1) {
      // the file name was passed in!
      return [configFileOrFolderUri];
    }
    try {
      const ast = ParseToAst(content);
      if (ast) {
        return [configFileOrFolderUri];
      }
    } catch {
      // nope.
    }
    // this *was* an actual file passed in, not a folder. don't make this harder than it has to be.
    throw new Error(
      `Specified file '${originalConfigFileOrFolderUri}' is not a valid configuration file (missing magic string, see https://github.com/Azure/autorest/blob/master/docs/user/literate-file-formats/configuration.md#the-file-format).`,
    );
  }

  // scan the filesystem items for configurations.
  const results = new Array<string>();
  for (const name of await fileSystem.EnumerateFileUris(EnsureIsFolderUri(configFileOrFolderUri))) {
    if (name.endsWith(".md")) {
      const content = await fileSystem.ReadFile(name);
      if (content.indexOf(MagicString) > -1) {
        results.push(name);
      }
    }
  }

  if (walkUpFolders) {
    // walk up
    const newUriToConfigFileOrWorkingFolder = ResolveUri(configFileOrFolderUri, "..");
    if (newUriToConfigFileOrWorkingFolder !== configFileOrFolderUri) {
      results.push(
        ...(await detectConfigurationFiles(fileSystem, newUriToConfigFileOrWorkingFolder, logger, walkUpFolders)),
      );
    }
  } else {
    if (logger && results.length === 0) {
      logger.verbose(`No configuration found at '${originalConfigFileOrFolderUri}'.`);
    }
  }

  return results;
};

/**
 * Checks to see if the document is a literate configuation document.
 *
 * @param content the document content to check
 */
export async function isConfigurationDocument(content: string): Promise<boolean> {
  // this checks to see if the document is an autorest markdown configuration document
  return content.indexOf(MagicString) > -1;
}
