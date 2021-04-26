// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import * as path from "path";
import * as cp from "child_process";
import { getPathsRecursively } from "./util";
import { parseArgument } from "./cli";
import * as os from "os";

/**
 * Details for the output of an AutoRest run (pre-existing or not).
 */
export interface OutputDetails {
  outputPath: string;
  useExisting: boolean;
}

/**
 * Defines options that will be passed along to the AutoRest run.
 */
export interface AutoRestOptions {
  useArgs?: string[];
  miscArgs?: string[];
  version?: string;
  debug?: boolean;
}

/**
 * Describes different aspects of the result of an AutoRest generation run.
 */
export interface AutoRestGenerateResult extends AutoRestResult {
  outputPath: string;
  outputFiles: string[];
}

/**
 * Describes different aspects of the result of an AutoRest run.
 */
export interface AutoRestResult {
  version?: string;
  timeElapsed?: number;
  processOutput?: string;
}

/**
 * The names of all supported AutoRest language generators.
 */
export type AutoRestLanguage = "typescript" | "python" | "java" | "csharp" | "powershell" | "go";

/**
 * A list of the names of all supported AutoRest language generators.
 */
export const AutoRestLanguages: AutoRestLanguage[] = [
  "typescript",
  "python",
  // "java",
  // "csharp",
  // "powershell",
  // "go"
];

/**
 * Gets the base AutoRestResult by gathering the output files under the
 * given outputPath.
 */
export function getBaseResult(outputPath: string): AutoRestGenerateResult {
  return {
    outputPath,
    outputFiles: getPathsRecursively(outputPath).map((p) => path.relative(outputPath, p)),
  };
}

/**
 * Invokes AutoRest asynchronously as a separate process, passing along the
 * specified options.  Returns a Promise that carries an AutoRestResult which
 * describes the result of the run.
 */
export const generateWithAutoRest = async (
  language: AutoRestLanguage,
  specPath: string,
  outputPath: string,
  autoRestArgs: string[],
): Promise<AutoRestGenerateResult> => {
  const args = [
    // The language generator to use
    `--${language}`,

    // The output-folder where generated files are written.  Specify both
    // styles of option due to inconsistencies between generators.
    `--output-folder="${outputPath}"`,
    `--${language}.output-folder="$(output-folder)"`,
    `--output-artifact:configuration.yaml`,
    // Clear the output folder before generating
    `--${language}.clear-output-folder`,

    // The path to the input spec
    path.extname(specPath) !== "" ? `--input-file="${specPath}"` : specPath,

    // Any additional arguments
    ...(autoRestArgs || []),
  ];

  const result = await runAutoRest(args);
  return {
    ...getBaseResult(outputPath),
    ...result,
  };
};

export const runAutoRest = (args: string[]): Promise<AutoRestResult> => {
  return new Promise((resolve, reject) => {
    const autoRestCommand = getAutoRestCmd();

    if (args.indexOf("--debug") > -1) {
      console.log(`*** Invoking ${autoRestCommand} with args:`, args);
    }

    const startTime = Date.now();
    const autoRestProcess = cp.spawn(autoRestCommand, args, { stdio: "pipe" });

    let normalOutput = "";
    autoRestProcess.stdout.on("data", (data) => {
      normalOutput += data.toString();
    });

    let errorOutput = "";
    autoRestProcess.stderr.on("data", (data) => {
      errorOutput += data.toString();
    });

    const versionArg = args.find((arg) => arg.startsWith("--version"));
    const [_, version] = versionArg ? parseArgument(versionArg) : [null, "unspecified"];

    autoRestProcess.on("exit", (exitCode) => {
      if (exitCode === null || exitCode > 0) {
        reject(
          new Error(
            `AutoRest (${version}) exited with non-zero code:\n\n${errorOutput}\n\nCommand Output:\n\n${normalOutput}`,
          ),
        );
      } else {
        const timeElapsed = Date.now() - startTime;

        resolve({
          version,
          processOutput: normalOutput,
          timeElapsed,
        });
      }
    });
  });
};

const getAutoRestCmd = () => {
  const exe = os.platform() == "win32" ? "autorest.cmd" : "autorest";
  return path.resolve(__dirname, `../node_modules/.bin/${exe}`);
};
