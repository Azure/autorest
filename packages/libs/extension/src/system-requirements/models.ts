/**
 * Represent set of system requirements.
 */
export interface SystemRequirements {
  [name: string]: SystemRequirement;
}

export interface SystemRequirement {
  version?: string;
  message?: string;
  /**
   * Name of an environment variable where the user could provide the path to the exe.
   * @example "AUTOREST_PYTHON_PATH"
   */
  environmentVariable?: string;
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
}

export interface SystemRequirementError extends SystemRequirementResolution {
  error: true;
  message: string;
  neededVersion?: string;
  actualVersion?: string;
}
