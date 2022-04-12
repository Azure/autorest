export interface FixResult {
  spec: any;
  fixes: Fix[];
}

export interface Fix {
  code: FixCode;
  message: string;
  filename: string;
  path: string[];
}

export enum FixCode {
  MissingTypeObject = "missing-type-object",
  SingleValueEnumConstant = "single-value-enum-constant",
}
