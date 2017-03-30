// The settings interface describe the server relevant settings part
export interface Settings {
  autorest: AutoRestSettings;
}

// These are the settings we defined in the client's package.json
// file
export interface AutoRestSettings {
  maxNumberOfProblems: number;
}