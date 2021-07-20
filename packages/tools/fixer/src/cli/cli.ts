#!/usr/bin/env node

// eslint-disable-next-line @typescript-eslint/no-var-requires
import "source-map-support/register";

import { hideBin } from "yargs/helpers";
import { AutorestFixer, AutorestFixerConfig } from "../app";
import { logger, setLoggingLevelFromConfig } from "../logger";
import { parseArgs } from "./args-parser";
import { CliConfig } from "./cli-config";

const getAppConfig = (cliConfig: CliConfig): AutorestFixerConfig => {
  return {
    include: cliConfig.include,
    dryRun: cliConfig["dry-run"],
  };
};

const run = async () => {
  const cliConfig = parseArgs(hideBin(process.argv));
  setLoggingLevelFromConfig(cliConfig);
  const fixer = new AutorestFixer(getAppConfig(cliConfig));
  await fixer.fix();
};

run().catch((e) => {
  logger.error(e);
  // eslint-disable-next-line no-process-exit
  process.exit(1);
});
