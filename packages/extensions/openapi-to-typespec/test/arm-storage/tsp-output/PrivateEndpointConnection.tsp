import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
@doc("The Private Endpoint Connection resource.")
@parentResource(StorageAccount)
model PrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("The name of the private endpoint connection associated with the Azure resource")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface PrivateEndpointConnections {
  @doc("Gets the specified private endpoint connection associated with the storage account.")
  get is ArmResourceRead<PrivateEndpointConnection>;

  @doc("Update the state of specified private endpoint connection associated with the storage account.")
  put is ArmResourceCreateOrReplaceSync<PrivateEndpointConnection>;

  @doc("Deletes the specified private endpoint connection associated with the storage account.")
  delete is ArmResourceDeleteSync<PrivateEndpointConnection>;

  @doc("List all the private endpoint connections associated with the storage account.")
  list is ArmResourceListByParent<PrivateEndpointConnection>;
}
