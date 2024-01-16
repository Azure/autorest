export interface TypespecProgram {
  models: Models;
  operationGroups: TypespecOperationGroup[];
  serviceInformation: ServiceInformation;
}

export interface TypespecOptions {
  isAzureSpec: boolean;
  namespace?: string;
  guessResourceKey: boolean;
  isArm: boolean;
}

export interface TypespecChoiceValue extends WithDoc {
  name: string;
  value: string | number | boolean;
}

export interface WithDoc {
  doc?: string | string[];
}

export interface WithSummary {
  summary?: string;
}

export interface TypespecOperationGroup extends WithDoc {
  name: string;
  operations: TypespecOperation[];
}

export type Extension = "Pageable" | "LRO";
export interface TypespecOperation extends WithDoc, WithSummary, WithFixMe {
  name: string;
  verb: "get" | "post" | "put" | "delete";
  route: string;
  responses: string[];
  parameters: TypespecParameter[];
  extensions: Extension[];
  resource?: TypespecResource;
  operationGroupName?: string;
  operationId?: string;
  examples?: Record<string, Record<string, unknown>>;
}

export type ResourceKind =
  | "ResourceCreateOrUpdate"
  | "ResourceCreateOrReplace"
  | "ResourceCreateWithServiceProvidedName"
  | "ResourceRead"
  | "ResourceDelete"
  | "ResourceList"
  | "NonPagedResourceList"
  | "ResourceAction"
  | "ResourceCollectionAction"
  | "LongRunningResourceCreateOrReplace"
  | "LongRunningResourceCreateOrUpdate"
  | "LongRunningResourceCreateWithServiceProvidedName"
  | "LongRunningResourceDelete";

export interface TypespecResource {
  kind: ResourceKind;
  response: TypespecDataType;
}

export interface AadOauth2AuthFlow {
  kind: "AadOauth2Auth";
  scopes: string[];
}

export interface AadTokenAuthFlow {
  kind: "AadTokenAuthFlow";
  scopes: string[];
}

export interface AzureApiKeyAuthentication {
  kind: "AzureApiKeyAuthentication";
}

export type Auth = AzureApiKeyAuthentication | AadOauth2AuthFlow | AadTokenAuthFlow;


export interface ServiceInformation extends WithDoc {
  name: string;
  versions?: string[];
  endpoint?: string;
  endpointParameters?: EndpointParameter[];
  produces?: string[];
  consumes?: string[];
  authentication?: Auth[];
  armCommonTypeVersion?: string;
}

export interface EndpointParameter extends WithDoc {
  name: string;
}

export interface TypespecDataType extends WithDoc, WithFixMe {
  kind: string;
  name: string;
}

export interface TypespecWildcardType extends TypespecDataType {
  kind: "wildcard";
}

export interface DecoratorArgumentOptions {
  unwrap?: boolean;
}

export interface DecoratorArgument {
  value: string;
  options?: DecoratorArgumentOptions;
}

export interface TypespecEnum extends TypespecDataType {
  kind: "enum";
  members: TypespecChoiceValue[];
  isExtensible: boolean;
  decorators?: TypespecDecorator[];
}

export interface WithFixMe {
  fixMe?: string[];
}

export type TypespecParameterLocation = "path" | "query" | "header" | "body";
export interface TypespecParameter extends TypespecDataType {
  kind: "parameter";
  isOptional: boolean;
  type: string;
  decorators?: TypespecDecorator[];
  location: TypespecParameterLocation;
  serializedName: string;
  defaultValue?: any;
}

export interface TypespecObjectProperty extends TypespecDataType {
  kind: "property";
  isOptional: boolean;
  type: string;
  decorators?: TypespecDecorator[];
  defaultValue?: any;
}

export interface TypespecDecorator extends WithFixMe {
  name: string;
  arguments?: (string | number)[] | DecoratorArgument[];
  module?: string;
  namespace?: string;
}

export interface TypespecAlias {
  alias: string;
  params?: string[];
  module?: string;
}

export interface TypespecObject extends TypespecDataType {
  kind: "object";
  properties: TypespecObjectProperty[];
  parents: string[];
  extendedParents?: string[];
  spreadParents?: string[];
  decorators?: TypespecDecorator[];
  alias?: TypespecAlias;
}

export interface Models {
  enums: TypespecEnum[];
  objects: TypespecObject[];
  armResources: TspArmResource[];
}

export type ArmResourceKind = "TrackedResource" | "ProxyResource" | "ExtensionResource";
export type ArmResourceOperationKind = "TrackedResourceOperations" | "ProxyResourceOperations";

const FIRST_LEVEL_RESOURCE = [
  "ResourceGroupResource",
  "SubscriptionResource",
  "ManagementGroupResource",
  "TenantResource",
  "ArmResource",
] as const;
export type FirstLevelResource = (typeof FIRST_LEVEL_RESOURCE)[number];

export function isFirstLevelResource(value: string): value is FirstLevelResource {
  return FIRST_LEVEL_RESOURCE.includes(value as FirstLevelResource);
}

export interface TspArmResourceOperationBase extends WithDoc, WithFixMe {
  kind: string;
  name: string;
  templateParameters?: string[];
  decorators?: TypespecDecorator[];
  operationId?: string;
  examples?: Record<string, Record<string, unknown>>;
  augmentedDecorators?: string[];
}

export type TspArmResourceOperation =
  | TspArmResourceListOperation
  | TspArmResourceNonListOperation
  | TspArmResourceExistsOperation;

export interface TspArmResourceNonListOperation extends TspArmResourceOperationBase {
  kind:
    | "ArmResourceRead"
    | "ArmResourceCreateOrReplaceSync"
    | "ArmResourceCreateOrReplaceAsync"
    | "ArmResourcePatchSync"
    | "ArmResourcePatchAsync"
    | "ArmTagsPatchSync"
    | "ArmTagsPatchAsync"
    | "ArmCustomPatchSync"
    | "ArmCustomPatchAsync"
    | "ArmResourceDeleteSync"
    | "ArmResourceDeleteAsync"
    | "ArmResourceDeleteWithoutOkAsync"
    | "ArmResourceActionSync"
    | "ArmResourceActionNoContentSync"
    | "ArmResourceActionAsync"
    | "ArmResourceActionNoResponseContentAsync"
    | "checkGlobalNameAvailability"
    | "checkLocalNameAvailability"
    | "checkNameAvailability";
}

export interface TspArmResourceListOperation extends TspArmResourceOperationBase {
  kind: "ArmResourceListByParent" | "ArmListBySubscription" | "ArmResourceListAtScope";
}

export interface TspArmResourceExistsOperation extends TspArmResourceOperationBase {
  kind: "ArmResourceExists";
  parameters: string[];
  responses: string[];
}

export interface TspArmResource extends TypespecObject {
  resourceKind: ArmResourceKind;
  propertiesModelName: string;
  resourceParent?: TspArmResource;
  resourceOperations: TspArmResourceOperation[];
  normalOperations: TypespecOperation[];
  optionalStandardProperties: string[];
}
