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
 * List of Group Quota Limit details.
 */
@parentResource(GroupQuotasEntity)
model GroupQuotaLimitList
  is Azure.ResourceManager.ProxyResource<GroupQuotaLimitListProperties> {
  ...ResourceNameParameter<
    Resource = GroupQuotaLimitList,
    KeyName = "location",
    SegmentName = "groupQuotaLimits",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GroupQuotaLimitLists {
  /**
   * Gets the GroupQuotaLimits for the specified resource provider and location for resource names passed in $filter=resourceName eq {SKU}.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GroupQuotaLimits_List")
  list is Extension.Read<Extension.ManagementGroup, GroupQuotaLimitList>;

  /**
   * Create the GroupQuota requests for a specific ResourceProvider/Location/Resource. The resourceName properties are specified in the request body. Only 1 resource quota can be requested. Please note that patch request creates a new groupQuota request.
   * Use the polling API - OperationsStatus URI specified in Azure-AsyncOperation header field, with retry-after duration in seconds to check the intermediate status. This API provides the finals status with the request details and status.
   */
  @patch(#{ implicitOptionality: false })
  update is Extension.CustomPatchAsync<
    Extension.ManagementGroup,
    GroupQuotaLimitList,
    PatchModel = GroupQuotaLimitList,
    OptionalRequestBody = true
  >;
}

@@minLength(GroupQuotaLimitList.name, 1);
@@doc(GroupQuotaLimitList.name, "The name of the Azure region.");
@@doc(GroupQuotaLimitList.properties, "");
@@doc(GroupQuotaLimitLists.update::parameters.properties,
  "The GroupQuotaRequest body details for specific resourceProvider/location/resources."
);
