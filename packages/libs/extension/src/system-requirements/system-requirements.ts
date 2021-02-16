import { SystemRequirements, SystemRequirementError, SystemRequirement, SystemRequirementResolution } from "./models";
import { DotnetExeName, resolveDotnetRequirement } from "./dotnet";
import { resolveGenericSystemRequirement } from "./generic";
import { JavaExeName, resolveJavaRequirement } from "./java";
import { PythonRequirement, resolvePythonRequirement } from "./python";

export const validateSystemRequirements = async (
  requirements: SystemRequirements,
): Promise<SystemRequirementError[]> => {
  const errors: SystemRequirementError[] = [];

  for (const [name, requirement] of Object.entries(requirements)) {
    const result = await resolveSystemRequirement(name, requirement);
    if ("error" in result) {
      errors.push(result);
    }
  }
  return errors;
};

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
      return resolveGenericSystemRequirement(name, requirement);
  }
};
