/* eslint-disable no-process-exit */
/* eslint-disable no-console */
import "source-map-support/register";
import { AutorestSyncLogger, configureLibrariesLogger, ConsoleLoggerSink, FilterLogger } from "@autorest/common";
import { getLogLevel } from "@autorest/configuration";
import chalk from "chalk";
import { clearTempData } from "./actions";
import { parseAutorestArgs } from "./args";
import { newCorePackage, ensureAutorestHome, runCoreWithRequire, runCoreOutOfProc } from "./autorest-as-a-service";
import { resetAutorest, showAvailableCoreVersions, showInstalledExtensions } from "./commands";
import { VERSION } from "./constants";
import { loadConfig, resolveCoreVersion } from "./utils";

const cwd = process.cwd();

const isDebuggerEnabled =
  // eslint-disable-next-line node/no-unsupported-features/node-builtins
  !!require("inspector").url() || global.v8debug || /--debug|--inspect/.test(process.execArgv.join(" "));
const launchCore = isDebuggerEnabled ? runCoreWithRequire : runCoreOutOfProc;

// aliases, round one.
if (process.argv.indexOf("--no-upgrade-check") !== -1) {
  process.argv.push("--skip-upgrade-check");
}

if (process.argv.indexOf("--json") !== -1) {
  process.argv.push("--message-format=json");
}

if (process.argv.indexOf("--yaml") !== -1) {
  process.argv.push("--message-format=yaml");
}

const args = parseAutorestArgs(process.argv);
(<any>global).__args = args;

// aliases
args["info"] = args["info"] || args["list-installed"];
args["preview"] = args["preview"] || args["prerelease"];
if (args["v3"] && !args["version"]) {
  // --v3 without --version infers --version:^3.2.0 +
  args["version"] = "^3.2.0";
}

// argument tweakin'
args.info = args.version === "" || (args.version as any) === true || args.info; // show --info if they use unparameterized --version.
const listAvailable: boolean = args["list-available"] || false;

function logBanner() {
  // Suppress the banner if the message-format is set to something other than regular.
  if (!args["message-format"] || args["message-format"] === "regular") {
    console.log(
      chalk.green.bold.underline(
        `AutoRest code generation utility [cli version: ${chalk.white.bold(VERSION)}; node: ${chalk.white.bold(
          process.version,
        )}]`,
      ),
    );
    console.log(`(C) 2018 ${chalk.bold("Microsoft Corporation.")}`);
    console.log(chalk.blue.bold.underline("https://aka.ms/autorest"));
  }
}

/**
 * Main Entrypoint for AutoRest Bootstrapper
 */
async function main() {
  logBanner();

  try {
    // did they ask for what is available?
    if (listAvailable) {
      process.exit(await showAvailableCoreVersions(args));
    }

    // show what we have.
    if (args.info) {
      process.exit(await showInstalledExtensions(args));
    }

    try {
      /* make sure we have a .autorest folder */
      await ensureAutorestHome();

      if (args.reset || args["clear-temp"]) {
        // clear out all the temp-data too
        await clearTempData();
      }

      // if we have an autorest home folder, --reset may mean something.
      // if it's not there, --reset won't do anything.
      if (args.reset) {
        process.exit(await resetAutorest(args));
      }
    } catch {
      // We have a chance to fail again later if this proves problematic.
    }
    const sink = new ConsoleLoggerSink({ format: args["message-format"] });
    const logger = new AutorestSyncLogger({
      sinks: [sink],
    });
    const config = await loadConfig(sink, args);
    if (config?.version) {
      logger.info(`AutoRest core version selected from configuration: ${chalk.yellow.bold(config.version)}.`);
    }

    const coreVersionPath = await resolveCoreVersion(
      logger.with(new FilterLogger({ level: getLogLevel({ ...args, ...config }) })),
      config,
    );

    if (args.verbose || args.debug) {
      configureLibrariesLogger("verbose", (...x) => logger.debug(x.join(" ")));
    }

    // let's strip the extra stuff from the command line before we require the core module.
    const newArgs: string[] = [];

    for (const each of process.argv) {
      let keep = true;
      for (const discard of [
        "--version",
        "--list-installed",
        "--list-available",
        "--reset",
        "--latest",
        "--latest-release",
        "--runtime-id",
      ]) {
        if (each === discard || each.startsWith(`${discard}=`) || each.startsWith(`${discard}:`)) {
          keep = false;
        }
      }
      if (keep) {
        newArgs.push(each);
      }
    }

    // use this to make the core aware that this run may be legal even without any inputs
    // this is a valid scenario for "preparation calls" to autorest like `autorest --reset` or `autorest --latest`
    if (args.reset || args.latest || args.version == "latest") {
      // if there is *any* other argument left, that's an indicator that the core is supposed to do something
      newArgs.push("--allow-no-input");
    }

    process.argv = newArgs;

    if (args.debug) {
      logger.debug(`Starting ${newCorePackage} from ${coreVersionPath}`);
    }

    // reset the working folder to the correct place.
    process.chdir(cwd);

    const result = await launchCore(coreVersionPath, "app.js", config);
    if (!result) {
      throw new Error(`Unable to start AutoRest Core from ${coreVersionPath}`);
    }
  } catch (exception) {
    console.log(chalk.redBright("Failure:"));
    console.error(chalk.bold(exception));
    console.error(chalk.bold((<Error>exception).stack));
    process.exit(1);
  }
}

void main();
