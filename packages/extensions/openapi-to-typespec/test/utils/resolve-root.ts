// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

import * as path from "path";
import * as fs from "fs-extra";

import { createPrinter } from "./printer";

const { debug } = createPrinter("resolve-project");

/**
 * This is the base definition of PackageJson for our
 * packages. Other modules in this project may extend
 * this definition on their own by declaring an interface
 * to merge with this one:
 *
 * ```typescript
 * declare global {
 *   interface PackageJson {
 *     [MY_CUSTOM_PACKAGE_JSON_KEY]?: CustomType;
 *   }
 * }
 * ```
 */
declare global {
  interface PackageJson {
    name: string;
    version: string;
    description: string;
    main: string;
    module?: string;
    bin?: Record<string, string>;
    files: string[];
    scripts: Record<string, string>;
    repository: string;
    author: string;
    keywords?: string[];
    license: string;
    bugs: {
      url: string;
    };
    homepage: string;
    sideEffects: boolean;
    private: boolean;

    dependencies: Record<string, string>;
    devDependencies: Record<string, string>;
  }
}

/**
 * Information about an Azure SDK for JS package
 */
export interface ProjectInfo {
  /**
   * The name of the package
   */
  name: string;
  /**
   * An absolute path to the package directory
   */
  path: string;
  /**
   * The package SemVer string, e.g. 1.0.0-preview.3 or 4.0.0
   */
  version: string;
  /**
   * The package info object (result of reading/parsing package.json)
   */
  packageJson: PackageJson;
}

async function isAzureSDKPackage(fileName: string): Promise<boolean> {
  const f = await import(fileName);

  if (/^@autorest(-[a-z]+)?\//.test(f.name)) {
    return true;
  } else {
    return false;
  }
}

async function findAzSDKPackageJson(directory: string): Promise<[string, PackageJson]> {
  const files = await fs.readdir(directory);

  if (files.includes("rush.json")) {
    throw new Error("Reached monorepo root, but no matching Azure SDK package was found.");
  }

  for (const file of files) {
    if (file === "package.json") {
      const fullPath = path.join(directory, file);
      const packageObject = await import(fullPath);
      if (await isAzureSDKPackage(fullPath)) {
        return [directory, packageObject];
      }
      debug(`found package.json at ${fullPath}, but it is not an Azure SDK package`);
    }
  }

  const nextPath = path.resolve(path.join(directory, ".."));

  if (nextPath === directory) {
    throw new Error("Reached filesystem root, but no matching Azure SDK package was found.");
  }

  return findAzSDKPackageJson(nextPath);
}

/**
 * Determine which Azure SDK project a given directory belongs to.
 *
 * @param workingDirectory the directory to resolve the package from
 * @returns the package info for the SDK project that owns the given directory
 */
export async function resolveProject(workingDirectory: string): Promise<ProjectInfo> {
  if (!fs.existsSync(workingDirectory)) {
    throw new Error(`No such file or directory: ${workingDirectory}`);
  }

  const directory = await fs.stat(workingDirectory);

  if (!directory.isDirectory()) {
    throw new Error(`${workingDirectory} is not a directory`);
  }

  const [path, packageJson] = await findAzSDKPackageJson(workingDirectory);

  if (!packageJson.name || !packageJson.version) {
    throw new Error(
      `Malformed package (did not have a name or version): ${path}, name="${packageJson.name}", version="${packageJson.version}"`,
    );
  }

  return {
    name: packageJson.name,
    path,
    version: packageJson.version,
    packageJson,
  };
}

/**
 * Finds the monorepo root.
 *
 * @param start - an optional starting point (defaults to CWD)
 * @returns an absolute path to the root of the monorepo
 */
export async function resolveRoot(start?: string): Promise<string> {
  start ??= process.cwd();
  if (await fs.pathExists(path.join(start, "rush.json"))) {
    return start;
  } else {
    const nextPath = path.resolve(start, "..");
    if (nextPath === start) {
      throw new Error("Reached filesystem root, but no rush.json was found.");
    } else {
      return resolveRoot(nextPath);
    }
  }
}
