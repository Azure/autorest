/**
 * List of configuration that can be used with modelerfour.
 */
export interface ModelerFourOptions {
  /**
   * Flag to automatically add the Content-Type header to operations.
   */
  "always-create-content-type-parameter"?: boolean;

  /**
   * Flag to automatically add the Accept header to operations.
   */
  "always-create-accept-parameter"?: boolean;

  "always-seal-x-ms-enums"?: boolean;

  "content-type-extensible"?: boolean;

  "flatten-models"?: boolean;

  "flatten-payloads"?: boolean;

  "keep-unused-flattened-models"?: boolean;

  "multiple-request-parameter-flattening"?: boolean;

  "group-parameters"?: boolean;

  "additional-checks"?: boolean;

  "lenient-model-deduplication"?: boolean;

  naming?: ModelerFourNamingOptions;

  prenamer?: boolean;

  "resolve-schema-name-collisons"?: boolean;

  /**
   * In the case where a type only definition is to inherit another type remove it.
   * @example ChildSchema: {allOf: [ParentSchema]}.
   * In this case ChildSchema will be removed and all reference to it will be updated to point to ParentSchema
   */
  "remove-empty-child-schemas"?: boolean;

  /**
   * Disable anyobject type and default to type any instead.
   * This is a temporary flag to smooth transition. It WILL be removed in a future version.
   */
  "treat-type-object-as-anything"?: boolean;

  /**
   * Enable older inconsistent behavior that an enum with a single value would become a constant by default.
   */
  "seal-single-value-enum-by-default"?: boolean;

  /**
   * Ignore the special treament of the given header name.
   */
  "skip-special-headers"?: string[];
  /**
   * List of header names that shouldn't be included in the codemodel.
   * Those header would already be handled by the generator.
   */
  "ignore-headers"?: string[];

  /**
   * Use legacy request body resolution.
   * Used for transition period DO NOT DEPEND on this.
   */
  "legacy-request-body"?: boolean;
}

export interface ModelerFourNamingOptions {
  "preserve-uppercase-max-length"?: number;
  parameter?: string;
  property?: string;
  operation?: string;
  operationGroup?: string;
  header?: string;
  choice?: string;
  choiceValue?: string;
  constant?: string;
  constantParameter?: string;
  client?: string;
  type?: string;
  global?: string;
  local?: string;
  override?: any;
}
