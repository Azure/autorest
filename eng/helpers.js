// @ts-check
const { spawn, spawnSync } = require("child_process");
const { resolve } = require("path");

export const repoRoot = resolve(__dirname, "../..");
export const prettier = resolve(repoRoot, "packages/extensions/core/node_modules/.bin/prettier");
export const tsc = resolve(repoRoot, "packages/extensions/core/node_modules/.bin/tsc");

const isCmdOnWindows = ["rush", "npm", "code", "code-insiders", tsc, prettier];

export function run(command, args, options) {
  console.log();
  console.log(`> ${command} ${args.join(" ")}`);

  options = {
    stdio: "inherit",
    sync: true,
    throwOnNonZeroExit: true,
    ...options,
  };

  if (process.platform === "win32" && isCmdOnWindows.includes(command)) {
    command += ".cmd";
  }

  const proc = (options.sync ? spawnSync : spawn)(command, args, options);
  if (proc.error) {
    if (options.ignoreCommandNotFound && proc.error.code === "ENOENT") {
      console.log(`Skipped: Command \`${command}\` not found.`);
    } else {
      throw proc.error;
    }
  } else if (options.throwOnNonZeroExit && proc.status !== undefined && proc.status !== 0) {
    throw new CommandFailedError(`Command \`${command} ${args.join(" ")}\` failed with exit code ${proc.status}`, proc);
  }

  return proc;
}

export class CommandFailedError extends Error {
  constructor(msg, proc) {
    super(msg);
    this.proc = proc;
  }
}
