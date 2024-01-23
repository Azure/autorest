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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@Azure.ResourceManager.Private.armResourceInternal(
  PrivateLinkResourceProperties
)
@includeInapplicableMetadataInPayload(false)
model PrivateLinkResource extends ProxyResourceBase {
  /**
   * Name of the private link resource.
   */
  @path
  @key("privateLinkSubResourceName")
  @segment("privateLinkResources")
  name: string;

  /**
   * Resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PrivateLinkResourceProperties;
}

@armResourceOperations
interface PrivateLinkResources {
  /**
   * Gets the private link resources
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PrivateEndpointConnection_GetPrivateLinkResource")
  getPrivateLinkResource is ArmResourceRead<PrivateLinkResource>;

  /**
   * Gets the private link resources
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PrivateEndpointConnection_ListPrivateLinkResources")
  listPrivateLinkResources is ArmResourceListByParent<PrivateLinkResource>;
}
