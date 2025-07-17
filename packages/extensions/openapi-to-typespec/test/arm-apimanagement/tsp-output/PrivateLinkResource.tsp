import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * A private link resource
 */
@parentResource(ApiManagementServiceResource)
model PrivateLinkResource
  is Azure.ResourceManager.ProxyResource<PrivateLinkResourceProperties> {
  ...ResourceNameParameter<
    Resource = PrivateLinkResource,
    KeyName = "privateLinkSubResourceName",
    SegmentName = "privateLinkResources",
    NamePattern = ""
  >;
}

@armResourceOperations
interface PrivateLinkResources {
  /**
   * Gets the private link resources
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateEndpointConnection_GetPrivateLinkResource")
  getPrivateLinkResource is ArmResourceRead<PrivateLinkResource>;

  /**
   * Gets the private link resources
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateEndpointConnection_ListPrivateLinkResources")
  listPrivateLinkResources is ArmResourceListByParent<
    PrivateLinkResource,
    Response = ArmResponse<Azure.ResourceManager.CommonTypes.PrivateLinkResourceListResultV5>
  >;
}

@@doc(PrivateLinkResource.name, "Name of the private link resource.");
@@doc(PrivateLinkResource.properties, "Resource properties.");
