export type ConfigurationSchemaDefinition<C extends string, S extends RootConfigurationSchema<C>> = {
  readonly categories: {
    [key in C]: CategoryDefinition;
  };
  readonly schema: S;
};

export type RootConfigurationSchema<C extends string> = {
  readonly [key: string]: RootConfigurationProperty<C>;
};

export type ConfigurationSchema = {
  readonly [key: string]: ConfigurationProperty;
};

export type ConfigurationPropertyType = "string" | "number" | "boolean" | "array" | "dictionary" | "object";

export type CategoryDefinition = {
  name: string;
  description?: string;
};

export type RootConfigurationProperty<C extends string> = ConfigurationProperty & {
  /**
   * Category for the configuration. For documentation purposes.
   */
  readonly category?: C;
};

export type ConfigurationPropertyBase = {
  readonly type: ConfigurationPropertyType;

  /**
   * Description for the configuration.
   */
  readonly description?: string;

  /**
   * Mark this config as deprecated.It will log a warning when used.
   */
  readonly deprecated?: boolean;
};

export type StringConfigurationProperty = ConfigurationPropertyBase & {
  type: "string";
  /**
   * List of supported values. Only supported for type: string.
   */
  readonly enum?: readonly string[];
};

export type NumberConfigurationProperty = ConfigurationPropertyBase & {
  type: "number";
};

export type BooleanConfigurationProperty = ConfigurationPropertyBase & {
  type: "boolean";
};

export type ArrayConfigurationProperty = ConfigurationPropertyBase & {
  type: "array";
  items: PrimitiveConfigurationProperty;
};

export type DictionaryConfigurationProperty = ConfigurationPropertyBase & {
  type: "dictionary";
  items: PrimitiveConfigurationProperty;
};

export type ObjectConfigurationProperty = ConfigurationPropertyBase & {
  type: "object";
  properties: ConfigurationSchema;
};

export type ConfigurationProperty =
  | PrimitiveConfigurationProperty
  | ArrayConfigurationProperty
  | DictionaryConfigurationProperty;

export type PrimitiveConfigurationProperty =
  | ObjectConfigurationProperty
  | StringConfigurationProperty
  | NumberConfigurationProperty
  | BooleanConfigurationProperty;

export type EnumType<T extends ReadonlyArray<string>> = T[number];

export type ProcessedConfiguration<S extends ConfigurationSchema> = {
  [K in keyof S]: InferredProcessedType<S[K]>;
};

// prettier-ignore
export type InferredProcessedType<T extends ConfigurationProperty> =
  T extends ArrayConfigurationProperty         ? InferredProcessedArrayType<T["items"]>
  : T extends DictionaryConfigurationProperty    ? InferredProcessedDictionaryType<T["items"]>
  : T extends PrimitiveConfigurationProperty ? InferredProcessedPrimitiveType<T>
  : never;

export type InferredProcessedArrayType<T extends PrimitiveConfigurationProperty> = InferredProcessedPrimitiveType<T>[];
export type InferredProcessedDictionaryType<T extends PrimitiveConfigurationProperty> = Record<
  string,
  InferredProcessedPrimitiveType<T>
>;

// prettier-ignore
export type InferredProcessedPrimitiveType<T extends PrimitiveConfigurationProperty> =
  T extends { type: "string", enum: ReadonlyArray<string> }  ? EnumType<T["enum"]>
  : T extends { type: "string" }                             ? string
  : T extends { type: "number" }                             ? number
  : T extends { type: "boolean" }                            ? boolean
  : T extends ObjectConfigurationProperty                    ? ProcessedConfiguration<T["properties"]>
  : never;

// prettier-ignore
export type InferredRawType<T extends ConfigurationProperty> =
  T extends ArrayConfigurationProperty        ? InferredRawArrayType<T["items"]>
  : T extends DictionaryConfigurationProperty ? InferredRawDictionaryType<T["items"]>
  : T extends PrimitiveConfigurationProperty ? InferredRawPrimitiveType<T>
  : never;

export type InferredRawArrayType<T extends PrimitiveConfigurationProperty> =
  | NonNullable<InferredRawPrimitiveType<T>>[]
  | InferredRawPrimitiveType<T>;
export type InferredRawDictionaryType<T extends ConfigurationProperty> = Record<string, InferredRawType<T>>;

// prettier-ignore
export type InferredRawPrimitiveType<T extends PrimitiveConfigurationProperty> =
  T extends { type: "string", enum: ReadonlyArray<string> } ? EnumType<T["enum"]>
  : T extends { type: "string" }                            ? string | undefined
  : T extends { type: "number" }                            ? number | undefined
  : T extends { type: "boolean" }                           ? boolean | undefined
  : T extends ObjectConfigurationProperty                   ? RawConfiguration<T["properties"]> | undefined
  : never;

export type RawConfiguration<S extends ConfigurationSchema> = {
  [K in keyof S]?: InferredRawType<S[K]>;
};
