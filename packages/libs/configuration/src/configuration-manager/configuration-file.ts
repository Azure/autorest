import { AutorestLogger, CodeBlock, OperationAbortedException, parseCodeBlocks } from "@autorest/common";
import { DataHandle, DataSink } from "@azure-tools/datastore";
import { ParentFolderUri, IsUri } from "@azure-tools/uri";
import { AutorestRawConfiguration } from "../autorest-raw-configuration";
import { desugarRawConfig } from "../desugar";
import { arrayOf } from "../utils";

export interface ConfigurationFile {
  type: "file";

  /**
   * Full path to the file.
   */
  fullPath: string;

  /**
   * Set of raw configurations.
   */
  configs: ConditionalConfiguration[];
}

export interface ConditionalConfiguration {
  condition?: string;
  config: AutorestRawConfiguration;
}

export const readConfigurationFile = async (
  configFile: DataHandle,
  logger: AutorestLogger,
  sink: DataSink,
): Promise<ConfigurationFile> => {
  const parentFolder = ParentFolderUri(configFile.originalFullPath);
  const base: ConfigurationFile = {
    type: "file",
    fullPath: configFile.originalFullPath,
    configs: [],
  };

  // load config
  const hConfig = await parseCodeBlocks(logger, configFile, sink);
  if (hConfig.length === 1 && hConfig[0].info === null && configFile.Description.toLowerCase().endsWith(".md")) {
    // this is a whole file, and it's a markdown file.
    return { ...base };
  }

  const configs = await Promise.all(hConfig.filter((x) => x).map((x) => codeBlockToRawConfig(logger, parentFolder, x)));

  return {
    ...base,
    configs,
  };
};

const codeBlockToRawConfig = async (
  logger: AutorestLogger,
  parentFolder: string | null,
  codeBlock: CodeBlock,
): Promise<ConditionalConfiguration> => {
  const config = await codeBlock.data.ReadObject<AutorestRawConfiguration>();
  if (!config) {
    return { config: {} };
  }

  if (typeof config !== "object") {
    logger.trackError({
      code: "",
      message: "Syntax error: Invalid YAML object.",
      source: [{ document: codeBlock.data.key, position: { line: 1, column: 0 } }],
    });
    throw new OperationAbortedException();
  }

  // for ['input-file','try-require', 'require'] paths, we're going to create a node that contains
  // a map of the path to the folder from which the configuration file
  // that loaded it was specified.

  // this will enable us to try to load relative paths relative to the folder from which it was read
  // rather than have to rely on the pseudo $(this-folder) macro (which requires updating the file)
  config.__parents = {};
  const kinds: Array<keyof AutorestRawConfiguration> = ["input-file", "require", "try-require", "exclude-file"];
  for (const kind of kinds) {
    if (config[kind]) {
      for (const location of arrayOf<string>(config[kind])) {
        if (!IsUri(location)) {
          config.__parents[location] = parentFolder;
        }
      }
    }
  }
  return {
    condition: codeBlock.info ?? undefined,
    config: await desugarRawConfig(config),
  };
};
