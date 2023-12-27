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
@doc("Identity Provider details.")
@parentResource(ApiManagementServiceResource)
model IdentityProviderContract
  is ProxyResource<IdentityProviderContractProperties> {
  @doc("Identity Provider Type identifier.")
  @key("identityProviderName")
  @segment("identityProviders")
  name: IdentityProviderType;
}

@armResourceOperations
interface IdentityProvider {
  @doc("Gets the configuration details of the identity Provider configured in specified service instance.")
  get is ArmResourceRead<IdentityProviderContract>;
  @doc("Gets the entity state (Etag) version of the identityProvider specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      IdentityProviderContract,
      BaseParameters<IdentityProviderContract>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or Updates the IdentityProvider configuration.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IdentityProviderContract,
    {
      ...BaseParameters<IdentityProviderContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates an existing IdentityProvider configuration.")
  update is ArmCustomPatchSync<
    IdentityProviderContract,
    IdentityProviderUpdateParameters,
    {
      ...BaseParameters<IdentityProviderContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes the specified identity provider configuration.")
  delete is ArmResourceDeleteSync<
    IdentityProviderContract,
    {
      ...BaseParameters<IdentityProviderContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of Identity Provider configured in the specified service instance.")
  listByService is ArmResourceListByParent<IdentityProviderContract>;
  @doc("Gets the client secret details of the Identity Provider.")
  listSecrets is ArmResourceActionSync<
    IdentityProviderContract,
    void,
    ClientSecretContract
  >;
}
