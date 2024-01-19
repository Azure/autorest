import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
// FIXME: CommunityGallery has no properties property
/**
 * Specifies information about the Community Gallery that you want to create or update.
 */
@locationResource
model CommunityGallery is ProxyResource<{}> {
  /**
   * The public name of the community gallery.
   */
  @path
  @key("publicGalleryName")
  @segment("communityGalleries")
  name: string;
}

@armResourceOperations
interface CommunityGalleries {
  /**
   * Get a community gallery by gallery public name.
   */
  get is ArmResourceRead<CommunityGallery>;
}
