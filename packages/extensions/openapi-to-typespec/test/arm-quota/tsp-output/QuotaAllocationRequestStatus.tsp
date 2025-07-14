import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Quota;
/**
 * The subscription quota allocation status.
 */
model QuotaAllocationRequestStatus
  is Azure.ResourceManager.ProxyResource<QuotaAllocationRequestStatusProperties> {
  ...ResourceNameParameter<
    Resource = QuotaAllocationRequestStatus,
    KeyName = "allocationId",
    SegmentName = "quotaAllocationRequests",
    NamePattern = ""
  >;
}

@armResourceOperations
interface QuotaAllocationRequestStatuses {
  /**
   * Get the quota allocation request status for the subscriptionId by allocationId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaSubscriptionAllocationRequest_Get")
  get is Extension.Read<
    Extension.ManagementGroup,
    QuotaAllocationRequestStatus
  >;

  /**
   * Get all the quotaAllocationRequests for a resourceProvider/location. The filter paramter for location is required.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaSubscriptionAllocationRequest_List")
  list is Extension.ListByTarget<
    Extension.ManagementGroup,
    QuotaAllocationRequestStatus,
    Parameters = {
      /**
       * | Field | Supported operators
       * |---------------------|------------------------
       *
       *  location eq {location}
       *  Example: $filter=location eq eastus
       */
      @minLength(12)
      @query("$filter")
      $filter: string;
    },
    Response = ArmResponse<QuotaAllocationRequestStatusList>
  >;
}

@@doc(QuotaAllocationRequestStatus.name, "Request Id.");
@@doc(QuotaAllocationRequestStatus.properties, "");
