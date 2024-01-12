import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.IntegrationSpaces;

interface Operations extends Azure.ResourceManager.Operations {}

@doc("The status of the current operation.")
enum ProvisioningState {
  @doc("Resource has been created.") Succeeded,
  @doc("Resource creation failed.") Failed,
  @doc("Resource creation was canceled.") Canceled,
  Provisioning,
  Updating,
  Deleting,
  Accepted,
}

@doc("The properties of space.")
model SpaceResourceProperties {
  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("The description of the resource.")
  description?: string;
}

@doc("Common fields that are returned in the response for all Azure Resource Manager resources")
model Resource {
  @doc("Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}")
  @visibility("read")
  id?: string;

  @doc("The name of the resource")
  @visibility("read")
  name?: string;

  @doc("The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\"")
  @visibility("read")
  type?: string;

  @doc("Azure Resource Manager metadata containing createdBy and modifiedBy information.")
  @visibility("read")
  systemData?: SystemData;
}

@doc("The type used for update operations of the Space.")
model SpaceUpdate {
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("The updatable properties of the Space.")
  properties?: SpaceUpdateProperties;
}

@doc("The updatable properties of the Space.")
model SpaceUpdateProperties {
  @doc("The description of the resource.")
  description?: string;
}

@doc("The properties of application.")
model ApplicationProperties {
  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("The description of the resource.")
  description?: string;

  @doc("The tracking data stores.")
  trackingDataStores: Record<TrackingDataStore>;
}

@doc("The properties of tracking data store.")
model TrackingDataStore {
  @doc("The database name.")
  databaseName: string;

  @doc("The data store resource id.")
  dataStoreResourceId: string;

  @doc("The data store URI.")
  dataStoreUri: string;

  @doc("The data store ingestion URI.")
  dataStoreIngestionUri: string;
}

@doc("The type used for update operations of the Application.")
model ApplicationUpdate {
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("The updatable properties of the Application.")
  properties?: ApplicationUpdateProperties;
}

@doc("The updatable properties of the Application.")
model ApplicationUpdateProperties {
  @doc("The description of the resource.")
  description?: string;

  @doc("The tracking data stores.")
  trackingDataStores?: Record<TrackingDataStore>;
}

@doc("The properties of business process.")
model BusinessProcessProperties {
  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("The version of the business process.")
  @visibility("read")
  version?: string;

  @doc("The description of the business process.")
  description?: string;

  @doc("The table name of the business process.")
  tableName?: string;

  @doc("The tracking data store reference name.")
  trackingDataStoreReferenceName?: string;

  @doc("The business process identifier.")
  identifier?: BusinessProcessIdentifier;

  @doc("The business process stages.")
  businessProcessStages?: Record<BusinessProcessStage>;

  @doc("The business process mapping.")
  businessProcessMapping?: Record<BusinessProcessMappingItem>;
}

@doc("The properties of business process identifier.")
model BusinessProcessIdentifier {
  @doc("The property name of the business process identifier.")
  propertyName?: string;

  @doc("The property type of the business process identifier.")
  propertyType?: string;
}

@doc("The properties of business process stage.")
model BusinessProcessStage {
  @doc("The description of the business stage.")
  description?: string;

  @doc("The properties within the properties of the business process stage.")
  properties?: Record<string>;

  @doc("The property to keep track of stages before current in the business process stage.")
  stagesBefore?: string[];
}

@doc("The properties of business process mapping.")
model BusinessProcessMappingItem {
  @doc("The logic app resource id.")
  logicAppResourceId?: string;

  @doc("The workflow name within the logic app.")
  workflowName?: string;

  @doc("The operation name.")
  operationName?: string;

  @doc("The mapping item operation type of the business process.")
  operationType?: string;
}

@doc("The type used for update operations of the BusinessProcess.")
model BusinessProcessUpdate {
  @doc("The updatable properties of the BusinessProcess.")
  properties?: BusinessProcessUpdateProperties;
}

@doc("The updatable properties of the BusinessProcess.")
model BusinessProcessUpdateProperties {
  @doc("The description of the business process.")
  description?: string;

  @doc("The table name of the business process.")
  tableName?: string;

  @doc("The tracking data store reference name.")
  trackingDataStoreReferenceName?: string;

  @doc("The business process identifier.")
  identifier?: BusinessProcessIdentifier;

  @doc("The business process stages.")
  businessProcessStages?: Record<BusinessProcessStage>;

  @doc("The business process mapping.")
  businessProcessMapping?: Record<BusinessProcessMappingItem>;
}

@doc("The business process development artifact get or delete request.")
model GetOrDeleteBusinessProcessDevelopmentArtifactRequest {
  @doc("The name of the business process development artifact.")
  name: string;
}

