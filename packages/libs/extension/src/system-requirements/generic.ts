import commandExists from "command-exists";
import { SystemRequirementError, SystemRequirementResolution } from "./models";

export const resolveGenericSystemRequirement = async (
  name: string,
): Promise<SystemRequirementResolution | SystemRequirementError> => {
  const isAvailable = await checkIfExcutableAvailable(name);
  const resolution = { name, command: name };
  return isAvailable
    ? resolution
    : {
        error: true,
        ...resolution,
        message: `Couldn't find executable '${name}' in path. Make sure it is installed.`,
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
