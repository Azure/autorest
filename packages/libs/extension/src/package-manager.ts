import { promises } from "fs";
import { join } from "path";

const { writeFile, access } = promises;

export type PackageManagerType = "yarn" | "npm";

export interface InstallOptions {
  force?: boolean;
}

export interface PackageManagerProgress {
  /**
   * Current step.
   */
  current: number;

  /**
   * Total number of steps.
   */
  total: number;

  /**
   * In the case there is multiple progress
   */
  id?: number;
}

export type PackageInstallationResult = { success: false; error: InstallationError } | { success: true };

export interface InstallationError {
  /**
   * Main error message.
   */
  message: string;

  /**
   * Log entries for the package manager.
   */
  logs: PackageManagerLogEntry[];
}

export interface PackageManagerLogEntry {
  severity: "info" | "warning" | "error";
  message: string;
}

export interface PackageManager {
  install(
    directory: string,
    packages: string[],
    options?: InstallOptions,
    reportProgress?: (progress: PackageManagerProgress) => void,
  ): Promise<PackageInstallationResult>;

  clean(directory: string): Promise<void>;
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
