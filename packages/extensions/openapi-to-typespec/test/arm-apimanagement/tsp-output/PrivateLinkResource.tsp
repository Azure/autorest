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
@doc("A private link resource")
@parentResource(ApiManagementServiceResource)
model PrivateLinkResource is ProxyResource<PrivateLinkResourceProperties> {
  @doc("Name of the private link resource.")
  @key("privateLinkSubResourceName")
  @segment("privateLinkResources")
  name: string;
}

@armResourceOperations
interface PrivateEndpointConnection {
  @doc("Gets the private link resources")
  getPrivateLinkResource is ArmResourceRead<PrivateLinkResource>;
  @doc("Gets the private link resources")
  listPrivateLinkResources is ArmResourceListByParent<PrivateLinkResource>;
}
