// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import fs from "fs";
import path from "path";
import chalk from "chalk";
import { AutoRestLanguages, AutoRestLanguage } from "./runner";
import {
  RunConfiguration,
  loadConfiguration,
  SpecConfiguration,
  LanguageConfiguration,
  UseExistingOutput,
} from "./config";
import { CompareOperation, BaselineOperation, Operation } from "./operations";

/**
 * Parses an argument of one of the following forms and returns the argument and
 * possible value as a tuple:
 *
 * --arg (value is 'true')
 * --arg=value
 * --arg:value (same as above)
 */
export function parseArgument(argument: string): [string, string] {
  const match = /^--([^=:]+)([=:](.+))?$/g.exec(argument);
  if (match) {
    return [match[1], match[3] || "true"];
  } else {
    throw Error(`Unexpected argument string: ${argument}`);
  }
}

/**
 * Returns a tuple of the AutoRest args and any remaining arguments at the point
 * where a boundary argument (--old-args or --new-args) is encountered.
 */
export function getAutoRestArgs(args: string[]): [string[], string[]] {
  const autoRestArgs = [];

  while (args.length > 0) {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const arg = args.shift()!;
    const [argName, _] = parseArgument(arg);

    if (argName === "old-args" || argName === "new-args") {
      args.unshift(arg);
      break;
    } else {
      autoRestArgs.push(arg);
    }
  }

  return [autoRestArgs, args];
}

function getCompareConfiguration(args: string[]): RunConfiguration {
  let configPath: string | undefined = undefined;
  let languageToRun: AutoRestLanguage | undefined = undefined;
  let useExistingOutput: UseExistingOutput | undefined;

  function warnIfConfigFileUsed(argName: string): boolean {
    if (configPath !== undefined) {
      console.log(chalk.gray(`Skipping argument '${argName}' and using value from ${configPath}`));

      return true;
    }

    return false;
  }

  const languageConfig: LanguageConfiguration = {
    language: undefined as any,
    outputPath: undefined as any,
    oldArgs: [],
    newArgs: [],
  };

  const specConfig: SpecConfiguration = {
    specRootPath: undefined as any,
    specPaths: [],
  };

  let runConfig: RunConfiguration = {
    debug: false,
    specs: [specConfig],
    languages: [languageConfig],
  };

  while (args.length > 0) {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const [argName, argValue] = parseArgument(args.shift()!);

    switch (argName) {
      case "compare":
        if (argValue !== "true") {
          if (!fs.existsSync(argValue)) {
            throw new Error(`Configuration file does not exist: ${argValue}`);
          }

          configPath = argValue;
          // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
          runConfig = loadConfiguration(configPath)!;
        }
        break;

      case "old-args":
        if (!warnIfConfigFileUsed("old-args")) {
          [languageConfig.oldArgs, args] = getAutoRestArgs(args);
        }
        break;

      case "new-args":
        if (!warnIfConfigFileUsed("new-args")) {
          [languageConfig.newArgs, args] = getAutoRestArgs(args);
        }
        break;

      case "spec-path":
        if (!warnIfConfigFileUsed("spec-path")) {
          specConfig.specPaths.push(argValue);
        }
        break;

      case "spec-root-path":
        if (!warnIfConfigFileUsed("spec-root-path")) {
          specConfig.specRootPath = argValue;
        }
        break;

      case "output-path":
        if (!warnIfConfigFileUsed("output-path")) {
          languageConfig.outputPath = argValue;
        }
        break;

      case "use-existing-output":
        if (argValue === "old" || argValue === "all" || argValue === "none") {
          useExistingOutput = argValue;
        } else {
          throw new Error(`Unexpected value for --use-existing-output: ${argValue}`);
        }
        break;

      case "language":
        if (AutoRestLanguages.indexOf(argValue as AutoRestLanguage) > -1) {
          languageToRun = argValue as AutoRestLanguage;
          if (configPath === undefined) {
            languageConfig.language = languageToRun;
          }
        } else {
          throw new Error(
            `Unexpected value for --language: ${argValue}.  Supported languages are: ${AutoRestLanguages.join(", ")}.`,
          );
        }
        break;

      case "debug":
        runConfig.debug = argValue === "true";
        break;
    }
  }

  // Add debug flags if --debug was set globally
  if (runConfig.debug) {
    for (const language of runConfig.languages) {
      language.oldArgs.push("--debug");
      language.newArgs.push("--debug");
    }
  }

  if (configPath === undefined && languageConfig.language === undefined) {
    throw new Error(
      `Missing language parameter.  Please use one of the following:\n${["", ...AutoRestLanguages].join(
        "\n    --language:",
      )}\n`,
    );
  }

  if (configPath === undefined && languageConfig.outputPath === undefined) {
    throw new Error("An output path must be provided with the --output-path parameter.");
  }

  if (configPath === undefined && specConfig.specPaths.length === 0) {
    throw new Error("A spec path must be provided with the --spec-path parameter.");
  }

  // Resolve paths relative to configuration file or the current directory
  const fullConfigPath = configPath ? path.dirname(path.resolve(configPath)) : process.cwd();

  runConfig = {
    ...runConfig,
    specs: runConfig.specs.map(resolveSpecRootPath(fullConfigPath)),
    languages: runConfig.languages.map(prepareLanguageConfiguration(fullConfigPath, useExistingOutput)),
  };

  // Filter language configurations to desired language
  if (languageToRun) {
    const language = runConfig.languages.find((l) => l.language === languageToRun);
    if (language === undefined) {
      throw new Error(`No language configurations are available after --language:${languageToRun} filter.`);
    }
    runConfig.languages = [language];
  }

  return runConfig;
}

