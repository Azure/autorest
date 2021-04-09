export enum SemanticErrorCodes {
  DiscriminatorNotRequired = "DiscriminatorNotRequired",
  PathParameterEmtpy = "PathParameterEmtpy",
  PathParameterMissingDefinition = "PathParameterMissingDefinition",
}

export interface SemanticError {
  code: string;
  message: string;
  params: Record<string, unknown>;
  path: string[];
}
