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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@Azure.ResourceManager.Private.armResourceInternal(
  IdentityProviderContractProperties
)
@includeInapplicableMetadataInPayload(false)
model IdentityProviderContract extends ProxyResourceBase {
  /**
   * Identity Provider Type identifier.
   */
  @path
  @key("identityProviderName")
  @segment("identityProviders")
  name: IdentityProviderType;

  /**
   * Identity Provider contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: IdentityProviderContractProperties;
}

@armResourceOperations
interface IdentityProviderContracts {
  /**
   * Gets the configuration details of the identity Provider configured in specified service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("IdentityProvider_Get")
  get is ArmResourceRead<IdentityProviderContract>;

  /**
   * Gets the entity state (Etag) version of the identityProvider specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("IdentityProvider_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      IdentityProviderContract,
      BaseParameters<IdentityProviderContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates the IdentityProvider configuration.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("IdentityProvider_CreateOrUpdate")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("IdentityProvider_Update")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("IdentityProvider_Delete")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("IdentityProvider_ListByService")
  listByService is ArmResourceListByParent<IdentityProviderContract>;

  /**
   * Gets the client secret details of the Identity Provider.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("IdentityProvider_ListSecrets")
  listSecrets is ArmResourceActionSync<
    IdentityProviderContract,
    void,
    ClientSecretContract
  >;
}

@@projectedName(IdentityProviderContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(IdentityProviderContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(IdentityProviderContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@projectedName(IdentityProviderContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(IdentityProviderContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(IdentityProviderContracts.update::parameters.properties,
  "Update parameters."
);
