export type ConfigurationSchema = {
  readonly [key: string]: ConfigurationSchema | ConfigurationProperty;
};

export type ConfigurationPropertyType = "string" | "number" | "boolean" | ConfigurationSchema;

export type ConfigurationProperty = {
  readonly type: ConfigurationPropertyType;
  readonly array?: boolean;
  readonly dictionary?: boolean;
  readonly enum?: readonly string[];
  readonly description?: string;
};

export type EnumType<T extends ReadonlyArray<string>> = T[number];

// prettier-ignore
export type InferredProcessedType<T> =
  T extends { array: true }      ? InferredPrimitiveType<T>[]
: T extends { dictionary: true } ? Record<string, InferredPrimitiveType<T>>
  : InferredPrimitiveType<T>;

// prettier-ignore
export type InferredPrimitiveType<T> =
  T extends { type: "string", enum: ReadonlyArray<string> }  ? EnumType<T["enum"]>
  : T extends { type: ConfigurationSchema }                  ? RawConfiguration<T["type"]>
  : T extends { type: "string" }                             ? string
  : T extends { type: "number" }                             ? number
  : T extends { type: "boolean" }                            ? boolean
  : never;

// prettier-ignore
export type InferredRawType<T> =
  T extends {  array: true }       ? NonNullable<InferredRawPrimitiveType<T>>[] | InferredRawPrimitiveType<T>
  : T extends { dictionary: true } ? Record<string, InferredRawPrimitiveType<T>>
  : InferredRawPrimitiveType<T>;

// prettier-ignore
export type InferredRawPrimitiveType<T> =
  T extends { type: ConfigurationSchema }                     ? RawConfiguration<T["type"]> | undefined
  : T extends { type: "string", enum: ReadonlyArray<string> } ? EnumType<T["enum"]>
  : T extends { type: "string" }                              ? string | undefined
  : T extends { type: "number" }                              ? number | undefined
  : T extends { type: "boolean" }                             ? boolean | undefined
  : never;

export type ProcessedConfiguration<S extends ConfigurationSchema> = {
  [K in keyof S]: S[K] extends ConfigurationProperty
    ? InferredProcessedType<S[K]>
    : S[K] extends ConfigurationSchema
    ? ProcessedConfiguration<S[K]>
    : never;
};

export type RawConfiguration<S extends ConfigurationSchema> = {
  [K in keyof S]?: S[K] extends ConfigurationProperty
    ? InferredRawType<S[K]>
    : S[K] extends ConfigurationSchema
    ? RawConfiguration<S[K]>
    : never;
};
