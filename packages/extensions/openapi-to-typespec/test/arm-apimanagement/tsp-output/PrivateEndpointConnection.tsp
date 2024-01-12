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
@doc("The Private Endpoint Connection resource.")
@parentResource(ApiManagementServiceResource)
model PrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("Name of the private endpoint connection.")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface PrivateEndpointConnections {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the Private Endpoint Connection specified by its identifier.")
  @operationId("PrivateEndpointConnection_GetByName")
  getByName is ArmResourceRead<PrivateEndpointConnection>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new Private Endpoint Connection or updates an existing one.")
  @operationId("PrivateEndpointConnection_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<PrivateEndpointConnection>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified Private Endpoint Connection.")
  @operationId("PrivateEndpointConnection_Delete")
  delete is ArmResourceDeleteAsync<PrivateEndpointConnection>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all private endpoint connections of the API Management service instance.")
  @operationId("PrivateEndpointConnection_ListByService")
  listByService is ArmResourceListByParent<PrivateEndpointConnection>;
}

@@projectedName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "json",
  "privateEndpointConnectionRequest"
);
@@extension(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "privateEndpointConnectionRequest"
);
@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource, "");
