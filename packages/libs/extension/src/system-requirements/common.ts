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

/**
 * Returns the path to the executable as asked in the requirement.
 * @param requirement System requirement definition.
 * @returns If the requirement provide an environment variable for the path returns the value of that environment variable. undefined otherwise.
 */
export const getExecutablePath = (requirement: SystemRequirement): string | undefined =>
  requirement.environmentVariable && process.env[requirement.environmentVariable];

export type KnownRequirementHandler = (requirement: SystemRequirement) => Promise<SystemRequirementError | undefined>;

export const defineKnownRequirement = (
  name: string,
  getVersion: (cmd: string) => Promise<string | undefined>,
): KnownRequirementHandler => {
  return async (requirement: SystemRequirement) => {
    const executablePath = getExecutablePath(requirement);
    const actualVersion = await getVersion(executablePath ?? name);
    const ExeNotFoundMessage = `${name} command line is not found in the path. Make sure to have ${name} installed.`;

    if (actualVersion === undefined) {
      return {
        name,
        message: requirement.message ?? ExeNotFoundMessage,
      };
    }

    return validateVersionRequirement(name, actualVersion, requirement);
  };
};
