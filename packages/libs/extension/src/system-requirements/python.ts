import { execute } from "../exec-cmd";
import { getExecutablePath, validateVersionRequirement } from "./common";
import { SystemRequirement, SystemRequirementError, SystemRequirementResolution, SystemRequirements } from "./models";

export const PythonRequirement = "python";

/**
 * Small python script that will print the python version.
 */
const PRINT_PYTHON_VERSION_SCRIPT = "import sys; print('.'.join(map(str, sys.version_info[:3])))";

export const validatePythonRequirement = async (
  requirement: SystemRequirement,
): Promise<SystemRequirementResolution | SystemRequirementError> => {
  // Hardcoding AUTOREST_PYTHON_EXE is for backward compatibility
  const path = getExecutablePath(requirement) ?? process.env["AUTOREST_PYTHON_EXE"];
  if (path) {
    return await tryPython(requirement, path);
  }

  const errors: SystemRequirementError[] = [];
  // On windows try `py` executable with `-3` flag.
  if (process.platform === "win32") {
    const pyResult = await tryPython(requirement, "py", ["-3"]);
    if ("error" in pyResult) {
      errors.push(pyResult);
    } else {
      return pyResult;
    }
  }

  const python3Result = await tryPython(requirement, "python3");
  if ("error" in python3Result) {
    errors.push(python3Result);
  } else {
    return python3Result;
  }

  const pythonResult = await tryPython(requirement, "python");
  if ("error" in pythonResult) {
    errors.push(pythonResult);
  } else {
    return pythonResult;
  }

  return createPythonErrorMessage(requirement, errors);
};

const tryPython = async (
  requirement: SystemRequirement,
  command: string,
  additionalArgs: string[] = [],
): Promise<SystemRequirementResolution | SystemRequirementError> => {
  const result = await execute(command, [...additionalArgs, "-c", PRINT_PYTHON_VERSION_SCRIPT]);
  return validateVersionRequirement({ name: PythonRequirement, command }, result.stdout, requirement);
};

const createPythonErrorMessage = (
  requirement: SystemRequirement,
  errors: SystemRequirementError[],
): SystemRequirementError => {
  const versionReq = requirement.version ?? "*";
  const lines = [
    `Couldn't find a valid python interpreter satisfying the requirement (version: ${versionReq}). Tried: `,
    errors.map((x) => ` - ${x.command}`),
  ];

  return {
    error: true,
    name: "python",
    command: "python",
    message: lines.join("\n"),
  };
};
