import { Extension } from "./extension";
import { SystemRequirementError } from "./system-requirements";

export class UnresolvedPackageException extends Error {
  constructor(packageId: string) {
    super(`Unable to resolve package '${packageId}'.`);
    Object.setPrototypeOf(this, UnresolvedPackageException.prototype);
  }
}

export class InvalidPackageIdentityException extends Error {
  constructor(name: string, version: string, message: string) {
    super(`Package '${name}' - '${version}' is not a valid package reference:\n  ${message}`);
    Object.setPrototypeOf(this, InvalidPackageIdentityException.prototype);
  }
}

export class PackageInstallationException extends Error {
  constructor(name: string, version: string, message: string) {
    super(`Package '${name}' - '${version}' failed to install:\n  ${message}`);
    Object.setPrototypeOf(this, PackageInstallationException.prototype);
  }
}

export class UnsatisfiedEngineException extends Error {
  constructor(name: string, version: string, message = "") {
    super(`Unable to find matching engine '${name}' - '${version} ${message}'`);
    Object.setPrototypeOf(this, UnsatisfiedEngineException.prototype);
  }
}

export class UnsatisfiedSystemRequirementException extends Error {
  constructor(extension: Extension, errors: SystemRequirementError[]) {
    const message = [
      `System is missing dependencies required by extension '${extension.name}':`,
      ...errors.map((x) => ` - ${x.name}: ${x.message.replace(/\n/g, "\n ")}`),
    ].join("\n");
    super(message);
    Object.setPrototypeOf(this, UnsatisfiedSystemRequirementException.prototype);
  }
}

export class MissingStartCommandException extends Error {
  constructor(extension: Extension) {
    super(`Extension '${extension.id}' is missing the script 'start' in the package.json file`);
    Object.setPrototypeOf(this, MissingStartCommandException.prototype);
  }
}

export class ExtensionFolderLocked extends Error {
  constructor(path: string) {
    super(`Extension Folder '${path}' is locked by another process.`);
    Object.setPrototypeOf(this, ExtensionFolderLocked.prototype);
  }
}
