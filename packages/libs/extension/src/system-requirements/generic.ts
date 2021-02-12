import commandExists from "command-exists";
import { SystemRequirement, SystemRequirementError } from "./system-requirements";

export const validateGenericSystemRequirement = async (
  name: string,
  requirement: SystemRequirement,
): Promise<SystemRequirementError | undefined> => {
  const isAvailable = await checkIfExcutableAvailable(name);

  return isAvailable
    ? undefined
    : {
        name,
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
