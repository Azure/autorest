/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ChildProcess, spawn } from "child_process";
import { homedir, tmpdir } from "os";
import { basename, delimiter, dirname, extname, isAbsolute, join, normalize, resolve } from "path";
import {
  patchPythonPath,
  PythonCommandLine,
  ExtensionSystemRequirements,
  validateExtensionSystemRequirements,
} from "@autorest/system-requirements";
import { exists, isDirectory, isFile, mkdir, readdir, rmdir } from "@azure-tools/async-io";
import { Delay, Exception, Mutex, SharedLock } from "@azure-tools/tasks";
import { resolve as npmResolvePackage } from "npm-package-arg";
import * as pacote from "pacote";
import * as semver from "semver";
import {
  UnresolvedPackageException,
  InvalidPackageIdentityException,
  ExtensionFolderLocked,
  PackageInstallationException,
  MissingStartCommandException,
  UnsatisfiedSystemRequirementException,
} from "./exceptions";
import { Extension, Package } from "./extension";
import { AsyncLock } from "./locks/async-lock";
import { logger } from "./logger";
import { Npm } from "./npm";
import { PackageManager, PackageManagerLogEntry, PackageManagerProgress, PackageManagerType } from "./package-manager";
import { Yarn } from "./yarn";

export interface PackageInstallProgress extends PackageManagerProgress {
  pkg: Package;
}

function quoteIfNecessary(text: string): string {
  if (text && text.indexOf(" ") > -1 && text.charAt(0) != '"') {
    return `"${text}"`;
  }
  return text;
}
const nodePath = quoteIfNecessary(process.execPath);

