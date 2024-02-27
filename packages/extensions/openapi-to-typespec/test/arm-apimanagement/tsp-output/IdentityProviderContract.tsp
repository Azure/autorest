import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Identity Provider details.
 */
@parentResource(ApiManagementServiceResource)
model IdentityProviderContract
  is ProxyResource<IdentityProviderContractProperties> {
  /**
   * Identity Provider Type identifier.
   */
  @path
  @key("identityProviderName")
  @segment("identityProviders")
  @visibility("read")
  name: IdentityProviderType;
}

@armResourceOperations
interface IdentityProviderContracts {
  /**
   * Gets the configuration details of the identity Provider configured in specified service instance.
   */
  get is ArmResourceRead<IdentityProviderContract>;

  /**
   * Gets the entity state (Etag) version of the identityProvider specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      IdentityProviderContract,
      BaseParameters<IdentityProviderContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates the IdentityProvider configuration.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IdentityProviderContract,
    {
      ...BaseParameters<IdentityProviderContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates an existing IdentityProvider configuration.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    IdentityProviderContract,
    IdentityProviderUpdateParameters,
    {
      ...BaseParameters<IdentityProviderContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified identity provider configuration.
   */
  delete is ArmResourceDeleteSync<
    IdentityProviderContract,
    {
      ...BaseParameters<IdentityProviderContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of Identity Provider configured in the specified service instance.
   */
  listByService is ArmResourceListByParent<IdentityProviderContract>;

  /**
   * Gets the client secret details of the Identity Provider.
   */
  listSecrets is ArmResourceActionSync<
    IdentityProviderContract,
    void,
    ClientSecretContract
  >;
}

@@doc(IdentityProviderContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(IdentityProviderContracts.update::parameters.properties,
  "Update parameters."
);
