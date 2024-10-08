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
/**
 * External OAuth authorization server settings.
 */
@parentResource(ApiManagementServiceResource)
model AuthorizationServerContract
  is Azure.ResourceManager.ProxyResource<AuthorizationServerContractProperties> {
  ...ResourceNameParameter<
    Resource = AuthorizationServerContract,
    KeyName = "authsid",
    SegmentName = "authorizationServers",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface AuthorizationServerContracts {
  /**
   * Gets the details of the authorization server specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("AuthorizationServer_Get")
  get is ArmResourceRead<AuthorizationServerContract>;

  /**
   * Gets the entity state (Etag) version of the authorizationServer specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("AuthorizationServer_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      AuthorizationServerContract,
      BaseParameters<AuthorizationServerContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates new authorization server or updates an existing authorization server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("AuthorizationServer_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    AuthorizationServerContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the authorization server specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("AuthorizationServer_Update")
  update is ArmCustomPatchSync<
    AuthorizationServerContract,
    AuthorizationServerUpdateContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific authorization server instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("AuthorizationServer_Delete")
  delete is ArmResourceDeleteSync<
    AuthorizationServerContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of authorization servers defined within a service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("AuthorizationServer_ListByService")
  listByService is ArmResourceListByParent<
    AuthorizationServerContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;

  /**
   * Gets the client secret details of the authorization server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("AuthorizationServer_ListSecrets")
  listSecrets is ArmResourceActionSync<
    AuthorizationServerContract,
    void,
    AuthorizationServerSecretsContract
  >;
}

@@maxLength(AuthorizationServerContract.name, 80);
@@minLength(AuthorizationServerContract.name, 1);
@@doc(AuthorizationServerContract.name,
  "Identifier of the authorization server."
);
@@doc(AuthorizationServerContract.properties,
  "Properties of the External OAuth authorization server Contract."
);
@@doc(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(AuthorizationServerContracts.update::parameters.properties,
  "OAuth2 Server settings Update parameters."
);
