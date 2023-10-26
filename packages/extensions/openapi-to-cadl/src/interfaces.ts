export interface CadlProgram {
  models: Models;
  operationGroups: CadlOperationGroup[];
  serviceInformation: ServiceInformation;
}

export interface CadlOptions {
  isAzureSpec: boolean;
  namespace?: string;
  guessResourceKey: boolean;
  isArm: boolean;
}

export interface CadlChoiceValue extends WithDoc {
  name: string;
  value: string | number | boolean;
}

export interface WithDoc {
  doc?: string | string[];
}

export interface WithSummary {
  summary?: string;
}

export interface CadlOperationGroup extends WithDoc {
  name: string;
  operations: CadlOperation[];
}

export type Extension = "Pageable" | "LRO";
export interface CadlOperation extends WithDoc, WithSummary, WithFixMe {
  name: string;
  verb: "get" | "post" | "put" | "delete";
  route: string;
  responses: string[];
  parameters: CadlParameter[];
  extensions: Extension[];
  resource?: CadlResource;
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

export interface CadlResource {
  kind: ResourceKind;
  response: CadlDataType;
}

export interface ServiceInformation extends WithDoc {
  name: string;
  version?: string;
  endpoint?: string;
  endpointParameters?: EndpointParameter[];
  produces?: string[];
  consumes?: string[];
}

export interface EndpointParameter extends WithDoc {
  name: string;
}

export interface CadlDataType extends WithDoc, WithFixMe {
  kind: string;
  name: string;
}

export interface CadlWildcardType extends CadlDataType {
  kind: "wildcard";
}

export interface DecoratorArgumentOptions {
  unwrap?: boolean;
}

export interface DecoratorArgument {
  value: string;
  options?: DecoratorArgumentOptions;
}

export interface CadlEnum extends CadlDataType {
  kind: "enum";
  members: CadlChoiceValue[];
  isExtensible: boolean;
  decorators?: CadlDecorator[];
}

export interface WithFixMe {
  fixMe?: string[];
}

export type CadlParameterLocation = "path" | "query" | "header" | "body";
export interface CadlParameter extends CadlDataType {
  kind: "parameter";
  isOptional: boolean;
  type: string;
  decorators?: CadlDecorator[];
  location: CadlParameterLocation;
  serializedName: string;
}

export interface CadlObjectProperty extends CadlDataType {
  kind: "property";
  isOptional: boolean;
  type: string;
  decorators?: CadlDecorator[];
}

export interface CadlDecorator extends WithFixMe {
  name: string;
  arguments?: (string | number)[] | DecoratorArgument[];
  module?: string;
  namespace?: string;
}

export interface CadlAlias {
  alias: string;
  params?: string[];
  module?: string;
}

export interface CadlObject extends CadlDataType {
  kind: "object";
  properties: CadlObjectProperty[];
  parents: string[];
  extendedParents?: string[];
  spreadParents?: string[];
  decorators?: CadlDecorator[];
  alias?: CadlAlias;
}

export interface Models {
  enums: CadlEnum[];
  objects: CadlObject[];
  armResources: TspArmResource[];
}

export type ArmResourceKind = "TrackedResource" | "ProxyResource" | "ExtensionResource";
export type ArmResourceOperationKind = "TrackedResourceOperations" | "ProxyResourceOperations";

const FIRST_LEVEL_RESOURCE = [
  "ResourceGroupResource",
  "SubscriptionResource",
  "ManagementGroupResource",
  "TenantResource",
] as const;
export type FirstLevelResource = typeof FIRST_LEVEL_RESOURCE[number];

export function isFirstLevelResource(value: string): value is FirstLevelResource {
  return FIRST_LEVEL_RESOURCE.includes(value as FirstLevelResource);
}

export interface TspArmResourceOperationBase extends WithDoc, WithFixMe {
  kind: string;
  name: string;
  templateParameters: string[];
  decorators?: CadlDecorator[];
}

export type TspArmResourceOperation = TspArmResourceListOperation | TspArmResourceNonListOperation;

export interface TspArmResourceNonListOperation extends TspArmResourceOperationBase {
  kind:
    | "ArmResourceRead"
    | "ArmResourceCreateOrReplaceSync"
    | "ArmResourceCreateOrUpdateAsync"
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
    | "ArmResourceActionNoResponseContentAsync";
}

export interface TspArmResourceListOperation extends TspArmResourceOperationBase {
  kind: "ArmResourceListByParent" | "ArmListBySubscription" | "ArmResourceListAtScope";
}

export type MSIType =
  | "Azure.ResourceManager.ManagedServiceIdentity"
  | "Azure.ResourceManager.ManagedSystemAssignedIdentity";
export interface TspArmResource extends CadlObject {
  resourceName: string;
  resourceKind: ArmResourceKind;
  propertiesModelName: string;
  resourceParent?: TspArmResource;
  resourceOperations: TspArmResourceOperation[];
  normalOperations: CadlOperation[];
  msiType?: MSIType;
}
