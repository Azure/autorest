import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/** Identity Provider details. */
@parentResource(ApiManagementServiceResource)
model IdentityProviderContract
  is Azure.ResourceManager.ProxyResource<IdentityProviderContractProperties> {
  ...ResourceNameParameter<
    Resource = IdentityProviderContract,
    KeyName = "identityProviderName",
    SegmentName = "identityProviders",
    NamePattern = "",
    Type = IdentityProviderType
  >;
}

@armResourceOperations
interface IdentityProviderContracts {
  /** Gets the configuration details of the identity Provider configured in specified service instance. */
  get is ArmResourceRead<IdentityProviderContract>;

  /** Gets the entity state (Etag) version of the identityProvider specified by its identifier. */
  getEntityTag is ArmResourceCheckExistence<IdentityProviderContract>;

  /** Creates or Updates the IdentityProvider configuration. */
  createOrUpdate is Azure.ResourceManager.Legacy.CreateOrUpdateSync<
    IdentityProviderContract,
    Request = IdentityProviderCreateContract,
    Parameters = {
      /** ETag of the Entity. Not required when creating an entity, but required when updating an entity. */
      @header
      `If-Match`?: string;
    }
  >;

  /** Updates an existing IdentityProvider configuration. */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    IdentityProviderContract,
    PatchModel = IdentityProviderUpdateParameters,
    Parameters = {
      /** ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update. */
      @header
      `If-Match`: string;
    }
  >;

  /** Deletes the specified identity provider configuration. */
  delete is ArmResourceDeleteSync<
    IdentityProviderContract,
    Parameters = {
      /** ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update. */
      @header
      `If-Match`: string;
    }
  >;

  /** Lists a collection of Identity Provider configured in the specified service instance. */
  listByService is ArmResourceListByParent<
    IdentityProviderContract,
    Response = ArmResponse<IdentityProviderList>
  >;

  /** Gets the client secret details of the Identity Provider. */
  listSecrets is ArmResourceActionSync<
    IdentityProviderContract,
    void,
    ArmResponse<ClientSecretContract>
  >;
}

@@doc(IdentityProviderContract.name, "Identity Provider Type identifier.");
@@doc(IdentityProviderContract.properties,
  "Identity Provider contract properties."
);
@@doc(IdentityProviderContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(IdentityProviderContracts.update::parameters.properties,
  "Update parameters."
);
