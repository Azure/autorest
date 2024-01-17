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
@doc("External OAuth authorization server settings.")
@parentResource(ApiManagementServiceResource)
model AuthorizationServerContract
  is ProxyResource<AuthorizationServerContractProperties> {
  @doc("Identifier of the authorization server.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("authsid")
  @segment("authorizationServers")
  name: string;
}

@armResourceOperations
interface AuthorizationServerContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the authorization server specified by its identifier.")
  @operationId("AuthorizationServer_Get")
  get is ArmResourceRead<AuthorizationServerContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the authorizationServer specified by its identifier.")
  @head
  @operationId("AuthorizationServer_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      AuthorizationServerContract,
      BaseParameters<AuthorizationServerContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates new authorization server or updates an existing authorization server.")
  @operationId("AuthorizationServer_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    AuthorizationServerContract,
    {
      ...BaseParameters<AuthorizationServerContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the details of the authorization server specified by its identifier.")
  @parameterVisibility("read")
  @operationId("AuthorizationServer_Update")
  update is ArmCustomPatchSync<
    AuthorizationServerContract,
    AuthorizationServerUpdateContract,
    {
      ...BaseParameters<AuthorizationServerContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes specific authorization server instance.")
  @operationId("AuthorizationServer_Delete")
  delete is ArmResourceDeleteSync<
    AuthorizationServerContract,
    {
      ...BaseParameters<AuthorizationServerContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of authorization servers defined within a service instance.")
  @operationId("AuthorizationServer_ListByService")
  listByService is ArmResourceListByParent<
    AuthorizationServerContract,
    {
      ...BaseParameters<AuthorizationServerContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the client secret details of the authorization server.")
  @operationId("AuthorizationServer_ListSecrets")
  listSecrets is ArmResourceActionSync<
    AuthorizationServerContract,
    void,
    AuthorizationServerSecretsContract
  >;
}

@@projectedName(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@projectedName(AuthorizationServerContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(AuthorizationServerContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(AuthorizationServerContracts.update::parameters.properties,
  "OAuth2 Server settings Update parameters."
);
