/**
 * Represent set of system requirements.
 */
export interface ExtensionSystemRequirements {
  [name: string]: ExtensionSystemRequirement;
}

export interface SystemRequirement {
  version?: string;
  /**
   * Name of an environment variable where the user could provide the path to the exe.
   * @example "AUTOREST_PYTHON_PATH"
   */
  environmentVariable?: string;
}

export interface ExtensionSystemRequirement extends SystemRequirement {
  message?: string;
}

export interface SystemRequirementResolution {
  /**
   * Name of the requirement.
   * @example python, java, etc.
   */
  name: string;

  /**
   * Name of the command
   * @example python3, /home/myuser/python39/python, java, etc.
   */
  command: string;

  /**
   * List of additional arguments to pass to this command.
   * @example '-3' for 'py' to specify to use python 3
   */
  additionalArgs?: string[];
}

export interface SystemRequirementError extends SystemRequirementResolution {
  error: true;
  message: string;
  neededVersion?: string;
  actualVersion?: string;
}
