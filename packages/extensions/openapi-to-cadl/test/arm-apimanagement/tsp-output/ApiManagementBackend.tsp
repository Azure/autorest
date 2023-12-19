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
@doc("Backend details.")
@parentResource(ApiManagementService)
model ApiManagementBackend is ProxyResource<BackendContractProperties> {
  @doc("Identifier of the Backend entity. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @path
  @key("backendId")
  @segment("backends")
  name: string;
}

@armResourceOperations
interface ApiManagementBackends {
  @doc("Gets the details of the backend specified by its identifier.")
  get is ArmResourceRead<ApiManagementBackend>;
  @doc("Gets the entity state (Etag) version of the backend specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementBackend,
      BaseParameters<ApiManagementBackend>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or Updates a backend.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementBackend,
    {
      ...BaseParameters<ApiManagementBackend>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates an existing backend.")
  update is ArmResourcePatchSync<
    ApiManagementBackend,
    BackendContractProperties,
    {
      ...BaseParameters<ApiManagementBackend>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes the specified backend.")
  delete is ArmResourceDeleteSync<
    ApiManagementBackend,
    {
      ...BaseParameters<ApiManagementBackend>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of backends in the specified service instance.")
  listByService is ArmResourceListByParent<
    ApiManagementBackend,
    {
      ...BaseParameters<ApiManagementBackend>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| title | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| url | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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
  @doc("Notifies the APIM proxy to create a new connection to the backend after the specified timeout. If no timeout was specified, timeout of 2 minutes is used.")
  reconnect is ArmResourceActionNoContentSync<
    ApiManagementBackend,
    BackendReconnectContract
  >;
}
