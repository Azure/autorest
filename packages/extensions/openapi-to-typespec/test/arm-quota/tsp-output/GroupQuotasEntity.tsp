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
 * Properties and filters for ShareQuota. The request parameter is optional, if there are no filters specified.
 */
model GroupQuotasEntity
  is Azure.ResourceManager.ProxyResource<GroupQuotasEntityProperties> {
  ...ResourceNameParameter<
    Resource = GroupQuotasEntity,
    KeyName = "groupQuotaName",
    SegmentName = "groupQuotas",
    NamePattern = "^[a-z][a-z0-9]*$"
  >;
}

@armResourceOperations
interface GroupQuotasEntities {
  /**
   * Gets the GroupQuotas for the name passed. It will return the GroupQuotas properties only. The details on group quota can be access from the group quota APIs.
   */
  get is Extension.Read<Extension.ManagementGroup, GroupQuotasEntity>;

  /**
   * Creates a new GroupQuota for the name passed. A RequestId will be returned by the Service. The status can be polled periodically. The status Async polling is using standards defined at - https://github.com/Azure/azure-resource-manager-rpc/blob/master/v1.0/async-api-reference.md#asynchronous-operations. Use the OperationsStatus URI provided in Azure-AsyncOperation header, the duration will be specified in retry-after header. Once the operation gets to terminal state - Succeeded | Failed, then the URI will change to Get URI and full details can be checked.
   */
  createOrUpdate is Extension.CreateOrReplaceAsync<
    Extension.ManagementGroup,
    GroupQuotasEntity,
    Response = ArmResourceUpdatedResponse<GroupQuotasEntity> | ArmResourceCreatedResponse<
      LROResponse,
      ArmLroLocationHeader<FinalResult = GroupQuotasEntity> &
        Azure.Core.Foundations.RetryAfterHeader
    >
  >;

  /**
   * Updates the GroupQuotas for the name passed. A GroupQuotas RequestId will be returned by the Service. The status can be polled periodically. The status Async polling is using standards defined at - https://github.com/Azure/azure-resource-manager-rpc/blob/master/v1.0/async-api-reference.md#asynchronous-operations. Use the OperationsStatus URI provided in Azure-AsyncOperation header, the duration will be specified in retry-after header. Once the operation gets to terminal state - Succeeded | Failed, then the URI will change to Get URI and full details can be checked.
   *  Any change in the filters will be applicable to the future quota assignments, existing quota allocated to subscriptions from the GroupQuotas remains unchanged.
   */
  @patch(#{ implicitOptionality: false })
  update is Extension.CustomPatchAsync<
    Extension.ManagementGroup,
    GroupQuotasEntity,
    PatchModel = GroupQuotasEntityPatch,
    OptionalRequestBody = true
  >;

  /**
   * Deletes the GroupQuotas for the name passed. All the remaining shareQuota in the GroupQuotas will be lost.
   */
  delete is Extension.DeleteWithoutOkAsync<
    Extension.ManagementGroup,
    GroupQuotasEntity
  >;

  /**
   * Lists GroupQuotas for the scope passed. It will return the GroupQuotas QuotaEntity properties only.The details on group quota can be access from the group quota APIs.
   */
  list is Extension.ListByTarget<
    Extension.ManagementGroup,
    GroupQuotasEntity,
    Response = ArmResponse<GroupQuotaList>
  >;

  /**
   * Get API to check the status of a GroupQuota request by requestId.
   */
  @get
  @action("groupQuotaRequests")
  groupQuotaLimitsRequestList is Extension.ActionSync<
    Extension.ManagementGroup,
    GroupQuotasEntity,
    void,
    ArmResponse<SubmittedResourceRequestStatusList>,
    Parameters = {
      /**
       * The resource provider name, such as - Microsoft.Compute. Currently only Microsoft.Compute resource provider supports this API.
       */
      @pattern("^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\\.)+[a-zA-Z]{2,63}$")
      @path
      resourceProviderName: string;

      /**
       * | Field | Supported operators
       * |---------------------|------------------------
       *
       *  location eq {location} and resource eq {resourceName}
       *  Example: $filter=location eq eastus and resourceName eq cores
       */
      @minLength(12)
      @query("$filter")
      $filter: string;
    }
  >;
}

@@maxLength(GroupQuotasEntity.name, 63);
@@minLength(GroupQuotasEntity.name, 3);
@@doc(GroupQuotasEntity.name,
  "The GroupQuota name. The name should be unique for the provided context tenantId/MgId."
);
@@doc(GroupQuotasEntity.properties, "Properties");
@@doc(GroupQuotasEntities.createOrUpdate::parameters.resource,
  "The GroupQuota body details for creation or update of a GroupQuota entity."
);
@@doc(GroupQuotasEntities.update::parameters.properties,
  "The  GroupQuotas Patch Request."
);
