import { promises } from "fs";
import { join } from "path";

const { writeFile, access } = promises;

export type PackageManagerType = "yarn" | "npm";

export interface InstallOptions {
  force?: boolean;
}

export interface PackageManager {
  install(
    directory: string,
    packages: string[],
    options?: InstallOptions,
    reportProgress?: (progressId: number, progress: number) => void,
  ): Promise<void>;

  clean(directory: string): Promise<void>;

  getPackageVersions(directory: string, packageName: string): Promise<any[]>;
}

/**
 * Ensure there is a pacakge.json in the install directory.
 * This is to ensure that yarn add will not look for a parent package.json and install in the parent folder instead.
 * @param directory Directory where the package will be installed.
 */
export async function ensurePackageJsonExists(directory: string) {
  const filename = join(directory, "package.json");
  if (await exists(filename)) {
    return;
  }

  await writeFile(filename, "{}");
}

async function exists(filename: string) {
  try {
    await access(filename);
    return true;
  } catch {
    return false;
  }
}
