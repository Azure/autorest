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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  AuthorizationServerContractProperties
)
model AuthorizationServerContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = AuthorizationServerContract,
    KeyName = "authsid",
    SegmentName = "authorizationServers",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * Properties of the External OAuth authorization server Contract.
   */
  @extension("x-ms-client-flatten", true)
  properties?: AuthorizationServerContractProperties;
}

@armResourceOperations
interface AuthorizationServerContracts {
  /**
   * Gets the details of the authorization server specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AuthorizationServer_Get")
  get is ArmResourceRead<AuthorizationServerContract>;

  /**
   * Gets the entity state (Etag) version of the authorizationServer specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AuthorizationServer_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    AuthorizationServerContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AuthorizationServerContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("AuthorizationServer_Update")
  update is ArmCustomPatchSync<
    AuthorizationServerContract,
    AuthorizationServerUpdateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AuthorizationServerContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("AuthorizationServer_Delete")
  delete is ArmResourceDeleteSync<
    AuthorizationServerContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AuthorizationServerContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AuthorizationServer_ListByService")
  listByService is ArmResourceListByParent<
    AuthorizationServerContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<AuthorizationServerContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
@@encodedName(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(AuthorizationServerContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(AuthorizationServerContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(AuthorizationServerContracts.update::parameters.properties,
  "OAuth2 Server settings Update parameters."
);
