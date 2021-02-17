import {
  ExtensionSystemRequirements,
  SystemRequirementError,
  SystemRequirement,
  SystemRequirementResolution,
} from "./models";
import { DotnetExeName, resolveDotnetRequirement } from "./dotnet";
import { resolveGenericSystemRequirement } from "./generic";
import { JavaExeName, resolveJavaRequirement } from "./java";
import { PythonRequirement, resolvePythonRequirement } from "./python";

/**
 * Resolve the extension requirements and returns a list of errors.
 * @param requirements Map of requirements.
 */
export const validateExtensionSystemRequirements = async (
  requirements: ExtensionSystemRequirements,
): Promise<SystemRequirementError[]> => {
  const errors: SystemRequirementError[] = [];
  const results = await resolveSystemRequirements(requirements);
  for (const [name, requirement] of Object.entries(requirements)) {
    const result = results[name];
    if ("error" in result) {
      const message = requirement.message ? `${requirement.message}. ${result.message}` : result.message;
      errors.push({ ...result, message });
    }
  }
  return errors;
};

export type SystemRequirementsResults<T> = { [key in keyof T]: SystemRequirementResolution | SystemRequirementError };

/**
 * Validate the given commands are available in the path and check the version for known commands.
 * @param name Name of the command.
 * @param requirement Requirement configuration.
 * @returns map of resolution or error with the key being the command names provided.
 */
export const resolveSystemRequirements = async <T extends { [name: string]: SystemRequirement }>(
  requirements: T,
): Promise<SystemRequirementsResults<T>> => {
  const results: Partial<SystemRequirementsResults<T>> = {};
  for (const [name, requirement] of Object.entries(requirements)) {
    results[name as keyof T] = await resolveSystemRequirement(name, requirement);
  }
  return results as SystemRequirementsResults<T>;
};

/**
 * Validate the given command is available in the path and check the version for known commands.
 * @param name Name of the command.
 * @param requirement Requirement configuration.
 * @returns resolution or error.
 */
export const resolveSystemRequirement = async (
  name: string,
  requirement: SystemRequirement,
): Promise<SystemRequirementResolution | SystemRequirementError> => {
  switch (name) {
    case DotnetExeName:
      return resolveDotnetRequirement(requirement);
    case JavaExeName:
      return resolveJavaRequirement(requirement);
    case PythonRequirement:
      return resolvePythonRequirement(requirement);
    default:
      return resolveGenericSystemRequirement(name);
  }
};
