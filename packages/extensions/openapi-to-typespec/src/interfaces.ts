export interface TypespecProgram {
  models: Models;
  operationGroups: TypespecOperationGroup[];
  serviceInformation: ServiceInformation;
  containsListOperation: boolean;
}

export interface TypespecOptions {
  isAzureSpec: boolean;
  namespace?: string;
  guessResourceKey: boolean;
  isArm: boolean;
  isFullCompatible: boolean;
  isTest: boolean;
}

export interface TypespecChoiceValue extends WithDoc {
  name: string;
  value: string | number | boolean;
  clientDecorators?: TypespecDecorator[];
}

export interface WithDoc {
  doc?: string | string[];
}

export interface WithSummary {
  summary?: string;
}

export interface WithDecorators {
  decorators?: TypespecDecorator[];
  clientDecorators?: TypespecDecorator[];
  augmentDecorators?: TypespecDecorator[];
}

export interface TypespecOperationGroup extends WithDoc, WithSuppressDirectives {
  name: string;
  operations: (TypespecOperation | TspArmProviderActionOperation)[];
}

export type Extension = "Pageable" | "LRO";
export interface TypespecOperation extends WithDoc, WithSummary, WithFixMe {
  name: string;
  verb: "get" | "post" | "put" | "delete";
  route: string;
  responses: [string, string][];
  parameters: TypespecParameter[];
  extensions: Extension[];
  resource?: TypespecResource;
  operationGroupName?: string;
  operationId?: string;
  examples?: Record<string, Record<string, unknown>>;
  clientDecorators?: TypespecDecorator[];
  decorators?: TypespecDecorator[];
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

export interface ApiKeyAuthentication {
  kind: "ApiKeyAuth";
  location: "header" | "query" | "cookie";
  name: string;
}

export type Auth = ApiKeyAuthentication | AadOauth2AuthFlow | AadTokenAuthFlow;

export interface ServiceInformation extends WithDoc {
  name: string;
  versions?: string[];
  endpoint?: string;
  endpointParameters?: EndpointParameter[];
  produces?: string[];
  consumes?: string[];
  authentication?: Auth[];
  armCommonTypeVersion?: string;
  userSetArmCommonTypeVersion?: string;
}

export interface EndpointParameter extends WithDoc {
  name: string;
}

export interface TypespecDataType extends WithDoc, WithFixMe, WithSuppressDirectives {
  kind: string;
  name: string;
}

export interface TypespecVoidType extends TypespecDataType {
  kind: "void";
  name: "_";
}

export type TypespecModel = TypespecTemplateModel | TypespecDataType;

export interface TypespecTemplateModel extends TypespecDataType {
  kind: "template";
  arguments?: TypespecModel[];
  namedArguments?: Record<string, string>; // TO-DO: value is string for now, should be refacted to some object type
  additionalProperties?: TypespecParameter[]; // Currently for body purpose
  additionalTemplateModel?: string; // Currently for LRO header purpose
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
  clientDecorators?: TypespecDecorator[];
  choiceType: string;
}

export interface WithFixMe {
  fixMe?: string[];
}

export interface WithSuppressDirectives {
  suppressions?: WithSuppressDirective[];
}

export interface WithSuppressDirective {
  suppressionCode?: string;
  suppressionMessage?: string;
}

export type TypespecParameterLocation = "path" | "query" | "header" | "body";
export interface TypespecParameter extends TypespecDataType {
  kind: "parameter";
  isOptional: boolean;
  type: string;
  decorators?: TypespecDecorator[];
  clientDecorators?: TypespecDecorator[];
  location: TypespecParameterLocation;
  serializedName: string;
  defaultValue?: any;
}

export interface TypespecObjectProperty extends TypespecDataType, WithSuppressDirectives {
  kind: "property";
  isOptional: boolean;
  type: string;
  decorators?: TypespecDecorator[];
  clientDecorators?: TypespecDecorator[];
  defaultValue?: any;
}

// A spread statement is always spreading some model or template from library
export interface TypespecSpreadStatement extends WithSuppressDirectives, WithDecorators, WithDoc {
  kind: "spread";
  model: TypespecTemplateModel;
}

export interface TypespecDecorator extends WithFixMe, WithSuppressDirective {
  name: string;
  arguments?: (string | number | string[])[] | DecoratorArgument[];
  module?: string;
  namespace?: string;
  target?: string;
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
  augmentDecorators?: TypespecDecorator[];
  clientDecorators?: TypespecDecorator[];
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

export type TspArmResourceOperation =
  | TspArmResourceActionOperation
  | TspArmResourceListOperation
  | TspArmResourceLifeCycleOperation;

export interface TspArmResourceOperationBase
  extends WithDoc,
    WithSummary,
    WithDecorators,
    WithFixMe,
    WithSuppressDirectives {
  kind: TspArmOperationType;
  name: string;
  resource: string;
  baseParameters?: string[];
  parameters?: TypespecParameter[];
  response?: TypespecTemplateModel[] | TypespecVoidType;
  operationId?: string;
  lroHeaders?: TspLroHeaders;
  examples?: Record<string, Record<string, unknown>>;
  augmentedDecorators?: string[];
  patchModel?: string;
}

export interface TspArmResourceActionOperation extends TspArmResourceOperationBase {
  kind: "ArmResourceActionSync" | "ArmResourceActionAsync" | "ArmResourceActionAsyncBase";
  request: TypespecParameter | TypespecVoidType | TypespecDataType;
  response: TypespecTemplateModel[] | TypespecVoidType;
}

export function isArmResourceActionOperation(
  operation: TspArmResourceOperationBase,
): operation is TspArmResourceActionOperation {
  return (
    operation.kind === "ArmResourceActionSync" ||
    operation.kind === "ArmResourceActionAsync" ||
    operation.kind === "ArmResourceActionAsyncBase"
  );
}

export interface TspArmResourceLifeCycleOperation extends TspArmResourceOperationBase {
  kind:
    | "ArmResourceRead"
    | "ArmResourceCheckExistence"
    | "ArmResourceCreateOrReplaceSync"
    | "ArmResourceCreateOrReplaceAsync"
    | "ArmResourcePatchSync"
    | "ArmResourcePatchAsync"
    | "ArmCustomPatchSync"
    | "ArmCustomPatchAsync"
    | "ArmResourceDeleteSync"
    | "ArmResourceDeleteWithoutOkAsync";
}

export interface TspArmResourceListOperation extends TspArmResourceOperationBase {
  kind: "ArmResourceListByParent" | "ArmListBySubscription" | "ArmResourceListAtScope";
}

export type TspLroHeaders = "Azure-AsyncOperation" | "Location";
export type TspArmOperationType =
  | "ArmResourceRead"
  | "ArmResourceCheckExistence"
  | "ArmResourceCreateOrReplaceSync"
  | "ArmResourceCreateOrReplaceAsync"
  | "ArmResourcePatchSync"
  | "ArmResourcePatchAsync"
  | "ArmCustomPatchSync"
  | "ArmCustomPatchAsync"
  | "ArmResourceDeleteSync"
  | "ArmResourceDeleteWithoutOkAsync"
  | "ArmResourceActionSync"
  | "ArmResourceActionAsync"
  | "ArmResourceActionAsyncBase"
  | "ArmResourceListByParent"
  | "ArmListBySubscription"
  | "ArmResourceListAtScope";

// TO-DO: consolidate with other templates
export interface TspArmProviderActionOperation extends WithDoc, WithSummary, WithSuppressDirectives {
  kind: "ArmProviderActionAsync" | "ArmProviderActionSync";
  name: string;
  action?: string;
  response?: string;
  verb?: string;
  scope?: "TenantActionScope" | "SubscriptionActionScope";
  parameters: TypespecParameter[];
  request?: TypespecParameter;
  decorators?: TypespecDecorator[];
  lroHeaders?: TspLroHeaders;
}

export interface TspArmResource extends TypespecDataType, WithFixMe, WithDoc, WithDecorators {
  resourceKind: ArmResourceKind;
  properties: (TypespecObjectProperty | TypespecSpreadStatement)[];
  propertiesModelName: string;
  propertiesPropertyRequired: boolean;
  propertiesPropertyDescription: string;
  propertiesPropertyClientDecorator: TypespecDecorator[];
  resourceParent?: TspArmResource;
  resourceOperationGroups: TspArmResourceOperationGroup[];
  locationParent?: string;
}

export interface TspArmResourceOperationGroup {
  isLegacy: boolean;
  interfaceName: string;
  resourceOperations: TspArmResourceOperation[];
  legacyOperationGroup?: TspArmResourceLegacyOperationGroup;
}

export interface TspArmResourceLegacyOperationGroup {
  interfaceName: string;
  parentParameters: string[];
  resourceTypeParameter: string;
}
