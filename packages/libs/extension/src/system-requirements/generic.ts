import commandExists from "command-exists";
import { SystemRequirement, SystemRequirementError, SystemRequirementResolution } from "./models";

export const validateGenericSystemRequirement = async (
  name: string,
  requirement: SystemRequirement,
): Promise<SystemRequirementResolution | SystemRequirementError> => {
  const isAvailable = await checkIfExcutableAvailable(name);
  const resolution = { name, command: name };
  return isAvailable
    ? resolution
    : {
        error: true,
        ...resolution,
        message: requirement.message ?? `Couldn't find executable '${name}' in path. Make sure it is installed.`,
      };
};

const checkIfExcutableAvailable = async (name: string): Promise<boolean> => {
  try {
    await commandExists(name);
    return true;
  } catch {
    return false;
  }
};
