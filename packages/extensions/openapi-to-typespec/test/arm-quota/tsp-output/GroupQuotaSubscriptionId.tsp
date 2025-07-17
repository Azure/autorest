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
/**
 * This represents a Azure subscriptionId that is associated with a GroupQuotasEntity.
 */
@parentResource(GroupQuotasEntity)
model GroupQuotaSubscriptionId
  is Azure.ResourceManager.ProxyResource<GroupQuotaSubscriptionIdProperties> {
  ...ResourceNameParameter<
    Resource = GroupQuotaSubscriptionId,
    KeyName = "subscriptionId",
    SegmentName = "subscriptions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GroupQuotaSubscriptionIds {
  /**
   * Returns the subscriptionIds along with its provisioning state for being associated with the GroupQuota. If the subscription is not a member of GroupQuota, it will return 404, else 200.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaSubscriptions_Get")
  get is Extension.Read<Extension.ManagementGroup, GroupQuotaSubscriptionId>;

  // FIXME: (ArmResourceCreateOrReplace): ArmResourceCreateOrReplaceAsync/ArmResourceCreateOrReplaceSync should have a body parameter.
  /**
   * Adds a subscription to GroupQuotas. The subscriptions will be validated based on the additionalAttributes defined in the GroupQuota. The additionalAttributes works as filter for the subscriptions, which can be included in the GroupQuotas. The request's TenantId is validated against the subscription's TenantId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaSubscriptions_CreateOrUpdate")
  createOrUpdate is Extension.CreateOrReplaceAsync<
    Extension.ManagementGroup,
    GroupQuotaSubscriptionId,
    Response = ArmResourceUpdatedResponse<GroupQuotaSubscriptionId> | ArmResourceCreatedResponse<
      LROResponse,
      ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
    >
  >;

  // FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property
  /**
   * Updates the GroupQuotas with the subscription to add to the subscriptions list. The subscriptions will be validated if additionalAttributes are defined in the GroupQuota. The request's TenantId is validated against the subscription's TenantId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @patch(#{ implicitOptionality: false })
  @operationId("GroupQuotaSubscriptions_Update")
  update is Extension.CustomPatchAsync<
    Extension.ManagementGroup,
    GroupQuotaSubscriptionId,
    PatchModel = {}
  >;

  /**
   * Removes the subscription from GroupQuotas. The request's TenantId is validated against the subscription's TenantId.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaSubscriptions_Delete")
  delete is Extension.DeleteWithoutOkAsync<
    Extension.ManagementGroup,
    GroupQuotaSubscriptionId
  >;

  /**
   * Returns a list of the subscriptionIds associated with the GroupQuotas.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaSubscriptions_List")
  list is Extension.ListByTarget<
    Extension.ManagementGroup,
    GroupQuotaSubscriptionId,
    Response = ArmResponse<GroupQuotaSubscriptionIdList>
  >;
}

#suppress "@azure-tools/typespec-azure-core/no-format"
@@format(GroupQuotaSubscriptionId.name, "uuid");
@@doc(GroupQuotaSubscriptionId.name,
  "The ID of the target subscription. The value must be an UUID."
);
@@doc(GroupQuotaSubscriptionId.properties, "");
