import { SystemRequirement, SystemRequirementError, SystemRequirementResolution } from "./models";

import semver from "semver";

/**
 * Validate the provided system requirement resolution is satisfying the version requirement if applicable.
 * @param resolution Command resolution.
 * @param actualVersion Version for that resolution.
 * @param requirement Requirement.
 * @returns the resolution if it is valid or an @see SystemRequirementError if not.
 */
export const validateVersionRequirement = (
  resolution: SystemRequirementResolution,
  actualVersion: string,
  requirement: SystemRequirement,
): SystemRequirementResolution | SystemRequirementError => {
  if (!requirement.version) {
    return resolution; // No version requirement.
  }

  try {
    if (versionIsSatisfied(actualVersion, requirement.version)) {
      return resolution;
    }
    return {
      ...resolution,
      error: true,
      message: `'${resolution.command}' version is '${actualVersion}' but doesn't satisfy requirement '${requirement.version}'. Please update.`,
      actualVersion: actualVersion,
      neededVersion: requirement.version,
    };
  } catch {
    return {
      ...resolution,
      error: true,
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
