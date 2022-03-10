import { dirname, resolve } from "path";
import { execute } from "./exec-cmd";
import { ensurePackageJsonExists, InstallOptions, PackageInstallationResult, PackageManager } from "./package-manager";

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
  public async install(
    directory: string,
    packages: string[],
    options?: InstallOptions,
  ): Promise<PackageInstallationResult> {
    await ensurePackageJsonExists(directory);

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
      return {
        success: false,
        error: {
          message: `Failed to install package '${packages}' -- ${output.error}`,
          logs: output.log.split("\n").map((x) => ({ severity: "info", message: x })),
        },
      };
    }

    return { success: true };
  }

  public async clean(directory: string): Promise<void> {
    await execNpm(directory, "cache", "clean", "--force");
  }
}
