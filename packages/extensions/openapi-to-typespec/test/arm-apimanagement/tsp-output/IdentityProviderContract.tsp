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
@doc("Identity Provider details.")
@parentResource(ApiManagementServiceResource)
model IdentityProviderContract
  is ProxyResource<IdentityProviderContractProperties> {
  @doc("Identity Provider Type identifier.")
  @path
  @key("identityProviderName")
  @segment("identityProviders")
  name: IdentityProviderType;
}

@armResourceOperations
interface IdentityProviderContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the configuration details of the identity Provider configured in specified service instance.")
  @operationId("IdentityProvider_Get")
  get is ArmResourceRead<IdentityProviderContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the identityProvider specified by its identifier.")
  @head
  @operationId("IdentityProvider_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      IdentityProviderContract,
      BaseParameters<IdentityProviderContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or Updates the IdentityProvider configuration.")
  @operationId("IdentityProvider_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IdentityProviderContract,
    {
      ...BaseParameters<IdentityProviderContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates an existing IdentityProvider configuration.")
  @operationId("IdentityProvider_Update")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified identity provider configuration.")
  @operationId("IdentityProvider_Delete")
  delete is ArmResourceDeleteSync<
    IdentityProviderContract,
    {
      ...BaseParameters<IdentityProviderContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of Identity Provider configured in the specified service instance.")
  @operationId("IdentityProvider_ListByService")
  listByService is ArmResourceListByParent<IdentityProviderContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the client secret details of the Identity Provider.")
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
