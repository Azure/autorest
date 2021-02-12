import { execute } from "../exec-cmd";
import { validateDotnetRequirement } from "./dotnet";
import { validateGenericSystemRequirement } from "./generic";

/**
 * Represent set of system requirements.
 */
export interface SystemRequirements {
  [name: string]: SystemRequirement;
}

export interface SystemRequirement {
  version?: string;
  message?: string;
}

export interface SystemRequirementError {
  name: string;
  message: string;
  neededVersion?: string;
  actualVersion?: string;
}

export const validateSystemRequirements = async (
  requirements: SystemRequirements,
): Promise<SystemRequirementError[]> => {
  const errors: SystemRequirementError[] = [];

  for (const [name, requirement] of Object.entries(requirements)) {
    console.log(`Validating requirement: ${name}`);
    const error = await validateSystemRequirement(name, requirement);
    if (error) {
      errors.push(error);
    }
  }
  return errors;
};

export const validateSystemRequirement = async (
  name: string,
  requirement: SystemRequirement,
): Promise<SystemRequirementError | undefined> => {
  switch (name) {
    case "dotnet":
      return validateDotnetRequirement(requirement);
    default:
      return validateGenericSystemRequirement(name, requirement);
  }
};
