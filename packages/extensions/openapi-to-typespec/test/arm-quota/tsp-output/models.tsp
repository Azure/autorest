import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Quota;

/**
 * Request status.
 */
union RequestState {
  string,

  /**
   * Accepted
   */
  Accepted: "Accepted",

  /**
   * Created
   */
  Created: "Created",

  /**
   * Invalid
   */
  Invalid: "Invalid",

  /**
   * Succeeded
   */
  Succeeded: "Succeeded",

  /**
   * Failed
   */
  Failed: "Failed",

  /**
   * InProgress
   */
  InProgress: "InProgress",

  /**
   * Canceled
   */
  Canceled: "Canceled",
}

/**
 * The type of identity that created the resource.
 */
union CreatedByType {
  string,

  /**
   * User
   */
  User: "User",

  /**
   * Application
   */
  Application: "Application",

  /**
   * ManagedIdentity
   */
  ManagedIdentity: "ManagedIdentity",

  /**
   * Key
   */
  Key: "Key",
}

/**
 * The quota or usages limit types.
 */
union UsagesTypes {
  string,

  /**
   * Individual
   */
  Individual: "Individual",

  /**
   * Combined
   */
  Combined: "Combined",
}

/**
 * The limit object type.
 */
union LimitType {
  string,

  /**
   * LimitValue
   */
  LimitValue: "LimitValue",
}

/**
 * Quota request status.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
union QuotaRequestState {
  string,

  /**
   * Accepted
   */
  Accepted: "Accepted",

  /**
   * Invalid
   */
  Invalid: "Invalid",

  /**
   * Succeeded
   */
  Succeeded: "Succeeded",

  /**
   * Failed
   */
  Failed: "Failed",

  /**
   * InProgress
   */
  InProgress: "InProgress",
}

/**
 * The quota or usages limit types.
 */
union QuotaLimitTypes {
  string,

  /**
   * Independent
   */
  Independent: "Independent",

  /**
   * Shared
   */
  Shared: "Shared",
}

/**
 * Properties
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model GroupQuotasEntityProperties extends GroupQuotasEntityBase {}

/**
 * Properties and filters for ShareQuota. The request parameter is optional, if there are no filters specified.
 */
model GroupQuotasEntityBase {
  /**
   * Display name of the GroupQuota entity.
   */
  displayName?: string;

  /**
   * Provisioning state of the operation.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;
}

/**
 * The provisioning state for the operation.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model LROResponse extends Azure.ResourceManager.CommonTypes.ProxyResource {
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  properties?: LROResponseProperties;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model LROResponseProperties {
  /**
   * Request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;
}

/**
 * Properties and filters for ShareQuota. The request parameter is optional, if there are no filters specified.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model GroupQuotasEntityPatch
  extends Azure.ResourceManager.CommonTypes.ProxyResource {
  /**
   * Properties
   */
  properties?: GroupQuotasEntityPatchProperties;
}

/**
 * Properties
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model GroupQuotasEntityPatchProperties extends GroupQuotasEntityBasePatch {}

/**
 * Properties and filters for ShareQuota. The request parameter is optional, if there are no filters specified.
 */
