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
@doc("External OAuth authorization server settings.")
@parentResource(ApiManagementServiceResource)
model AuthorizationServerContract
  is ProxyResource<AuthorizationServerContractProperties> {
  @doc("Identifier of the authorization server.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("authsid")
  @segment("authorizationServers")
  name: string;
}

@armResourceOperations
@projectedName("client", "AuthorizationServer")
interface AuthorizationServerContracts_AuthorizationServer {
  @doc("Gets the details of the authorization server specified by its identifier.")
  get is ArmResourceRead<AuthorizationServerContract>;

  @doc("Gets the entity state (Etag) version of the authorizationServer specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      AuthorizationServerContract,
      BaseParameters<AuthorizationServerContract>
    >,
  ): OkResponse | ErrorResponse;

  @doc("Creates new authorization server or updates an existing authorization server.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    AuthorizationServerContract,
    {
      ...BaseParameters<AuthorizationServerContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Updates the details of the authorization server specified by its identifier.")
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

  @doc("Deletes specific authorization server instance.")
  delete is ArmResourceDeleteSync<
    AuthorizationServerContract,
    {
      ...BaseParameters<AuthorizationServerContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Lists a collection of authorization servers defined within a service instance.")
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

  @doc("Gets the client secret details of the authorization server.")
  listSecrets is ArmResourceActionSync<
    AuthorizationServerContract,
    void,
    AuthorizationServerSecretsContract
  >;
}
