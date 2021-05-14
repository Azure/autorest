import { Refable } from "@azure-tools/openapi";

export enum SemanticErrorCodes {
  DiscriminatorNotRequired = "DiscriminatorNotRequired",
  PathParameterEmtpy = "PathParameterEmtpy",
  PathParameterMissingDefinition = "PathParameterMissingDefinition",
  OutdatedExtension = "OutdatedExtension",
  IgnoredPropertyNextToRef = "IgnoredPropertyNextToRef",
}

export type SemanticErrorLevel = "error" | "warn";

export interface SemanticError {
  level: SemanticErrorLevel;
  code: string;
  message: string;
  params: Record<string, unknown>;
  path: string[];
}

export type ResolveReferenceFn<T = any> = (r: Refable<T>) => T;
