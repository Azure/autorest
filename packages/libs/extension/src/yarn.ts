import { isFile, writeFile } from "@azure-tools/async-io";
import { readFileSync } from "fs";
import { tmpdir } from "os";
import { join, resolve } from "path";
import { execute } from "./exec-cmd";
import { DEFAULT_NPM_REGISTRY } from "./npm";
import { InstallOptions, PackageManager } from "./package-manager";

let _cli: string | undefined;
const getPathToYarnCli = async () => {
  const nodeModulesYarn = resolve(`${__dirname}/../node_modules/yarn/lib/cli.js`);
  if (await isFile(nodeModulesYarn)) {
    _cli = nodeModulesYarn;
    return _cli;
  }

  const fname = resolve(`${__dirname}/../yarn/cli.js`);
  if (await isFile(fname)) {
    _cli = fname;
  } else {
    // otherwise, we might be in a 'static-linked' library and
    // we should try to load it and put a copy in $tmp somewhere.
    _cli = join(tmpdir(), "yarn-cli.js");

    // did we copy it already?
    if (await isFile(_cli)) {
      return _cli;
    }
    // no, let's copy it now.
    await writeFile(_cli, readFileSync(fname));
  }
  return _cli;
};

export class Yarn implements PackageManager {
  public constructor(private pathToYarnCli: string | undefined = undefined) {}

  public async install(directory: string, packages: string[], options?: InstallOptions) {
    const output = await this.execYarn(
      directory,
      "add",
      "--global-folder",
      directory.replace(/\\/g, "/"),
      ...(options?.force ? ["--force"] : []),
      ...packages,
    );
    if (output.error) {
      /* eslint-disable no-console */
      console.error("Yarn log:");
      console.log("-".repeat(50));
      console.error(output.log);
      console.log("-".repeat(50));
      /* eslint-enable no-console */
      throw Error(`Failed to install package '${packages}' -- ${output.error}`);
    }
  }

  public async clean(directory: string): Promise<void> {
    await this.execYarn(directory, "cache", "clean", "--force");
  }

  public async getPackageVersions(directory: string, packageName: string): Promise<string[]> {
    const result = await this.execYarn(directory, "info", packageName, "versions", "--json");
    return JSON.parse(result.stdout).data;
  }

  public async execYarn(cwd: string, ...args: string[]) {
    const procArgs = [
      this.pathToYarnCli ?? (await getPathToYarnCli()),
      "--no-node-version-check",
      "--no-lockfile",
      "--json",
      "--registry",
      process.env.autorest_registry || DEFAULT_NPM_REGISTRY,
      ...args,
    ];

    const newEnv = {
      ...process.env,
      YARN_IGNORE_PATH: "1", // Prevent yarn from using a different version if configured in ~/.yarnrc
    };

    return await execute(process.execPath, procArgs, { cwd, env: newEnv });
  }
}
