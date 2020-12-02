export interface Help {
  categoryFriendlyName: string; // e.g. "Output Verbosity", "C# generator"
  activationScope?: string; // e.g. "csharp"
  description?: string; // inline markdown allowed
  settings: Array<SettingHelp>;
}

export interface SettingHelp {
  required?: boolean; // defaults to "false"
  key: string; // e.g. "namespace"
  type?: string; // not specified => flag; otherwise, please use TypeScript syntax
  description: string; // inline markdown allowed
}
