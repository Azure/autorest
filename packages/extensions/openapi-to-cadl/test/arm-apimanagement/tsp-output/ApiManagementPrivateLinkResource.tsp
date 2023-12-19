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
@doc("A private link resource")
@parentResource(ApiManagementService)
model ApiManagementPrivateLinkResource
  is ProxyResource<PrivateLinkResourceProperties> {
  @doc("Name of the private link resource.")
  @path
  @key("privateLinkSubResourceName")
  @segment("privateLinkResources")
  name: string;
}

@armResourceOperations
interface ApiManagementPrivateLinkResources {
  @doc("Gets the private link resources")
  getPrivateLinkResource is ArmResourceRead<ApiManagementPrivateLinkResource>;
  @doc("Gets the private link resources")
  listPrivateLinkResources is ArmResourceListByParent<ApiManagementPrivateLinkResource>;
}
