#!/usr/bin/env node
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
import "source-map-support/register";

import { runOperation } from "./operations";
import { AutoRestLanguages } from "./runner";
import { getOperationFromArgs } from "./cli";

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const languageArgsString = ["", ...AutoRestLanguages].join("\n                                               - ");

  // First, check for the --help parameter, or no parameters at all
  if (args.length === 0 || args[0] === "--help") {
    console.log(
      `
Usage: autorest-compare --compare --language:[language-name] [spec arguments] --output-path=[generated output path] --old-args [AutoRest arguments] --new-args [AutoRest arguments]
       autorest-compare --compare:config.yaml [--language:language-name] [--use-existing-output:<output type>]
       autorest-compare --generate-baseline:config.yaml [--language:language-name]

Operation Arguments

  --compare[:<config-file.yaml>]               Generates two sets of output from AutoRest driven by --old-args and
                                               --new-args.  If no configuration file is specified, it is expected
                                               that language, spec, and AutoRest arguments will be supplied.  If a
                                               configuration file is specified, the --language parameter will select
                                               a single language from the configuration file for comparison.

  --generate-baseline:<config-file.yaml>       Generates the "old" output configuration for use as a baseline for future
                                               --compare runs.  The --language parameter will select a single language
                                               from the configuration file for comparison.

Language Arguments

  --language:<language name>                   Generate output using the specified language generator.  Supported values
                                               are:
${languageArgsString}

Spec Arguments

  --spec-path:<path>                           Use the specified spec path for code generation.  Relative paths will
                                               be resolved against the value of --spec-root-path if specified.
                                               NOTE: This parameter can be used multiple times to specify more than
                                               one spec path.

  --spec-root-path:<path>                      The root path from which all spec paths will be resolved.

Output Arguments

  --output-path:<base generated output path>   The path where generated source files will be emitted.  This should
                                               generally be under a temporary file path.  When a --spec-root-path
                                               is provided, the path --spec-path relative to the --spec-root-path
                                               will be used as the subpath of the --output-path.

  --use-existing-output:<output type>          For --compare operations, this argument determines whether existing output
                                               folders will be used for the comparison.  Possible values:

                                               - none: Regenerates both old and new output for the comparison
                                               - old: Uses existing old output folder
                                               - all: Uses existing folders for old and new output


Comparison Arguments

  --old-args <AutoRest arguments>              Indicates that what follows are arguments to AutoRest to generate the "old"
                                               (baseline) output for comparison.

  --new-args <AutoRest arguments>              Indicates that what follows are arguments to AutoRest to generate the "new"
                                               output for comparison.

`.trimLeft(),
    );
  } else {
    const [operation, runConfig] = getOperationFromArgs(args);
    await runOperation(operation, runConfig);

    // eslint-disable-next-line no-process-exit
    process.exit(operation.getExitCode());
  }
}

main().catch((err) => {
  console.error("\nAn error occurred during execution:\n\n", err);
  // eslint-disable-next-line no-process-exit
  process.exit(1);
});
