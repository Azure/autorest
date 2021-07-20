import yargs from "yargs";
import { CliConfig } from "./cli-config";

export const parseArgs = (argv: string[]): CliConfig => {
  const cli = yargs(argv)
    .help()
    .strict()
    .command("$0 <include..>", "Start the server", (cmd) => {
      return cmd.positional("include", {
        description: "List of wildcard pattern/folder to search for specs.",
        type: "string",
        array: true,
        default: [],
      });
    })
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
    });

  const options = cli.argv;
  return {
    ...options,
  };
};
