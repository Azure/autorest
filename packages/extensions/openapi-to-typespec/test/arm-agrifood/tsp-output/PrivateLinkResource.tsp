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

namespace Azure.ResourceManager.AgFoodPlatform;
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
  get is ArmResourceRead<PrivateLinkResource>;

  /**
   * Get list of Private link resources.
   */
  listByResource is ArmResourceListByParent<PrivateLinkResource>;
}

@@doc(PrivateLinkResource.name, "Sub resource name.");
@@doc(PrivateLinkResource.properties, "Resource properties.");
