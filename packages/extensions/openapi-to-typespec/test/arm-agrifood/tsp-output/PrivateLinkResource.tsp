import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AgFoodPlatform;
/**
 * A private link resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(DataManagerForAgriculture)
@Azure.ResourceManager.Private.armResourceInternal(
  PrivateLinkResourceProperties
)
@includeInapplicableMetadataInPayload(false)
model PrivateLinkResource extends ProxyResourceBase {
  /**
   * Sub resource name.
   */
  @path
  @key("subResourceName")
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
   * Get Private link resource object.
   */
  get is ArmResourceRead<PrivateLinkResource>;

  /**
   * Get list of Private link resources.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PrivateLinkResources_ListByResource")
  listByResource is ArmResourceListByParent<PrivateLinkResource>;
}
