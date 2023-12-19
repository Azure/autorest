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
@doc("The Private Endpoint Connection resource.")
@parentResource(ApiManagementService)
model ApiManagementPrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("Name of the private endpoint connection.")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface ApiManagementPrivateEndpointConnections {
  @doc("Gets the details of the Private Endpoint Connection specified by its identifier.")
  getByName is ArmResourceRead<ApiManagementPrivateEndpointConnection>;
  @doc("Creates a new Private Endpoint Connection or updates an existing one.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ApiManagementPrivateEndpointConnection>;
  @doc("Deletes the specified Private Endpoint Connection.")
  delete is ArmResourceDeleteAsync<ApiManagementPrivateEndpointConnection>;
  @doc("Lists all private endpoint connections of the API Management service instance.")
  listByService is ArmResourceListByParent<ApiManagementPrivateEndpointConnection>;
}