@doc("The business process development artifact save or get response.")
model SaveOrGetBusinessProcessDevelopmentArtifactResponse {
  @doc("The name of the business process development artifact.")
  name: string;

  @doc("The system data of the business process development artifact.")
  systemData?: BusinessProcessDevelopmentArtifactSystemData;

  @doc("The properties of the business process development artifact.")
  properties?: BusinessProcessDevelopmentArtifactProperties;
}

@doc("The system data for business process development artifact.")
model BusinessProcessDevelopmentArtifactSystemData {
  @doc("The timestamp of last modification (UTC).")
  lastModifiedAt?: string;
}

@doc("The properties of business process development artifact.")
model BusinessProcessDevelopmentArtifactProperties {
  @doc("The description of the business process.")
  description?: string;

  @doc("The business process identifier.")
  identifier?: BusinessProcessIdentifier;

  @doc("The business process stages.")
  businessProcessStages?: Record<BusinessProcessStage>;

  @doc("The business process mapping.")
  businessProcessMapping?: Record<BusinessProcessMappingItem>;

  @doc("The tracking profile for the business process.")
  trackingProfiles?: Record<TrackingProfileDefinition>;
}

@doc("The tracking profile for the business process")
model TrackingProfileDefinition {
  @doc("The tracking definition schema uri.")
  @projectedName("json", "$schema")
  schema?: string;

  @doc("The business process reference.")
  businessProcess?: BusinessProcessReference;

  @doc("The tracking definitions.")
  trackingDefinitions?: Record<FlowTrackingDefinition>;
}

@doc("The business process reference.")
model BusinessProcessReference {
  @doc("The business process name.")
  name?: string;

  @doc("The business process version.")
  version?: string;
}

@doc("The workflow tracking definition.")
model FlowTrackingDefinition {
  @doc("The tracking correlation context.")
  correlationContext?: TrackingCorrelationContext;

  @doc("The tracking events.")
  events?: Record<TrackingEventDefinition>;
}

@doc("The tracking correlation context.")
model TrackingCorrelationContext {
  @doc("The operation type for correlation context.")
  operationType?: string;

  @doc("The operation name for correlation context.")
  operationName?: string;

  @doc("The name of the correlation property.")
  propertyName?: string;

  @doc("The template expression for correlation context property value.")
  value?: string;
}

@doc("The tracking event definition.")
model TrackingEventDefinition {
  @doc("The operation type.")
  operationType?: string;

  @doc("The operation name.")
  operationName?: string;

  @doc("The properties to be collected for event.")
  properties?: Record<Record<unknown>>;
}

@doc("The business process development artifact get collection response.")
model ListBusinessProcessDevelopmentArtifactsResponse {
  @doc("The list of the business process development artifact.")
  value: SaveOrGetBusinessProcessDevelopmentArtifactResponse[];
}

@doc("The response of a ApplicationResource list operation.")
model ApplicationResourceListResult is Azure.Core.Page<ApplicationResource>;

@doc("A resource under application.")
model ApplicationResource extends ProxyResource {
  @doc("The resource-specific properties for this resource.")
  @visibility("read", "create")
  properties?: ApplicationResourceProperties;
}

@doc("The properties of application resource.")
model ApplicationResourceProperties {
  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("The type of the application resource.")
  resourceType: string;

  @doc("The Arm id of the application resource.")
  resourceId: string;

  @doc("The kind of the application resource.")
  resourceKind?: string;
}

@doc("The type used for update operations of the ApplicationResource.")
model ApplicationResourceUpdate {
  @doc("The updatable properties of the ApplicationResource.")
  properties?: ApplicationResourceUpdateProperties;
}

@doc("The updatable properties of the ApplicationResource.")
model ApplicationResourceUpdateProperties {
  @doc("The type of the application resource.")
  resourceType?: string;

  @doc("The Arm id of the application resource.")
  resourceId?: string;

  @doc("The kind of the application resource.")
  resourceKind?: string;
}

@doc("The business process development artifact save or validate request.")
model SaveOrValidateBusinessProcessDevelopmentArtifactRequest {
  @doc("The name of the business process development artifact.")
  name: string;

  @doc("The properties of the business process development artifact.")
  properties?: BusinessProcessDevelopmentArtifactProperties;
}

@doc("The properties of infrastructure resource.")
model InfrastructureResourceProperties {
  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("The type of the infrastructure resource.")
  resourceType: string;

  @doc("The id of the infrastructure resource.")
  resourceId: string;
}

@doc("The type used for update operations of the InfrastructureResource.")
model InfrastructureResourceUpdate {
  @doc("The updatable properties of the InfrastructureResource.")
  properties?: InfrastructureResourceUpdateProperties;
}

@doc("The updatable properties of the InfrastructureResource.")
model InfrastructureResourceUpdateProperties {
  @doc("The type of the infrastructure resource.")
  resourceType?: string;

  @doc("The id of the infrastructure resource.")
  resourceId?: string;
}