model GroupQuotasEntityBasePatch {
  /**
   * Display name of the GroupQuota entity.
   */
  displayName?: string;

  /**
   * Provisioning state of the operation.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;
}

/**
 * List of Group Quotas at MG level.
 */
model GroupQuotaList is Azure.Core.Page<GroupQuotasEntity>;

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model GroupQuotaSubscriptionIdProperties {
  /**
   * An Azure subscriptionId.
   */
  subscriptionId?: string;

  /**
   * Status of this subscriptionId being associated with the GroupQuotasEntity.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;
}

/**
 * List of GroupQuotaSubscriptionIds
 */
model GroupQuotaSubscriptionIdList is Azure.Core.Page<GroupQuotaSubscriptionId>;

/**
 * List of GroupQuotaSubscriptionRequests Status
 */
model GroupQuotaSubscriptionRequestStatusList
  is Azure.Core.Page<GroupQuotaSubscriptionRequestStatus>;

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model GroupQuotaSubscriptionRequestStatusProperties {
  /**
   * The subscription Id
   */
  subscriptionId?: string;

  /**
   * The request submission time. The date conforms to the following format specified by the ISO 8601 standard: yyyy-MM-ddTHH:mm:ssZ
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  requestSubmitTime?: utcDateTime;

  /**
   * Status of this subscriptionId being associated with the GroupQuotasEntity.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model GroupQuotaLimitListProperties is Azure.Core.Page<GroupQuotaLimit> {
  /**
   * Request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;
}

/**
 * Group Quota limit.
 */
model GroupQuotaLimit {
  /**
   * Group Quota properties for the specified resource.
   */
  properties?: GroupQuotaLimitProperties;
}

/**
 * Group Quota properties for the specified resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model GroupQuotaLimitProperties extends GroupQuotaDetails {}

/**
 * Group Quota details.
 */
model GroupQuotaDetails {
  /**
   * The resource name, such as SKU name.
   */
  resourceName?: string;

  /**
   * The current Group Quota Limit at the parentId level.
   */
  limit?: int64;

  /**
   * Any comment related to quota request.
   */
  comment?: string;

  /**
   *  The usages units, such as Count and Bytes. When requesting quota, use the **unit** value returned in the GET response in the request body of your PUT operation.
   */
  @visibility(Lifecycle.Read)
  unit?: string;

  /**
   * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
   */
  @visibility(Lifecycle.Read)
  name?: GroupQuotaDetailsName;

  /**
   * The available Group Quota Limit at the MG level. This Group quota can be allocated to subscription(s).
   */
  @visibility(Lifecycle.Read)
  availableLimit?: int64;

  /**
   * Quota allocated to subscriptions
   */
  @visibility(Lifecycle.Read)
  allocatedToSubscriptions?: AllocatedQuotaToSubscriptionList;
}

/**
 * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
 */
model GroupQuotaDetailsName {
  /**
   * Resource name.
   */
  @visibility(Lifecycle.Read)
  value?: string;

  /**
   * Resource display name.
   */
  @visibility(Lifecycle.Read)
  localizedValue?: string;
}

/**
 * Quota allocated to subscriptions
 */
model AllocatedQuotaToSubscriptionList {
  /**
   * List of Group Quota Limit allocated to subscriptions.
   */
  value?: AllocatedToSubscription[];
}

/**
 * SubscriptionIds and quota allocated to subscriptions from the GroupQuota.
 */
model AllocatedToSubscription {
  /**
   * An Azure subscriptionId.
   */
  subscriptionId?: string;

  /**
   * The amount of quota allocated to this subscriptionId from the GroupQuotasEntity.
   */
  quotaAllocated?: int64;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model SubmittedResourceRequestStatusProperties {
  /**
   * Requested Resource.
   */
  requestedResource?: GroupQuotaRequestBase;

  /**
   * The request submission time. The date conforms to the following format specified by the ISO 8601 standard: yyyy-MM-ddTHH:mm:ssZ
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  requestSubmitTime?: utcDateTime;

  /**
   * Request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;

  /**
   * Details of the failure.
   */
  @visibility(Lifecycle.Read)
  faultCode?: string;
}

/**
 * The new GroupQuota limit requested.
 */
model GroupQuotaRequestBase {
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  properties?: GroupQuotaRequestBaseProperties;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model GroupQuotaRequestBaseProperties {
  /**
   * The new quota limit for the subscription. The incremental quota will be allocated from pre-approved group quota.
   */
  limit?: int64;

  /**
   * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
   */
  @visibility(Lifecycle.Read)
  name?: GroupQuotaRequestBasePropertiesName;

  /**
   * Location/Azure region for the quota requested for resource.
   */
  region?: string;

  /**
   * GroupQuota Request comments and details for request. This is optional paramter to provide more details related to the requested resource.
   */
  comments?: string;
}

/**
 * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
 */
model GroupQuotaRequestBasePropertiesName {
  /**
   * Resource name.
   */
  @visibility(Lifecycle.Read)
  value?: string;

  /**
   * Resource display name.
   */
  @visibility(Lifecycle.Read)
  localizedValue?: string;
}

/**
 * Share Quota Entity list.
 */
model SubmittedResourceRequestStatusList
  is Azure.Core.Page<SubmittedResourceRequestStatus>;

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model SubscriptionQuotaAllocationsListProperties
  is Azure.Core.Page<SubscriptionQuotaAllocations> {
  /**
   * Request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;
}

/**
 * Quota allocated to a subscription for the specific Resource Provider, Location, ResourceName. This will include the GroupQuota and total quota allocated to the subscription. Only the Group quota allocated to the subscription can be allocated back to the MG Group Quota.
 */
model SubscriptionQuotaAllocations {
  /**
   * Quota properties for the specified resource.
   */
  properties?: SubscriptionQuotaAllocationsProperties;
}

/**
 * Quota properties for the specified resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model SubscriptionQuotaAllocationsProperties extends SubscriptionQuotaDetails {}

/**
 * Subscription Quota details.
 */
model SubscriptionQuotaDetails {
  /**
   * The resource name, such as SKU name.
   */
  resourceName?: string;

  /**
   * The total quota limit for the subscription.
   */
  limit?: int64;

  /**
   * The shareable quota for the subscription.
   */
  @visibility(Lifecycle.Read)
  shareableQuota?: int64;

  /**
   * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
   */
  @visibility(Lifecycle.Read)
  name?: SubscriptionQuotaDetailsName;
}

/**
 * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
 */
model SubscriptionQuotaDetailsName {
  /**
   * Resource name.
   */
  @visibility(Lifecycle.Read)
  value?: string;

  /**
   * Resource display name.
   */
  @visibility(Lifecycle.Read)
  localizedValue?: string;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model QuotaAllocationRequestStatusProperties {
  /**
   * The new quota request allocated to subscription.
   */
  requestedResource?: QuotaAllocationRequestBase;

  /**
   * The request submission time. The date conforms to the following format specified by the ISO 8601 standard: yyyy-MM-ddTHH:mm:ssZ
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  requestSubmitTime?: utcDateTime;

  /**
   * Request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: RequestState;

  /**
   * Details of the failure.
   */
  @visibility(Lifecycle.Read)
  faultCode?: string;
}

/**
 * The new quota request allocated to subscription.
 */
model QuotaAllocationRequestBase {
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  properties?: QuotaAllocationRequestBaseProperties;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model QuotaAllocationRequestBaseProperties {
  /**
   * The new quota limit for the subscription. The incremental quota will be allocated from pre-approved group quota.
   */
  limit?: int64;

  /**
   * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
   */
  @visibility(Lifecycle.Read)
  name?: QuotaAllocationRequestBasePropertiesName;

  /**
   * The location for which the subscription is allocated
   */
  region?: string;
}

/**
 * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
 */
model QuotaAllocationRequestBasePropertiesName {
  /**
   * Resource name.
   */
  @visibility(Lifecycle.Read)
  value?: string;

  /**
   * Resource display name.
   */
  @visibility(Lifecycle.Read)
  localizedValue?: string;
}

/**
 * List of QuotaAllocation Request Status
 */
model QuotaAllocationRequestStatusList
  is Azure.Core.Page<QuotaAllocationRequestStatus>;

/**
 * Usage properties for the specified resource.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model UsagesProperties {
  /**
   * The quota limit properties for this resource.
   */
  usages?: UsagesObject;

  /**
   *  The units for the quota usage, such as Count and Bytes. When requesting quota, use the **unit** value returned in the GET response in the request body of your PUT operation.
   */
  @visibility(Lifecycle.Read)
  unit?: string;

  /**
   * Resource name provided by the resource provider. Use this property name when requesting quota.
   */
  name?: ResourceName;

  /**
   * The name of the resource type. Optional field.
   */
  resourceType?: string;

  /**
   * The time period for the summary of the quota usage values. For example:
   * *P1D (per one day)
   * *PT1M (per one minute)
   * *PT1S (per one second).
   * This parameter is optional because it is not relevant for all resources such as compute.
   */
  @visibility(Lifecycle.Read)
  quotaPeriod?: string;

  /**
   * States if quota can be requested for this resource.
   */
  @visibility(Lifecycle.Read)
  isQuotaApplicable?: boolean;

  /**
   * Additional properties for the specific resource provider.
   */
  properties?: unknown;
}

/**
 * The resource usages value.
 */
model UsagesObject {
  /**
   * The usages value.
   */
  value: int32;

  /**
   * The quota or usages limit types.
   */
  usagesType?: UsagesTypes;
}

/**
 * Name of the resource provided by the resource Provider. When requesting quota, use this property name.
 */
model ResourceName {
  /**
   * Resource name.
   */
  value?: string;

  /**
   * Resource display name.
   */
  @visibility(Lifecycle.Read)
  localizedValue?: string;
}

/**
 * Error.
 */
@error
model ExceptionResponse {
  /**
   * API error details.
   */
  error?: ServiceError;
}

/**
 * API error details.
 */
model ServiceError {
  /**
   * Error code.
   */
  code?: string;

  /**
   * Error message.
   */
  message?: string;

  /**
   * List of error details.
   */
  @visibility(Lifecycle.Read)
  @identifiers(#["code"])
  details?: ServiceErrorDetail[];
}

/**
 * Error details.
 */
model ServiceErrorDetail {
  /**
   * Error code.
   */
  @visibility(Lifecycle.Read)
  code?: string;

  /**
   * Error message.
   */
  @visibility(Lifecycle.Read)
  message?: string;
}

/**
 * Quota limits.
 */
model UsagesLimits is Azure.Core.Page<CurrentUsagesBase>;

/**
 * Quota properties for the specified resource.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model QuotaProperties {
  /**
   * Resource quota limit properties.
   */
  limit?: LimitJsonObject;

  /**
   *  The quota units, such as Count and Bytes. When requesting quota, use the **unit** value returned in the GET response in the request body of your PUT operation.
   */
  @visibility(Lifecycle.Read)
  unit?: string;

  /**
   * Resource name provided by the resource provider. Use this property name when requesting quota.
   */
  name?: ResourceName;

  /**
   * The name of the resource type. Optional field.
   */
  resourceType?: string;

  /**
   * The time period over which the quota usage values are summarized. For example:
   * *P1D (per one day)
   * *PT1M (per one minute)
   * *PT1S (per one second).
   * This parameter is optional because, for some resources like compute, the period is irrelevant.
   */
  @visibility(Lifecycle.Read)
  quotaPeriod?: string;

  /**
   * States if quota can be requested for this resource.
   */
  @visibility(Lifecycle.Read)
  isQuotaApplicable?: boolean;

  /**
   * Additional properties for the specific resource provider.
   */
  properties?: unknown;
}

/**
 * LimitJson abstract class.
 */
@discriminator("limitObjectType")
model LimitJsonObject {
  /**
   * The limit object type.
   */
  limitObjectType: LimitType;
}

/**
 * Quota limits.
 */
model QuotaLimits is Azure.Core.Page<CurrentQuotaLimitBase>;

/**
 * Quota request properties.
 */
model QuotaRequestProperties {
  /**
   * The quota request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: QuotaRequestState;

  /**
   * User-friendly status message.
   */
  @visibility(Lifecycle.Read)
  message?: string;

  /**
   * Error details of the quota request.
   */
  error?: ServiceErrorDetail;

  /**
   * The quota request submission time. The date conforms to the following format specified by the ISO 8601 standard: yyyy-MM-ddTHH:mm:ssZ
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  requestSubmitTime?: utcDateTime;

  /**
   * Quota request details.
   */
  @identifiers(#["subRequestId"])
  value?: SubRequest[];
}

/**
 * Request property.
 */
model SubRequest {
  /**
   * Resource name.
   */
  name?: ResourceName;

  /**
   * Resource type for which the quota properties were requested.
   */
  @visibility(Lifecycle.Read)
  resourceType?: string;

  /**
   *  Quota limit units, such as Count and Bytes. When requesting quota, use the **unit** value returned in the GET response in the request body of your PUT operation.
   */
  unit?: string;

  /**
   * The quota request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: QuotaRequestState;

  /**
   * User-friendly status message.
   */
  @visibility(Lifecycle.Read)
  message?: string;

  /**
   * Quota request ID.
   */
  @visibility(Lifecycle.Read)
  subRequestId?: string;

  /**
   * Resource quota limit properties.
   */
  limit?: LimitJsonObject;
}

/**
 * Quota request information.
 */
model QuotaRequestDetailsList is Azure.Core.Page<QuotaRequestDetails>;

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model OperationResponse {
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  name?: string;
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  display?: OperationDisplay;
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  origin?: string;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model OperationDisplay {
  /**
   * Provider name.
   */
  provider?: string;

  /**
   * Resource name.
   */
  resource?: string;

  /**
   * Operation name.
   */
  operation?: string;

  /**
   * Operation description.
   */
  description?: string;
}

/**
 * List of Allocated Group Quota to the subscriptions.
 */
model SubscriptionQuotaAllocationRequestList
  is Azure.Core.Page<QuotaAllocationRequestStatus>;

/**
 * MGId the source of group quota.
 */
model SubscriptionGroupQuotaAssignment {
  /**
   * The group quota id of the quota source.
   */
  groupQuotaId?: string;

  /**
   * The amount of quota allocated to this subscriptionId from the quota source.
   */
  quotaAllocated?: int64;
}

/**
 * Subscription quota allocation requests status list.
 */
model SubscriptionQuotaAllocationsStatusList
  is Azure.Core.Page<SubmittedResourceRequestStatus>;

/**
 * Resource definition with the requested quota.
 */
model ResourceBaseRequest {
  /**
   * The resource name, such as SKU name.
   */
  @visibility(Lifecycle.Read)
  resourceName?: string;

  /**
   * Quota requested for the resource.
   */
  limit?: int64;

  /**
   * Representing the units of the usage quota. Possible values are: Count, Bytes, Seconds, Percent, CountPerSecond, BytesPerSecond. Based on - https://armwiki.azurewebsites.net/api_contracts/UsagesAPIContract.html?q=usages . Different RPs may have different units, Count, type as int64 should work for most of the integer values.
   */
  @visibility(Lifecycle.Read)
  unit?: string;
}

/**
 * List of resource usages and quotas for GroupQuota.
 */
model ResourceUsageList is Azure.Core.Page<ResourceUsages>;

/**
 * Resource details with usages and GroupQuota.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model ResourceUsages extends Azure.ResourceManager.CommonTypes.ProxyResource {
  /**
   * Resource details with usages and GroupQuota.
   */
  properties?: GroupQuotaUsagesBase;
}

/**
 * Resource details with usages and GroupQuota.
 */
model GroupQuotaUsagesBase {
  /**
   * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
   */
  name?: GroupQuotaUsagesBaseName;

  /**
   * Quota/limits for the resource.
   */
  limit?: int64;

  /**
   * Usages for the resource.
   */
  usages?: int64;

  /**
   * Representing the units of the usage quota. Possible values are: Count, Bytes, Seconds, Percent, CountPerSecond, BytesPerSecond. Based on - https://armwiki.azurewebsites.net/api_contracts/UsagesAPIContract.html?q=usages . Different RPs may have different units, Count, type as int64 should work for most of the integer values.
   */
  @visibility(Lifecycle.Read)
  unit?: string;
}

/**
 * Name of the resource provided by the resource provider. This property is already included in the request URI, so it is a readonly property returned in the response.
 */
model GroupQuotaUsagesBaseName {
  /**
   * Resource name.
   */
  value?: string;

  /**
   * Resource display name.
   */
  @visibility(Lifecycle.Read)
  localizedValue?: string;
}

/**
 * Resource properties.
 */
model CommonResourceProperties {
  /**
   * Resource ID
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * Resource name.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Resource type. Example: "Microsoft.Quota/quotas"
   */
  @visibility(Lifecycle.Read)
  type?: string;
}

/**
 * Quota limits request response.
 */
model QuotaLimitsResponse is Azure.Core.Page<CurrentQuotaLimitBase>;

/**
 * Quota change requests information.
 */
model CreateGenericQuotaRequestParameters {
  /**
   * Quota change requests.
   */
  value?: CurrentQuotaLimitBase[];
}

/**
 * The resource quota limit value.
 */
model LimitObject extends LimitJsonObject {
  /**
   * The quota/limit value
   */
  value: int32;

  /**
   * The quota or usages limit types.
   */
  limitType?: QuotaLimitTypes;

  /**
   * The limit object type.
   */
  limitObjectType: "LimitValue";
}

/**
 * Quota request response.
 */
model QuotaRequestOneResourceSubmitResponse {
  /**
   * Quota request ID.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * The name of the quota request.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Resource type. "Microsoft.Quota/ServiceLimitRequests"
   */
  @visibility(Lifecycle.Read)
  type?: string;

  /**
   * Quota request details.
   */
  properties?: QuotaRequestOneResourceProperties;
}

/**
 * Quota request.
 */
model QuotaRequestOneResourceProperties {
  /**
   * Quota request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: QuotaRequestState;

  /**
   * User-friendly status message.
   */
  @visibility(Lifecycle.Read)
  message?: string;

  /**
   * Quota request submission time. The date conforms to the following ISO 8601 standard format: yyyy-MM-ddTHH:mm:ssZ.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  requestSubmitTime?: utcDateTime;

  /**
   * Resource quota limit properties.
   */
  limit?: LimitObject;

  /**
   * Usage information for the current resource.
   */
  @visibility(Lifecycle.Read)
  currentValue?: int32;

  /**
   *  The quota limit units, such as Count and Bytes. When requesting quota, use the **unit** value returned in the GET response in the request body of your PUT operation.
   */
  unit?: string;

  /**
   * Resource name provided by the resource provider. Use this property name when requesting quota.
   */
  name?: ResourceName;

  /**
   * The name of the resource type. Optional field.
   */
  resourceType?: string;

  /**
   * The time period over which the quota usage values are summarized. For example:
   * *P1D (per one day)
   * *PT1M (per one minute)
   * *PT1S (per one second).
   * This parameter is optional because, for some resources like compute, the period is irrelevant.
   */
  @visibility(Lifecycle.Read)
  quotaPeriod?: string;

  /**
   * States if quota can be requested for this resource.
   */
  @visibility(Lifecycle.Read)
  isQuotaApplicable?: boolean;

  /**
   * Error details of the quota request.
   */
  error?: ServiceErrorDetail;

  /**
   * Additional properties for the specific resource provider.
   */
  properties?: unknown;
}

/**
 * Quota request response.
 */
model QuotaRequestSubmitResponse {
  /**
   * Quota request ID.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * Quota request name.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Quota request details.
   */
  properties?: QuotaRequestProperties;

  /**
   * Resource type. "Microsoft.Quota/quotas".
   */
  @visibility(Lifecycle.Read)
  type?: string;
}

/**
 * The quota request response with the quota request ID.
 */
model QuotaRequestSubmitResponse202 {
  /**
   * The quota request ID. To check the request status, use the **id** value in a [Quota Request Status](https://docs.microsoft.com/en-us/rest/api/reserved-vm-instances/quotarequeststatus/get) GET operation.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * Operation ID.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Resource type.
   */
  @visibility(Lifecycle.Read)
  type?: string;

  /**
   * Quota request status.
   */
  properties?: QuotaRequestStatusDetails;
}

/**
 * Quota request status details.
 */
model QuotaRequestStatusDetails {
  /**
   * Quota request status.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: QuotaRequestState;

  /**
   * User-friendly message.
   */
  @visibility(Lifecycle.Read)
  message?: string;

  /**
   * Resource quota limit properties.
   */
  limit?: LimitObject;

  /**
   *  The quota limit units, such as Count and Bytes. When requesting quota, use the **unit** value returned in the GET response in the request body of your PUT operation.
   */
  unit?: string;

  /**
   * Resource name provided by the resource provider. Use this property name when requesting quota.
   */
  name?: ResourceName;

  /**
   * The name of the resource type. Optional field.
   */
  resourceType?: string;

  /**
   * The time period over which the quota usage values are summarized. For example:
   * *P1D (per one day)
   * *PT1M (per one minute)
   * *PT1S (per one second).
   * This parameter is optional because, for some resources like compute, the period is irrelevant.
   */
  @visibility(Lifecycle.Read)
  quotaPeriod?: string;

  /**
   * Additional properties for the specific resource provider.
   */
  properties?: unknown;
}
