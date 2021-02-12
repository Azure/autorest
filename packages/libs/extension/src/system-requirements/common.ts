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

  if (semver.satisfies(actualVersion, requirement.version)) {
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
};
