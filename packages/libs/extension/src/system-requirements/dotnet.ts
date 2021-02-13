import { execute } from "../exec-cmd";
import { validateVersionRequirement } from "./common";
import { SystemRequirement, SystemRequirementError } from "./system-requirements";

export const DotnetExeName = "dotnet";

const ExeNotFoundMessage = `${DotnetExeName} command line is not found in the path. Make sure to have ${DotnetExeName} installed.`;

export const validateDotnetRequirement = async (
  requirement: SystemRequirement,
): Promise<SystemRequirementError | undefined> => {
  const actualVersion = await getDotnetVersion();
  if (actualVersion === undefined) {
    return {
      name: DotnetExeName,
      message: requirement.message ?? ExeNotFoundMessage,
    };
  }

  return validateVersionRequirement(DotnetExeName, actualVersion, requirement);
};

const getDotnetVersion = async (): Promise<string | undefined> => {
  try {
    const result = await execute(DotnetExeName, ["--version"]);
    return result.stdout;
  } catch (e) {
    return undefined;
  }
};
