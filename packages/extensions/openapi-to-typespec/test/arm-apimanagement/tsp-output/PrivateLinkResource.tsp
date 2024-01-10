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
@doc("A private link resource")
@parentResource(ApiManagementServiceResource)
model PrivateLinkResource is ProxyResource<PrivateLinkResourceProperties> {
  @doc("Name of the private link resource.")
  @path
  @key("privateLinkSubResourceName")
  @segment("privateLinkResources")
  name: string;
}

@armResourceOperations
interface PrivateLinkResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the private link resources")
  @operationId("PrivateEndpointConnection_GetPrivateLinkResource")
  getPrivateLinkResource is ArmResourceRead<PrivateLinkResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the private link resources")
  @operationId("PrivateEndpointConnection_ListPrivateLinkResources")
  listPrivateLinkResources is ArmResourceListByParent<PrivateLinkResource>;
}
