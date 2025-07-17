import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AgFoodPlatform;
/**
 * A private link resource.
 */
@parentResource(DataManagerForAgriculture)
model PrivateLinkResource
  is Azure.ResourceManager.ProxyResource<PrivateLinkResourceProperties> {
  ...ResourceNameParameter<
    Resource = PrivateLinkResource,
    KeyName = "subResourceName",
    SegmentName = "privateLinkResources",
    NamePattern = ""
  >;
}

@armResourceOperations
interface PrivateLinkResources {
  /**
   * Get Private link resource object.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateLinkResources_Get")
  get is ArmResourceRead<PrivateLinkResource>;

  /**
   * Get list of Private link resources.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateLinkResources_ListByResource")
  listByResource is ArmResourceListByParent<
    PrivateLinkResource,
    Response = ArmResponse<Azure.ResourceManager.CommonTypes.PrivateLinkResourceListResultV5>
  >;
}

@@doc(PrivateLinkResource.name, "Sub resource name.");
@@doc(PrivateLinkResource.properties, "Resource properties.");
