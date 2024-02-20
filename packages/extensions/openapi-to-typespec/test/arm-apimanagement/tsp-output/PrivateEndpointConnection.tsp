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
 * The Private Endpoint Connection resource.
 */
@parentResource(ApiManagementServiceResource)
model PrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  /**
   * Name of the private endpoint connection.
   */
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface PrivateEndpointConnections {
  /**
   * Gets the details of the Private Endpoint Connection specified by its identifier.
   */
  getByName is ArmResourceRead<PrivateEndpointConnection>;

  /**
   * Creates a new Private Endpoint Connection or updates an existing one.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<PrivateEndpointConnection>;

  /**
   * Deletes the specified Private Endpoint Connection.
   */
  delete is ArmResourceDeleteAsync<PrivateEndpointConnection>;

  /**
   * Lists all private endpoint connections of the API Management service instance.
   */
  listByService is ArmResourceListByParent<PrivateEndpointConnection>;
}

@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource, "");
