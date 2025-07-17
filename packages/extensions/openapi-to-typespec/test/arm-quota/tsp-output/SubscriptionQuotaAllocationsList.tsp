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
 * Subscription quota list.
 */
model SubscriptionQuotaAllocationsList
  is Azure.ResourceManager.ProxyResource<SubscriptionQuotaAllocationsListProperties> {
  ...ResourceNameParameter<
    Resource = SubscriptionQuotaAllocationsList,
    KeyName = "location",
    SegmentName = "quotaAllocations",
    NamePattern = ""
  >;
}

@armResourceOperations
interface SubscriptionQuotaAllocationsLists {
  /**
   * Gets all the quota allocated to a subscription for the specified resource provider and location for resource names passed in $filter=resourceName eq {SKU}. This will include the GroupQuota and total quota allocated to the subscription. Only the Group quota allocated to the subscription can be allocated back to the MG Group Quota.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaSubscriptionAllocation_List")
  list is Extension.Read<
    Extension.ManagementGroup,
    SubscriptionQuotaAllocationsList
  >;

  /**
   * Request to assign quota from group quota to a specific Subscription. The assign GroupQuota to subscriptions or reduce the quota allocated to subscription to give back the unused quota ( quota >= usages) to the groupQuota. So, this API can be used to assign Quota to subscriptions and assign back unused quota to group quota, which can be assigned to another subscriptions in the GroupQuota. User can collect unused quotas from multiple subscriptions within the groupQuota and assign the groupQuota to the subscription, where it's needed.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @patch(#{ implicitOptionality: false })
  @operationId("GroupQuotaSubscriptionAllocationRequest_Update")
  update is Extension.CustomPatchAsync<
    Extension.ManagementGroup,
    SubscriptionQuotaAllocationsList,
    PatchModel = SubscriptionQuotaAllocationsList
  >;
}

@@minLength(SubscriptionQuotaAllocationsList.name, 1);
@@doc(SubscriptionQuotaAllocationsList.name, "The name of the Azure region.");
@@doc(SubscriptionQuotaAllocationsList.properties, "");
@@doc(SubscriptionQuotaAllocationsLists.update::parameters.properties,
  "Quota requests payload."
);
