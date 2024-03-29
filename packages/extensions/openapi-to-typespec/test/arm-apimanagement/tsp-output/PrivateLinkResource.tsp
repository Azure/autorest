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
 * A private link resource
 */
@parentResource(ApiManagementServiceResource)
model PrivateLinkResource is ProxyResource<PrivateLinkResourceProperties> {
  /**
   * Name of the private link resource.
   */
  @path
  @key("privateLinkSubResourceName")
  @segment("privateLinkResources")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface PrivateLinkResources {
  /**
   * Gets the private link resources
   */
  getPrivateLinkResource is ArmResourceRead<PrivateLinkResource>;

  /**
   * Gets the private link resources
   */
  listPrivateLinkResources is ArmResourceListByParent<PrivateLinkResource>;
}
