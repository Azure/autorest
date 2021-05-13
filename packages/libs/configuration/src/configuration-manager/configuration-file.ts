import { AutorestLogger, CodeBlock, OperationAbortedException, parseCodeBlocks } from "@autorest/common";
import { DataHandle, DataSink } from "@azure-tools/datastore";
import { parentFolderUri, isUri } from "@azure-tools/uri";
import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import {
  autorestConfigurationProcessor,
  AUTOREST_CONFIGURATION_SCHEMA,
  RawConfiguration,
} from "../configuration-schema";
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
  config: AutorestNormalizedConfiguration;
}

export const readConfigurationFile = async (
  configFile: DataHandle,
  logger: AutorestLogger,
  sink: DataSink,
): Promise<ConfigurationFile> => {
  const parentFolder = parentFolderUri(configFile.originalFullPath);
  const base: ConfigurationFile = {
    type: "file",
    fullPath: configFile.originalFullPath,
    configs: [],
  };

  // load config
  const hConfig = await parseCodeBlocks(logger, configFile, sink);
  if (hConfig.length === 1 && hConfig[0].info === null && configFile.description.toLowerCase().endsWith(".md")) {
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
  const rawConfig = await codeBlock.data.readObject<RawConfiguration<typeof AUTOREST_CONFIGURATION_SCHEMA>>();
  if (!rawConfig) {
    return { config: {} };
  }

  if (typeof rawConfig !== "object") {
    logger.trackError({
      code: "",
      message: "Syntax error: Invalid YAML object.",
      source: [{ document: codeBlock.data.key, position: { line: 1, column: 0 } }],
    });
    throw new OperationAbortedException();
  }

  const result = autorestConfigurationProcessor.processConfiguration(rawConfig, { logger });
  if ("errors" in result) {
    for (const error of result.errors) {
      logger.trackError({
        code: error.code,
        message: error.message,
        source: [{ document: codeBlock.data.key, position: { path: error.path } }],
      });
    }
    throw new OperationAbortedException();
  }

  const config: AutorestNormalizedConfiguration = result.value;
  // for ['input-file','try-require', 'require'] paths, we're going to create a node that contains
  // a map of the path to the folder from which the configuration file
  // that loaded it was specified.

  // this will enable us to try to load relative paths relative to the folder from which it was read
  // rather than have to rely on the pseudo $(this-folder) macro (which requires updating the file)
  config.__parents = {};
  const kinds: Array<keyof AutorestNormalizedConfiguration> = ["input-file", "require", "try-require", "exclude-file"];
  for (const kind of kinds) {
    if (config[kind]) {
      for (const location of arrayOf<string>(config[kind])) {
        if (!isUri(location)) {
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
