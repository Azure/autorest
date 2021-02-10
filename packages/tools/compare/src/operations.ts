// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import fs from "fs";
import path from "path";
import chalk from "chalk";
import { RunConfiguration, LanguageConfiguration } from "./config";
import { generateWithAutoRest, AutoRestGenerateResult, getBaseResult, runAutoRest } from "./runner";
import { compareOutputFiles, CompareResult } from "./comparers";
import { compareFile as compareTypeScriptFile } from "./languages/typescript";
import { compareFile as comparePythonFile } from "./languages/python";
import { printCompareMessage } from "./printer";

export abstract class Operation {
  abstract runForSpec(languageConfig: LanguageConfiguration, specPath: string, debug: boolean): Promise<void>;

  abstract printSummary(): void;

  abstract getExitCode(): number;
}

export class CompareOperation extends Operation {
  private results: CompareResult[] = [];

  async runForSpec(languageConfig: LanguageConfiguration, specPath: string, debug: boolean): Promise<void> {
    const oldOutputPath = path.resolve(languageConfig.outputPath, "old");
    const newOutputPath = path.resolve(languageConfig.outputPath, "new");

    console.log("Comparing output for spec:", chalk.yellowBright(specPath));

    // Run two instances of AutoRest simultaneously
    let oldRunPromise: Promise<AutoRestGenerateResult>;
    if (languageConfig.useExistingOutput === undefined || languageConfig.useExistingOutput === "none") {
      oldRunPromise = generateWithAutoRest(languageConfig.language, specPath, oldOutputPath, languageConfig.oldArgs);
    } else {
      if (!fs.existsSync(oldOutputPath)) {
        throw new Error(`Expected output path does not exist: ${oldOutputPath}`);
      }

      oldRunPromise = Promise.resolve(getBaseResult(oldOutputPath));
    }

    let newRunPromise: Promise<AutoRestGenerateResult>;
    if (languageConfig.useExistingOutput !== "all") {
      newRunPromise = generateWithAutoRest(languageConfig.language, specPath, newOutputPath, languageConfig.newArgs);
    } else {
      if (!fs.existsSync(newOutputPath)) {
        throw new Error(`Expected output path does not exist: ${newOutputPath}`);
      }

      newRunPromise = Promise.resolve(getBaseResult(newOutputPath));
    }

    const [oldResult, newResult] = await Promise.all([oldRunPromise, newRunPromise]);

    if (debug || languageConfig.oldArgs.indexOf("--debug") > -1) {
      console.log("\n*** Old AutoRest Results:");
      printAutoRestResult(oldResult);
    }

    if (debug || languageConfig.newArgs.indexOf("--debug") > -1) {
      console.log("\n*** New AutoRest Results:");
      printAutoRestResult(newResult);
    }

    const compareResult = compareOutputFiles(oldResult, newResult, {
      comparersByType: {
        ts: compareTypeScriptFile,
        py: comparePythonFile,
      },
    });

    if (compareResult) {
      this.results.push(compareResult);

      console.log(chalk.yellowBright("\nThe following changes were detected:\n"));
      printCompareMessage(compareResult);
      console.log(""); // Space out the next section by one line
    }
  }

  printSummary() {
    // Return a non-zero exit code to signal failure to external tools
    console.log(
      chalk.yellowBright(
        "\nComparison completed with changes detected.  Please view the output above for more details.",
      ),
    );

    // TODO: Print rest of summary
  }

  getExitCode() {
    return this.results.length;
  }
}

export class BaselineOperation extends Operation {
  async runForSpec(languageConfig: LanguageConfiguration, specPath: string, debug: boolean): Promise<void> {
    const oldOutputPath = path.resolve(languageConfig.outputPath, "old");

    console.log(chalk.blueBright("-"), specPath, chalk.redBright("->"), oldOutputPath);

    const runResult = await generateWithAutoRest(
      languageConfig.language,
      specPath,
      oldOutputPath,
      languageConfig.oldArgs,
    );

    if (debug) {
      printAutoRestResult(runResult);
    }
  }

  printSummary(): void {
    console.log(chalk.blueBright("\nGeneration complete."));
  }

  getExitCode() {
    return 0;
  }
}

function printAutoRestResult(runResult: AutoRestGenerateResult): void {
  if (runResult.processOutput) {
    console.log("\nAutoRest Output:\n");
    console.log(runResult.processOutput);
  }
  console.log(`Output files under ${runResult.outputPath}:
${runResult.outputFiles.map((f) => "    " + f).join("\n")}`);
}

export async function runOperation(operation: Operation, runConfig: RunConfiguration): Promise<number> {
  for (const languageConfig of runConfig.languages) {
    const excludedSpecs = new Set(languageConfig.excludeSpecs || []);
    console.log(`\n# Language Generator: ${chalk.greenBright(languageConfig.language)}\n`);

    await initAutoRest(languageConfig);
    for (const specConfig of runConfig.specs) {
      for (const specPath of specConfig.specPaths) {
        const fullSpecPath = path.resolve(specConfig.specRootPath, specPath);
        if (excludedSpecs.has(specPath)) {
          console.log(chalk.gray(`Skipping excluded spec: ${fullSpecPath}`));
          continue;
        }

        await operation.runForSpec(
          {
            ...languageConfig,
            outputPath: path.resolve(languageConfig.outputPath, specPath),
          },
          fullSpecPath,
          runConfig.debug ?? false,
        );
      }
    }
  }

  return operation.getExitCode();
}

/**
 * Init autorest in sequence to prevent package installation race condition.
 */
const initAutoRest = async (languageConfig: LanguageConfiguration) => {
  console.log(`Initializing autorest for language ${languageConfig.language}`);
  await runAutoRest([...languageConfig.oldArgs, "--help"]);
  await runAutoRest([...languageConfig.newArgs, "--help"]);
  console.log(`Completed autorest initialization for language ${languageConfig.language}`);
};
