import { execute } from "../exec-cmd";
import { SystemRequirement, SystemRequirementError } from "./system-requirements";

export const validateDotnetRequirement = async (
  requirement: SystemRequirement,
): Promise<SystemRequirementError | undefined> => {
  const actualVersion = await getDotnetVersion();
  if (actualVersion === undefined) {
    return {
      name: "dotnet",
      message:
        requirement.message ?? `dotnet command line is not found in the path. Make sure to have dotnet installed.`,
    };
  }
};

const getDotnetVersion = async (): Promise<string | undefined> => {
  try {
    const result = await execute("dotnet2", ["--version"]);
    return result.stdout;
  } catch (e) {
    return undefined;
  }
};
