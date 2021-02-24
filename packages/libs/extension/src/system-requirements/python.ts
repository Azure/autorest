import { execute } from "../exec-cmd";
import { getExecutablePath } from "./common";
import { SystemRequirement, SystemRequirementError, SystemRequirementResolution } from "./models";
import { validateVersionRequirement } from "./version";

export const PythonRequirement = "python";

/**
 * Small python script that will print the python version.
 */
const PRINT_PYTHON_VERSION_SCRIPT = "import sys; print('.'.join(map(str, sys.version_info[:3])))";

export const resolvePythonRequirement = async (
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

export type KnownPythonExe = "python.exe" | "python3.exe" | "python" | "python3";

/**
 * List representing a python command line.
 */
export type PythonCommandLine = [KnownPythonExe, ...string[]];

/**
 * This method is kept for backward compatibility and will be removed in a future release.
 * @deprecated Please use patchPythonPath(command, requirement) instead.
 */
export const updatePythonPath = async (command: PythonCommandLine): Promise<string[]> => {
  const newCommand = await patchPythonPath(command, { version: ">=3.6", environmentVariable: "AUTOREST_PYTHON_EXE" });
  (command as string[])[0] = newCommand[0];
  return newCommand;
};

/**
 * @param command list of the command and arguments. First item in array must be a python exe @see KnownPythonExe. (e.g. ["python", "mypythonfile.py"]
 * @param requirement
 */
export const patchPythonPath = async (
  command: PythonCommandLine,
  requirement: SystemRequirement,
): Promise<string[]> => {
  const [_, ...args] = command;
  const resolution = await resolvePythonRequirement(requirement);
  if ("error" in resolution) {
    throw new Error(`Failed to find compatible python version. ${resolution.message}`);
  }
  return [resolution.command, ...(resolution.additionalArgs ?? []), ...args];
};

const tryPython = async (
  requirement: SystemRequirement,
  command: string,
  additionalArgs: string[] = [],
): Promise<SystemRequirementResolution | SystemRequirementError> => {
  const resolution: SystemRequirementResolution = {
    name: PythonRequirement,
    command,
    additionalArgs: additionalArgs.length > 0 ? additionalArgs : undefined,
  };

  try {
    const result = await execute(command, [...additionalArgs, "-c", PRINT_PYTHON_VERSION_SCRIPT]);
    return validateVersionRequirement(resolution, result.stdout.trim(), requirement);
  } catch (e) {
    return {
      error: true,
      ...resolution,
      message: `'${command}' command line is not found in the path. Make sure to have it installed.`,
    };
  }
};

const createPythonErrorMessage = (
  requirement: SystemRequirement,
  errors: SystemRequirementError[],
): SystemRequirementError => {
  const versionReq = requirement.version ?? "*";
  const lines = [
    `Couldn't find a valid python interpreter satisfying the requirement (version: ${versionReq}). Tried:`,
    ...errors.map((x) => ` - ${x.command} (${x.message})`),
  ];

  return {
    error: true,
    name: "python",
    command: "python",
    message: lines.join("\n"),
  };
};