function cmdlineToArray(
  text: string,
  result: Array<string> = [],
  matcher = /[^\s"]+|"([^"]*)"/gi,
  count = 0,
): Array<string> {
  text = text.replace(/\\"/g, "\ufffe");
  const match = matcher.exec(text);
  return match
    ? cmdlineToArray(
        text,
        result,
        matcher,
        result.push(match[1] ? match[1].replace(/\ufffe/g, '\\"') : match[0].replace(/\ufffe/g, '\\"')),
      )
    : result;
}

function getPathVariableName() {
  // windows calls it's path 'Path' usually, but this is not guaranteed.
  if (process.platform === "win32") {
    let PATH = "Path";
    Object.keys(process.env).forEach(function (e) {
      if (e.match(/^PATH$/i)) {
        PATH = e;
      }
    });
    return PATH;
  }
  return "PATH";
}
async function realPathWithExtension(command: string): Promise<string | undefined> {
  const pathExt = (process.env.pathext || ".EXE").split(";");
  for (const each of pathExt) {
    const filename = `${command}${each}`;
    if (await isFile(filename)) {
      return filename;
    }
  }
  return undefined;
}

async function getFullPath(command: string, searchPath?: string): Promise<string | undefined> {
  command = command.replace(/"/g, "");
  const ext = extname(command);

  if (isAbsolute(command)) {
    // if the file has an extension, or we're not on win32, and this is an actual file, use it.
    if (ext || process.platform !== "win32") {
      if (await isFile(command)) {
        return command;
      }
    }

    // if we're on windows, look for a file with an acceptable extension.
    if (process.platform === "win32") {
      // try all the PATHEXT extensions to see if it is a recognized program
      const cmd = await realPathWithExtension(command);
      if (cmd) {
        return cmd;
      }
    }
    return undefined;
  }

  if (searchPath) {
    const folders = searchPath.split(delimiter);
    for (const each of folders) {
      const fullPath = await getFullPath(resolve(each, command));
      if (fullPath) {
        return fullPath;
      }
    }
  }

  return undefined;
}

/**
 * Resolve given package metadata.
 * @param spec This can be a package name with version, the url to a tgz or a local folder.
 * @returns Package metadata.
 */
export async function fetchPackageMetadata(spec: string): Promise<pacote.ManifestResult> {
  try {
    return await pacote.manifest(spec, {
      cache: `${tmpdir()}/cache`,
      registry: process.env.autorest_registry || "https://registry.npmjs.org",
      "full-metadata": true,
    });
  } catch (error) {
    logger.error(`Error resolving package ${spec}`, error);
    throw new UnresolvedPackageException(spec);
  }
}

function resolveName(name: string, version: string) {
  try {
    return npmResolvePackage(name, version);
  } catch (e) {
    if (e instanceof Error) {
      throw new InvalidPackageIdentityException(name, version, e.message);
    } else {
      throw e;
    }
  }
}

export class ExtensionManager {
  public dotnetPath = normalize(`${homedir()}/.dotnet`);

  public static async Create(
    installationPath: string,
    packageManagerType: PackageManagerType = "yarn",
    packageManagerPath: string | undefined = undefined,
  ): Promise<ExtensionManager> {
    if (!(await exists(installationPath))) {
      await mkdir(installationPath);
    }
    if (!(await isDirectory(installationPath))) {
      throw new Exception(`Extension folder '${installationPath}' is not a valid directory`);
    }
    const lock = new SharedLock(installationPath);
    const packageManager = packageManagerType === "yarn" ? new Yarn(packageManagerPath) : new Npm();
    return new ExtensionManager(installationPath, lock, await lock.acquire(), packageManager);
  }

  public async dispose() {
    await this.disposeLock();
    this.disposeLock = async () => {};
    this.sharedLock = null;
  }

  public async reset() {
    if (!this.sharedLock) {
      throw new Exception("Extension manager has been disposed.");
    }

    // get the exclusive lock
    const release = await this.sharedLock.exclusive();

    try {
      // nuke the folder
      await rmdir(this.installationPath);

      // recreate the folder
      await mkdir(this.installationPath);

      await this.packageManager.clean(this.installationPath);
    } catch (e) {
      throw new ExtensionFolderLocked(this.installationPath);
    } finally {
      // drop the lock
      await release();
    }
  }

  private constructor(
    private installationPath: string,
    private sharedLock: SharedLock | null,
    private disposeLock: () => Promise<void>,
    private packageManager: PackageManager,
  ) {}

  /**
   * Return the list of version for the given package name [+ version range]
   *
   * @param name Name of the package with or without version range.
   * @returns List of semver versions
   */
  public async getPackageVersions(name: string): Promise<string[]> {
    const packument = await pacote.packument(name);
    return Object.keys(packument.versions);
  }

  public async findPackage(name: string, version = "latest"): Promise<Package> {
    if (version.endsWith(".tgz")) {
      // get the package metadata
      const pm = await fetchPackageMetadata(version);
      return new Package(pm, pm, this);
    }
    try {
      // version can be a version or any one of the formats that
      // npm accepts (path, targz, git repo)
      const resolved = resolveName(name, version);
      const resolvedName = resolved.raw;

      // get the package metadata
      const pm = await fetchPackageMetadata(resolvedName);
      return new Package(resolved, pm, this);
    } catch (E) {
      // in the event that there isn't a matching package by that name
      // we can try a fallback to see if a gh release has a package
      // (if it is an autorest.<whatever> project)
      // https://github.com/Azure/${PROJECT}/releases/download/v${VERSION}/autorest/${PROJECT}-${VERSION}.tgz
      if (name.startsWith("@autorest/")) {
        const githubRepo = name.replace("@autorest/", "autorest.");
        const githubPkgName = name.replace("@", "").replace("autorest/", "autorest-");
        const githubVersion = version
          .replace(/^[~|^]/g, "") // Use the exact version instead of range
          .replace(/_/g, "-"); // Replace _ with - ;

        const ghurl = `https://github.com/Azure/${githubRepo}/releases/download/v${githubVersion}/${githubPkgName}-${githubVersion}.tgz`;
        try {
          const pm = await fetchPackageMetadata(ghurl);
          if (pm) {
            return new Package(pm, pm, this);
          }
        } catch {
          // no worries, return the previous error
        }
      }

      throw E;
    }
  }

  public async getInstalledExtension(name: string, version: string): Promise<Extension | null> {
    if (!semver.validRange(version)) {
      // if they asked for something that isn't a valid range, we have to find out what version
      // the target package actually is.
      const pkg = await this.findPackage(name, version);
      version = pkg.version;
    }

    const installed = await this.getInstalledExtensions();
    for (const each of installed) {
      if (name === each.name && semver.satisfies(each.version, version)) {
        return each;
      }
    }
    return null;
  }

  public async getInstalledExtensions(): Promise<Array<Extension>> {
    const results = new Array<Extension>();

    // iterate thru the folders.
    // the folder name should have the pattern @ORG#NAME@VER or NAME@VER
    for (const folder of await readdir(this.installationPath)) {
      const fullpath = join(this.installationPath, folder);
      if (await isDirectory(fullpath)) {
        const split = /((@.+)_)?(.+)@(.+)/.exec(folder);
        if (split) {
          try {
            const org = split[2];
            const name = split[3];
            const version = split[4];

            const actualPath = org
              ? normalize(`${fullpath}/node_modules/${org}/${name}`)
              : normalize(`${fullpath}/node_modules/${name}`);
            const pm = await fetchPackageMetadata(actualPath);
            const ext = new Extension(new Package(null, pm, this), this.installationPath);
            if (fullpath !== ext.location) {
              // eslint-disable-next-line no-console
              console.trace(
                `WARNING: Not reporting '${fullpath}' since its package.json claims it should be at '${ext.location}' (probably symlinked once and modified later)`,
              );
              continue;
            }
            results.push(ext);
          } catch (e) {
            // ignore things that don't look right.
          }
        }
      }
    }

    // each folder will contain a node_modules folder, which should have a folder by
    // in the node_modules folder there should be a folder by the name of the
    return results;
  }

  private static lock = new AsyncLock();

  public async installPackage(
    pkg: Package,
    force?: boolean,
    maxWait: number = 5 * 60 * 1000,
    reportProgress: (progress: PackageInstallProgress) => void = () => {},
  ): Promise<Extension> {
    if (!this.sharedLock) {
      throw new Exception("Extension manager has been disposed.");
    }

    // will throw if the CriticalSection lock can't be acquired.
    // we need this so that only one extension at a time can start installing
    // in this process (since to use NPM right, we have to do a change dir before runinng it)
    // if we ran NPM out-of-proc, this probably wouldn't be necessary.
    const extensionRelease = await ExtensionManager.lock.acquire(maxWait);

    if (!(await exists(this.installationPath))) {
      await mkdir(this.installationPath);
    }

    const extension = new Extension(pkg, this.installationPath);
    const release = await new Mutex(extension.location).acquire(maxWait / 2);

    try {
      // change directory
      process.chdir(this.installationPath);

      if (await isDirectory(extension.location)) {
        if (!force) {
          // already installed
          // if the target folder is created, we're going to make the naive assumption that the package is installed. (--force will blow away)
          return extension;
        }

        // force removal first
        try {
          // progress.NotifyMessage(`Removing existing extension ${extension.location}`);
          await Delay(100);
          await rmdir(extension.location);
        } catch (e) {
          // no worries.
        }
      }

      // create the folder
      await mkdir(extension.location);

      const pkgRef = getPkgRef(pkg.packageMetadata);
      const promise = this.packageManager.install(extension.location, [pkgRef], { force }, (progress) => {
        reportProgress({ pkg, ...progress });
      });
      await extensionRelease();

      const result = await promise;
      if (result.success) {
        return extension;
      } else {
        const message = [result.error.message, "", "Installation logs: ", formatLogEntries(result.error.logs)];
        throw new PackageInstallationException(pkg.name, pkg.version, message.join("\n"));
      }
    } catch (e: any) {
      // clean up the attempted install directory
      if (await isDirectory(extension.location)) {
        await Delay(100);
        await rmdir(extension.location);
      }

      if (e instanceof Exception) {
        throw e;
      }
      if (e instanceof PackageInstallationException) {
        throw e;
      }
      if (e instanceof Error) {
        throw new PackageInstallationException(pkg.name, pkg.version, e.message + e.stack);
      }
      throw new PackageInstallationException(pkg.name, pkg.version, `${e}`);
    } finally {
      await Promise.all([extensionRelease(), release()]);
    }
  }

  public async removeExtension(extension: Extension): Promise<void> {
    if (await isDirectory(extension.location)) {
      const release = await new Mutex(extension.location).acquire();
      await rmdir(extension.location);
      await release();
    }
  }

  public async start(extension: Extension, enableDebugger = false): Promise<ChildProcess> {
    const PathVar = getPathVariableName();

    await this.validateExtensionSystemRequirements(extension);
    if (!extension.definition.scripts) {
      throw new MissingStartCommandException(extension);
    }

    const script =
      enableDebugger && extension.definition.scripts.debug
        ? extension.definition.scripts.debug
        : extension.definition.scripts.start;

    // look at the extension for the
    if (!script) {
      throw new MissingStartCommandException(extension);
    }
    const command = cmdlineToArray(script);

    if (command.length === 0) {
      throw new MissingStartCommandException(extension);
    }
    // add each engine into the front of the path.
    const env = { ...process.env };

    // add potential .bin folders (depends on platform and npm version)
    env[PathVar] = `${join(extension.modulePath, "node_modules", ".bin")}${delimiter}${env[PathVar]}`;
    env[PathVar] = `${join(extension.location, "node_modules", ".bin")}${delimiter}${env[PathVar]}`;

    // find appropriate path for interpreter
    switch (command[0].toLowerCase()) {
      case "node":
      case "node.exe":
        command[0] = nodePath;
        break;

      case "python":
      case "python.exe":
      case "python3":
      case "python3.exe":
        await patchPythonPath(command as PythonCommandLine, { version: ">=3.6" });
        break;
    }

    // ensure parameters requiring quotes have them.
    for (let i = 0; i < command.length; i++) {
      command[i] = quoteIfNecessary(command[i]);
    }
    // spawn the command via the shell (since that how npm would have done it anyway.)
    const fullCommandPath = await getFullPath(command[0], env[getPathVariableName()]);
    if (!fullCommandPath) {
      throw new Exception(
        `Unable to resolve full path for executable '${command[0]}' -- (cmdline '${command.join(" ")}')`,
      );
    }

    // == special case ==
    // on Windows, if this command has a space in the name, and it's not an .EXE
    // then we're going to have to add the folder to the PATH
    // and execute it by just the filename
    // and set the path back when we're done.
    if (process.platform === "win32" && fullCommandPath.indexOf(" ") > -1 && !/.exe$/gi.exec(fullCommandPath)) {
      // preserve the current path
      const originalPath = process.env[PathVar];
      try {
        // insert the dir into the path
        process.env[PathVar] = `${dirname(fullCommandPath)}${delimiter}${env[PathVar]}`;

        // call spawn and return
        return spawn(basename(fullCommandPath), command.slice(1), {
          env,
          cwd: extension.modulePath,
          stdio: ["pipe", "pipe", "pipe"],
        });
      } finally {
        // regardless, restore the original path on the way out!
        process.env[PathVar] = originalPath;
      }
    }

    return spawn(fullCommandPath, command.slice(1), {
      env,
      cwd: extension.modulePath,
      stdio: ["pipe", "pipe", "pipe"],
    });
  }

  /**
   * Validate if present the extension system requirements.
   * @param extension Extension to validate.
   */
  private async validateExtensionSystemRequirements(extension: Extension) {
    const systemRequirements: ExtensionSystemRequirements | undefined = extension.definition.systemRequirements;
    if (!systemRequirements) {
      return;
    }

    const errors = await validateExtensionSystemRequirements(systemRequirements);
    if (errors.length > 0) {
      throw new UnsatisfiedSystemRequirementException(extension, errors);
    }
  }
}

function formatLogEntries(entries: PackageManagerLogEntry[]): string {
  const lines = ["```", ...entries.map(formatLogEntry), "```"];
  return lines.join("\n");
}

function formatLogEntry(entry: PackageManagerLogEntry): string {
  const [first, ...lines] = entry.message.split("\n");
  const spacing = " ".repeat(entry.severity.length);
  return [`${entry.severity}: ${first}`, ...lines.map((x) => `${spacing}  ${x}`)].join("\n");
}

function getPkgRef(pkg: pacote.ManifestResult) {
  // Change in pacote https://github.com/npm/pacote/issues/20
  // Issue with git+ssh in yarn + performance of git+https is much worse that github https://github.com/yarnpkg/yarn/issues/6417
  // if (pkg._from.startsWith("github:")) {
  //   return pkg._from;
  // }
  return pkg._resolved;
}
