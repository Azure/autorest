// @ts-check
const { spawn, spawnSync } = require("child_process");
const { resolve } = require("path");

const repoRoot = resolve(__dirname, "../..");
const prettier = resolve(repoRoot, "packages/extensions/core/node_modules/.bin/prettier");
const tsc = resolve(repoRoot, "packages/extensions/core/node_modules/.bin/tsc");

const isCmdOnWindows = ["rush", "npm", "code", "code-insiders", tsc, prettier];

function run(command, args, options) {
  console.log();
  console.log(`> ${command} ${args.join(" ")}`);

  options = {
    stdio: "inherit",
    sync: true,
    throwOnNonZeroExit: true,
    shell: process.platform === "win32",
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

class CommandFailedError extends Error {
  constructor(msg, proc) {
    super(msg);
    this.proc = proc;
  }
}

function runPrettier(...args) {
  run(
    prettier,
    [
      ...args,
      "--config",
      ".prettierrc.yml",
      "--ignore-path",
      ".prettierignore",
      "**/*.{ts,js,cjs,mjs,json,yml,yaml,cadl,tsp,md}",
    ],
    {
      cwd: repoRoot,
    },
  );
}

module.exports = {
  repoRoot,
  prettier,
  tsc,
  run,
  runPrettier,
  CommandFailedError,
};