function getBaselineConfiguration(args: string[]): RunConfiguration {
  let configPath: string | undefined = undefined;
  let runConfig: RunConfiguration | undefined = undefined;
  let languageToRun: string | undefined = undefined;

  while (args.length > 0) {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const arg = args.shift()!;
    const [argName, argValue] = parseArgument(arg);

    switch (argName) {
      case "generate-baseline":
        if (argValue === "true") {
          throw new Error("A configuration file must be specified: --generate-baseline:path-to-config.yaml");
        }

        if (!fs.existsSync(argValue)) {
          throw new Error(`Configuration file does not exist: ${argValue}`);
        }

        configPath = argValue;
        runConfig = loadConfiguration(configPath);
        break;

      case "language":
        if (AutoRestLanguages.indexOf(argValue as AutoRestLanguage) > -1) {
          languageToRun = argValue as AutoRestLanguage;
        } else {
          throw new Error(
            `Unexpected value for --language: ${argValue}.  Supported languages are: ${AutoRestLanguages.join(", ")}.`,
          );
        }
        break;

      default:
        throw Error(`Unexpected argument: ${arg}`);
    }
  }

  if (!configPath) {
    throw new Error("Couldn't resolve config path.");
  }
  if (!runConfig) {
    throw new Error("Configuration couldn't be loaded");
  }

  // Resolve paths relative to configuration file
  const fullConfigPath = path.dirname(path.resolve(configPath));
  runConfig = {
    ...runConfig,
    specs: runConfig.specs.map(resolveSpecRootPath(fullConfigPath)),
    languages: runConfig.languages.map(prepareLanguageConfiguration(fullConfigPath)),
  };

  // Filter language configurations to desired language
  if (languageToRun) {
    const language = runConfig.languages.find((l) => l.language === languageToRun);
    if (language === undefined) {
      throw new Error(`No language configurations are available after --language:${languageToRun} filter.`);
    }
    runConfig.languages = [language];
  }

  return runConfig;
}

function resolveSpecRootPath(configPath: string) {
  return function (specConfig: SpecConfiguration): SpecConfiguration {
    return {
      ...specConfig,
      specRootPath: path.resolve(configPath, specConfig.specRootPath),
    };
  };
}

function prepareLanguageConfiguration(configPath: string, useExistingOutput?: UseExistingOutput) {
  return function (languageConfig: LanguageConfiguration): LanguageConfiguration {
    return {
      ...languageConfig,
      useExistingOutput: useExistingOutput ? useExistingOutput : languageConfig.useExistingOutput,
      outputPath: path.resolve(configPath, languageConfig.outputPath),
      oldArgs: languageConfig.oldArgs.map(resolveUseArgumentPaths(configPath)),
      newArgs: languageConfig.newArgs.map(resolveUseArgumentPaths(configPath)),
    };
  };
}

function resolveUseArgumentPaths(configPath: string) {
  return function (autoRestArg: string): string {
    const [argName, argValue] = parseArgument(autoRestArg);
    // This assumes that any relative path will start with '.' since
    // we cannot reliably detect a path otherwise
    return (argName === "use" || argName === "version") && argValue.startsWith(".")
      ? `--${argName}:${path.resolve(configPath, argValue)}`
      : autoRestArg;
  };
}

export function getOperationFromArgs(args: string[]): [Operation, RunConfiguration] {
  if (args[0].startsWith("--compare")) {
    return [new CompareOperation(), getCompareConfiguration(args)];
  } else if (args[0].startsWith("--generate-baseline")) {
    return [new BaselineOperation(), getBaselineConfiguration(args)];
  } else {
    throw new Error("Unkown operation. Please provide --comopare or --generate-baseline");
  }
}
