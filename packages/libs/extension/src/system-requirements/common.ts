import { SystemRequirement, SystemRequirementError } from "./system-requirements";

import semver from "semver";

export const validateVersionRequirement = (
  name: string,
  actualVersion: string,
  requirement: SystemRequirement,
): SystemRequirementError | undefined => {
  if (!requirement.version) {
    return undefined; // No version requirement.
  }

  try {
    if (versionIsSatisfied(actualVersion, requirement.version)) {
      return undefined;
    }
    return {
      name,
      message:
        requirement.message ??
        `System ${name} version is '${actualVersion}' but doesn't satisfy requirement '${requirement.version}'. Please update.`,
      actualVersion: actualVersion,
      neededVersion: requirement.version,
    };
  } catch {
    return {
      name,
      message: `Couldn't parse the version ${actualVersion}. This is not a valid semver version.`,
      actualVersion: actualVersion,
      neededVersion: requirement.version,
    };
  }
};

export const versionIsSatisfied = (version: string, requirement: string): boolean => {
  const cleanedVersion = semver.coerce(version);
  if (!cleanedVersion) {
    throw new Error(`Invalid version ${version}.`);
  }
  return semver.satisfies(cleanedVersion, requirement, true);
};
