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
      message:
        requirement.message ??
        `'${resolution.command}' version is '${actualVersion}' but doesn't satisfy requirement '${requirement.version}'. Please update.`,
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

/**
 * Returns the path to the executable as asked in the requirement.
 * @param requirement System requirement definition.
 * @returns If the requirement provide an environment variable for the path returns the value of that environment variable. undefined otherwise.
 */
export const getExecutablePath = (requirement: SystemRequirement): string | undefined =>
  requirement.environmentVariable && process.env[requirement.environmentVariable];

export type KnownRequirementHandler = (
  requirement: SystemRequirement,
) => Promise<SystemRequirementResolution | SystemRequirementResolution>;

/**
 *
 * @param name Name of the command.
 * @param getVersion Function used to get the version. Callbacks takes the resolved command from the requirement environmentVariable is provided or default the the value of @name
 */
export const defineKnownRequirement = (
  name: string,
  getVersion: (cmd: string) => Promise<string | undefined>,
): KnownRequirementHandler => {
  return async (requirement: SystemRequirement) => {
    const executablePath = getExecutablePath(requirement);
    const command = executablePath ?? name;
    const actualVersion = await getVersion(command);
    const ExeNotFoundMessage = `${name} command line is not found in the path. Make sure to have ${name} installed.`;

    if (actualVersion === undefined) {
      return {
        error: true,
        name,
        command,
        message: requirement.message ?? ExeNotFoundMessage,
      };
    }

    return validateVersionRequirement({ name, command }, actualVersion, requirement);
  };
};
