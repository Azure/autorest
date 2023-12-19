import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Tenant Settings.")
@parentResource(ApiManagementService)
model TenantAccessInfo is ProxyResource<AccessInformationContractProperties> {
  @doc("The identifier of the Access configuration.")
  @path
  @key("accessName")
  @segment("tenant")
  name: AccessIdName;
}

@armResourceOperations
interface TenantAccessInfos {
  @doc("Get tenant access information details without secrets.")
  get is ArmResourceRead<TenantAccessInfo>;
  @doc("Tenant access metadata")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      TenantAccessInfo,
      BaseParameters<TenantAccessInfo>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Update tenant access information details.")
  create is ArmResourceCreateOrReplaceSync<
    TenantAccessInfo,
    {
      ...BaseParameters<TenantAccessInfo>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Update tenant access information details.")
  update is ArmResourcePatchSync<
    TenantAccessInfo,
    AccessInformationContractProperties,
    {
      ...BaseParameters<TenantAccessInfo>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Returns list of access infos - for Git and Management endpoints.")
  listByService is ArmResourceListByParent<
    TenantAccessInfo,
    {
      ...BaseParameters<TenantAccessInfo>;

      @doc("Not used")
      @query("$filter")
      $filter?: string;
    }
  >;
  @doc("Regenerate primary access key")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    TenantAccessInfo,
    void
  >;
  @doc("Regenerate secondary access key")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    TenantAccessInfo,
    void
  >;
  @doc("Get tenant access information details.")
  listSecrets is ArmResourceActionSync<
    TenantAccessInfo,
    void,
    AccessInformationSecretsContract
  >;
  @doc("Regenerate primary access key for GIT.")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    TenantAccessInfo,
    void
  >;
  @doc("Regenerate secondary access key for GIT.")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    TenantAccessInfo,
    void
  >;
}
