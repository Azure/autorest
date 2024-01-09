import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Tenant Settings.")
@parentResource(ApiManagementServiceResource)
model AccessInformationContract
  is ProxyResource<AccessInformationContractProperties> {
  @doc("The identifier of the Access configuration.")
  @key("accessName")
  @segment("tenant")
  name: AccessIdName;
}

@armResourceOperations
@projectedName("client", "TenantAccess")
interface AccessInformationContracts_TenantAccess {
  @doc("Get tenant access information details without secrets.")
  get is ArmResourceRead<AccessInformationContract>;

  @doc("Tenant access metadata")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      AccessInformationContract,
      BaseParameters<AccessInformationContract>
    >,
  ): OkResponse | ErrorResponse;

  @doc("Update tenant access information details.")
  create is ArmResourceCreateOrReplaceSync<
    AccessInformationContract,
    {
      ...BaseParameters<AccessInformationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Update tenant access information details.")
  update is ArmCustomPatchSync<
    AccessInformationContract,
    AccessInformationUpdateParameters,
    {
      ...BaseParameters<AccessInformationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Returns list of access infos - for Git and Management endpoints.")
  listByService is ArmResourceListByParent<
    AccessInformationContract,
    {
      ...BaseParameters<AccessInformationContract>;

      @doc("Not used")
      @query("$filter")
      $filter?: string;
    }
  >;

  @doc("Regenerate primary access key")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  @doc("Regenerate secondary access key")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  @doc("Get tenant access information details.")
  listSecrets is ArmResourceActionSync<
    AccessInformationContract,
    void,
    AccessInformationSecretsContract
  >;
}

@armResourceOperations
@projectedName("client", "TenantAccessGit")
interface AccessInformationContracts_TenantAccessGit {
  @doc("Regenerate primary access key for GIT.")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  @doc("Regenerate secondary access key for GIT.")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;
}
