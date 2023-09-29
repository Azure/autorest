import { ImplementationLocation, ObjectSchema, Operation } from "@autorest/codemodel";

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
  location: CadlParameterLocation;
  implementation?: "Method" | "Client" | "Context";
}

export interface CadlObjectProperty extends CadlDataType {
  kind: "property";
  isOptional: boolean;
  type: string;
  decorators?: CadlDecorator[];
  visibility?: "read";
}
export interface DecoratorArgumentOptions {
  unwrap?: boolean;
}

export interface DecoratorArgument {
  value: string;
  options?: DecoratorArgumentOptions;
}

export interface CadlDecorator extends WithFixMe {
  name: string;
  arguments?: string[] | DecoratorArgument[];
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

export type ArmResourceKind = "TrackedResource" | "ProxyResource" | "ExtensionResource" | "SingletonResource";

export interface ArmResourceMetadata {
  name: string;
  doc: string;
  location: any;
  pattern: string;
  segmentName: string;
}

export interface TypespecArmResource extends CadlObject {
  resourceKind: ArmResourceKind;
  propertiesModelName: string;
  resourceParent?: TypespecArmResource;
  metadata: ArmResourceMetadata;
  operations: Operation[];
  schema: ObjectSchema;
}

export interface Models {
  enums: CadlEnum[];
  objects: CadlObject[];
}

export interface InternalArmResources {
  Resources: InternalArmResource[];
}

export interface InternalArmResource {
  Name: string;
  Operations: InternalArmResourceOperation[];
  Parents: string[];
  ModelName: string;
  IsTrackedResource: boolean;
  IsResource: boolean;
  IsExtensionResource: boolean;
  IsSingletonResource: boolean;
}

export interface InternalArmResourceOperation {
  Path: string;
  Method: HttpMethod;
  OperationID: string;
}

export interface ArmResourceObjectSchema extends ObjectSchema {
  resourceInformation?: InternalArmResource;
}

type HttpMethod = "GET" | "POST" | "DELETE" | "PATCH" | "PUT";
