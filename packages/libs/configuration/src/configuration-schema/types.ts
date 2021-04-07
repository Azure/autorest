export type ConfigurationSchema = {
  [key: string]: ConfigurationSchema | ConfigurationProperty;
};

export type ConfigurationPropertyType = "string" | "number" | "boolean";

export type ConfigurationProperty = {
  type: ConfigurationPropertyType;
  array?: boolean;
  description?: string;
};

export type InferredProcessedType<T> = T extends { type: "string"; array: true }
  ? string[]
  : T extends { type: "number"; array: true }
  ? number[]
  : T extends { type: "boolean"; array: true }
  ? boolean[]
  : T extends { type: "string" }
  ? string
  : T extends { type: "number" }
  ? number
  : T extends { type: "boolean" }
  ? boolean
  : never;

export type InferredRawType<T> = T extends { type: "string"; array: true }
  ? string[] | string | undefined
  : T extends { type: "number"; array: true }
  ? number[] | number | undefined
  : T extends { type: "boolean"; array: true }
  ? boolean[] | boolean | undefined
  : T extends { type: "string" }
  ? string | undefined
  : T extends { type: "number" }
  ? number | undefined
  : T extends { type: "boolean" }
  ? boolean | undefined
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