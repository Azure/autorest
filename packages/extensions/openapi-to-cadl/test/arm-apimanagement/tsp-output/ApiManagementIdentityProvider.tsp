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
@doc("Identity Provider details.")
@parentResource(ApiManagementService)
model ApiManagementIdentityProvider
  is ProxyResource<IdentityProviderContractProperties> {
  @doc("Identity Provider Type identifier.")
  @path
  @key("identityProviderName")
  @segment("identityProviders")
  name: IdentityProviderType;
}

@armResourceOperations
interface ApiManagementIdentityProviders {
  @doc("Gets the configuration details of the identity Provider configured in specified service instance.")
  get is ArmResourceRead<ApiManagementIdentityProvider>;
  @doc("Gets the entity state (Etag) version of the identityProvider specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementIdentityProvider,
      BaseParameters<ApiManagementIdentityProvider>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or Updates the IdentityProvider configuration.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementIdentityProvider,
    {
      ...BaseParameters<ApiManagementIdentityProvider>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates an existing IdentityProvider configuration.")
  update is ArmResourcePatchSync<
    ApiManagementIdentityProvider,
    IdentityProviderContractProperties,
    {
      ...BaseParameters<ApiManagementIdentityProvider>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes the specified identity provider configuration.")
  delete is ArmResourceDeleteSync<
    ApiManagementIdentityProvider,
    {
      ...BaseParameters<ApiManagementIdentityProvider>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of Identity Provider configured in the specified service instance.")
  listByService is ArmResourceListByParent<ApiManagementIdentityProvider>;
  @doc("Gets the client secret details of the Identity Provider.")
  listSecrets is ArmResourceActionSync<
    ApiManagementIdentityProvider,
    void,
    ClientSecretContract
  >;
}
