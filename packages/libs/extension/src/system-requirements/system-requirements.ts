import { SystemRequirements, SystemRequirementError, SystemRequirement, SystemRequirementResolution } from "./models";
import { DotnetExeName, validateDotnetRequirement } from "./dotnet";
import { validateGenericSystemRequirement } from "./generic";
import { JavaExeName, validateJavaRequirement } from "./java";
import { PythonRequirement, validatePythonRequirement } from "./python";

export const validateSystemRequirements = async (
  requirements: SystemRequirements,
): Promise<SystemRequirementError[]> => {
  const errors: SystemRequirementError[] = [];

  for (const [name, requirement] of Object.entries(requirements)) {
    const result = await validateSystemRequirement(name, requirement);
    if ("error" in result) {
      errors.push(result);
    }
  }
  return errors;
};

export const validateSystemRequirement = async (
  name: string,
  requirement: SystemRequirement,
): Promise<SystemRequirementResolution | SystemRequirementError> => {
  switch (name) {
    case DotnetExeName:
      return validateDotnetRequirement(requirement);
    case JavaExeName:
      return validateJavaRequirement(requirement);
    case PythonRequirement:
      return validatePythonRequirement(requirement);
    default:
      return validateGenericSystemRequirement(name, requirement);
  }
};
