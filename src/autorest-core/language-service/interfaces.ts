export interface Settings {
  autorest: AutoRestSettings;
}

// These are the settings we defined in the client's package.json
// file
export interface AutoRestSettings {
  maxNumberOfProblems: number;
  information: boolean;
  verbose: boolean;
  debug: boolean;
  runtimeId: string;
  minimumAutoRestVersion: string;
}