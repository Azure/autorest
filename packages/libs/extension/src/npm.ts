import { dirname, resolve } from "path";
import { execute } from "./exec-cmd";
import { InstallOptions, PackageManager } from "./package-manager";

export const DEFAULT_NPM_REGISTRY = "https://registry.npmjs.org";

const getPathToNpmCli = () => {
  const npmPath = dirname(require.resolve("npm/package.json"));
  return resolve(`${npmPath}/bin/npm-cli.js`);
};

export const execNpm = async (cwd: string, ...args: string[]) => {
  const procArgs = [
    getPathToNpmCli(),
    "--no-shrinkwrap",
    "--registry",
    process.env.autorest_registry || DEFAULT_NPM_REGISTRY,
    ...args,
  ];
  return await execute(process.execPath, procArgs, { cwd });
};

export class Npm implements PackageManager {
  public async install(directory: string, packages: string[], options?: InstallOptions) {
    const output = await execNpm(
      directory,
      "install",
      "--save",
      "--prefix",
      directory.replace(/\\/g, "/"),
      ...(options?.force ? ["--force"] : []),
      ...packages,
    );
    if (output.error) {
      /* eslint-disable no-console */
      console.error("NPM log:");
      console.log("-".repeat(50));
      console.error(output.log);
      console.log("-".repeat(50));
      /* eslint-enable no-console */
      throw Error(`Failed to install package '${packages}' -- ${output.error}`);
    }
  }

  public async clean(directory: string): Promise<void> {
    await execNpm(directory, "cache", "clean", "--force");
  }

  public async getPackageVersions(directory: string, packageName: string): Promise<string[]> {
    const result = await execNpm(directory, "view", packageName, "versions", "--json");

    return JSON.parse(result.stdout).data;
  }
}
