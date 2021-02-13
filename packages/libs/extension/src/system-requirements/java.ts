import { execute } from "../exec-cmd";
import { validateVersionRequirement } from "./common";
import { SystemRequirement, SystemRequirementError } from "./system-requirements";

export const JavaExeName = "java";

const ExeNotFoundMessage = `${JavaExeName} command line is not found in the path. Make sure to have ${JavaExeName} installed.`;

export const validateJavaRequirement = async (
  requirement: SystemRequirement,
): Promise<SystemRequirementError | undefined> => {
  const actualVersion = await getJavaVersion();
  if (actualVersion === undefined) {
    return {
      name: JavaExeName,
      message: requirement.message ?? ExeNotFoundMessage,
    };
  }

  return validateVersionRequirement(JavaExeName, actualVersion, requirement);
};

const getJavaVersion = async (): Promise<string | undefined> => {
  try {
    const result = await execute(JavaExeName, ["-version"]);
    return parseJavaVersionFromStdout(result.stdout);
  } catch (e) {
    return undefined;
  }
};

const JAVA_VERSION_REGEX = /java version "(.*)"/;

const parseJavaVersionFromStdout = (stdout: string): string | undefined => {
  const match = JAVA_VERSION_REGEX.exec(stdout);
  return match?.[1];
};
