import { SystemRequirement, SystemRequirementResolution } from "./models";
import { validateVersionRequirement } from "./version";

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

    if (actualVersion === undefined) {
      return {
        error: true,
        name,
        command,
        message: `'${name}' command line is not found in the path. Make sure to have ${name} installed.`,
      };
    }

    return validateVersionRequirement({ name, command }, actualVersion, requirement);
  };
};
