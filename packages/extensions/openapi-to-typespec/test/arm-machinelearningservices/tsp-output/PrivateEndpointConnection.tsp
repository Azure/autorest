import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("The Private Endpoint Connection resource.")
@parentResource(Workspace)
model PrivateEndpointConnection
  is TrackedResource<PrivateEndpointConnectionProperties> {
  @doc("NRP Private Endpoint Connection Name")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface PrivateEndpointConnections {
  @doc("Called by end-users to get a PE connection.")
  get is ArmResourceRead<PrivateEndpointConnection>;

  @doc("""
Called by end-users to approve or reject a PE connection.
This method must validate and forward the call to NRP.
""")
  createOrUpdate is ArmResourceCreateOrReplaceSync<PrivateEndpointConnection>;

  @doc("Called by end-users to delete a PE connection.")
  delete is ArmResourceDeleteSync<PrivateEndpointConnection>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Called by end-users to get all PE connections.")
  @operationId("PrivateEndpointConnections_List")
  list is ArmResourceListByParent<PrivateEndpointConnection>;
}

@@projectedName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "PrivateEndpointConnection object"
);
