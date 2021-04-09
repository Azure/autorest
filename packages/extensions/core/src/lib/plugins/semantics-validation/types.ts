import { Refable } from "@azure-tools/openapi";

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

export type ResolveReferenceFn<T = any> = (r: Refable<T>) => T;
