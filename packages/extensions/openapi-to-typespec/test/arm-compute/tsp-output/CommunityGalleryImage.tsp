import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CommunityGallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery image definition that you want to create or update.
 */
@parentResource(CommunityGallery)
model CommunityGalleryImage is ProxyResource<CommunityGalleryImageProperties> {
  /**
   * The name of the community gallery image definition.
   */
  @path
  @key("galleryImageName")
  @segment("images")
  name: string;
}

@armResourceOperations
interface CommunityGalleryImages {
  /**
   * Get a community gallery image.
   */
  get is ArmResourceRead<CommunityGalleryImage>;

  /**
   * List community gallery images inside a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CommunityGalleryImages_List")
  list is ArmResourceListByParent<CommunityGalleryImage>;
}
