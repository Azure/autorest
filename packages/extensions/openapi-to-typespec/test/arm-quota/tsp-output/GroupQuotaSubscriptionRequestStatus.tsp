import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GroupQuotasEntity.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Quota;
/** The new quota limit request status. */
@parentResource(GroupQuotasEntity)
model GroupQuotaSubscriptionRequestStatus
  is Azure.ResourceManager.ProxyResource<GroupQuotaSubscriptionRequestStatusProperties> {
  ...ResourceNameParameter<
    Resource = GroupQuotaSubscriptionRequestStatus,
    KeyName = "requestId",
    SegmentName = "subscriptionRequests",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GroupQuotaSubscriptionRequestStatuses {
  /** Get API to check the status of a subscriptionIds request by requestId.  Use the polling API - OperationsStatus URI specified in Azure-AsyncOperation header field, with retry-after duration in seconds to check the intermediate status. This API provides the finals status with the request details and status. */
  get is Extension.Read<
    Extension.ManagementGroup,
    GroupQuotaSubscriptionRequestStatus
  >;

  /** List API to check the status of a subscriptionId requests by requestId. Request history is maintained for 1 year. */
  list is Extension.ListByTarget<
    Extension.ManagementGroup,
    GroupQuotaSubscriptionRequestStatus,
    Response = ArmResponse<GroupQuotaSubscriptionRequestStatusList>
  >;
}

@@doc(GroupQuotaSubscriptionRequestStatus.name, "Request Id.");
@@doc(GroupQuotaSubscriptionRequestStatus.properties, "");
