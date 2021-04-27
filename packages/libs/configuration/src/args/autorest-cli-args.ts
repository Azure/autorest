import { AutorestLogger, OperationAbortedException } from "@autorest/common";
import { CreateObject } from "@azure-tools/datastore";
import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import { mergeConfigurations } from "../configuration-merging";
import { autorestConfigurationProcessor, AUTOREST_INITIAL_CONFIG } from "../configuration-schema";
import { parseArgs } from "./parse-args";

export interface ParseAutorestCliArgsOptions {
  logger: AutorestLogger;
}

export interface AutorestCliArgs {
  options: AutorestNormalizedConfiguration;
  configFileOrFolder: string | undefined;
}

export function parseAutorestCliArgs(cliArgs: string[], options: ParseAutorestCliArgsOptions): AutorestCliArgs {
  const parsedArgs = parseArgs(cliArgs);
  if (parsedArgs.positional.length > 1) {
    throw new Error(`Found multiple configuration file arguments: '${parsedArgs.positional.join(",")}'`);
  }
  const configFileOrFolder = parsedArgs.positional[0];

  const optionsAsObjects = parsedArgs.optionList.map(({ key, value }) => CreateObject(key.split("."), value));
  const config = mergeConfigurations([AUTOREST_INITIAL_CONFIG, ...optionsAsObjects.reverse()], {
    arrayMergeStrategy: "low-pri-first",
  });
  const result = autorestConfigurationProcessor.processConfiguration(config, {
    logger: options.logger,
  });

  if ("errors" in result) {
    for (const error of result.errors) {
      options.logger.trackError({
        code: error.code,
        message: `Invalid Cli Flag: ${error.message}. For flag '${error.path.join(".")}'`,
      });
    }
    throw new OperationAbortedException();
  }
  return { options: result.value, configFileOrFolder };
}
