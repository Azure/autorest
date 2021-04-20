export type ConfigurationSchema = {
  readonly [key: string]: ConfigurationSchema | ConfigurationProperty;
};

export type ConfigurationPropertyType = "string" | "number" | "boolean" | ConfigurationSchema;

export type ConfigurationProperty = {
  /**
   * Type.
   */
  readonly type: ConfigurationPropertyType;

  /**
   * If this is an array of the type.
   */
  readonly array?: boolean;

  /**
   * If this is a map/dictionary of the type.
   */
  readonly dictionary?: boolean;

  /**
   * List of supported values. Only supported for type: string.
   */
  readonly enum?: readonly string[];

  /**
   * Description for the flag.
   */
  readonly description?: string;

  /**
   * Mark this config flag as deprecated.It will log a warning when used.
   */
  readonly deprecated?: boolean;
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
  : T extends { type: "string" }                             ? string
  : T extends { type: "number" }                             ? number
  : T extends { type: "boolean" }                            ? boolean
  : T extends { type: ConfigurationSchema }                  ? ProcessedConfiguration<T["type"]>
  : never;

// prettier-ignore
export type InferredRawType<T> =
  T extends { array: true }       ? NonNullable<InferredRawPrimitiveType<T>>[] | InferredRawPrimitiveType<T>
  : T extends { dictionary: true } ? Record<string, InferredRawPrimitiveType<T>>
  : InferredRawPrimitiveType<T>;

// prettier-ignore
export type InferredRawPrimitiveType<T> =
  T extends { type: "string", enum: ReadonlyArray<string> } ? EnumType<T["enum"]>
  : T extends { type: "string" }                              ? string | undefined
  : T extends { type: "number" }                              ? number | undefined
  : T extends { type: "boolean" }                             ? boolean | undefined
  : T extends { type: ConfigurationSchema }                     ? RawConfiguration<T["type"]> | undefined
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
