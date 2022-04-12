#!/usr/bin/env node

// eslint-disable-next-line @typescript-eslint/no-var-requires
import "source-map-support/register";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import { AllFixers, AutorestFixer, AutorestFixerConfig } from "../app";
import { FixCode } from "../app/types";
import { logger, setLoggingLevelFromConfig } from "../logger";
import { CliConfig } from "./cli-config";

const getAppConfig = (cliConfig: CliConfig): AutorestFixerConfig => {
  return {
    include: cliConfig.include,
    dryRun: cliConfig["dry-run"],
    fixers: parseFixers(cliConfig.fixers),
  };
};

function parseFixers(fixers?: string): FixCode[] | typeof AllFixers {
  if (fixers === undefined) {
    return [];
  }

  if (fixers === "*") {
    return AllFixers;
  }
  const codes = new Set(Object.values(FixCode));

  const list = fixers.split(",");
  for (const fixer of list) {
    if (!codes.has(fixer as any)) {
      throw new Error(`Unknown fixer ${fixer}. Valid options are: \n${[...codes].map((x) => `  - ${x}`).join("\n")}`);
    }
  }
  return list as FixCode[];
}

async function run() {
  await yargs(hideBin(process.argv))
    .help()
    .strict()
    .option("verbose", {
      alias: "v",
      type: "boolean",
      description: "Run with verbose logging level.",
    })
    .option("debug", {
      type: "boolean",
      description: "Run with debug logging level.",
    })
    .option("level", {
      type: "string",
      description: "Run with given logging level.",
    })
    .option("dry-run", {
      type: "boolean",
      description: "Perform a dry run.",
    })
    .option("fixers", {
      type: "string",
      description: "List of fixer comma seperated to run or '*' for all",
    })
    .command(
      "$0 <include..>",
      "Start the server",
      (cmd) => {
        return cmd.positional("include", {
          description: "List of wildcard pattern/folder to search for specs.",
          type: "string",
          array: true,
          default: [],
        });
      },
      async (cliConfig) => {
        setLoggingLevelFromConfig(cliConfig);
        const fixer = new AutorestFixer(getAppConfig(cliConfig));
        await fixer.fix();
      },
    ).argv;
}

run().catch((e) => {
  logger.error(e);
  // eslint-disable-next-line no-process-exit
  process.exit(1);
});
