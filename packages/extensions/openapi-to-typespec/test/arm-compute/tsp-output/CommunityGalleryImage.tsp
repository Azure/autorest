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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(CommunityGallery)
@includeInapplicableMetadataInPayload(false)
model CommunityGalleryImage extends PirCommunityGalleryResource {
  /**
   * The name of the community gallery image definition.
   */
  @path
  @key("galleryImageName")
  @segment("images")
  @visibility("read")
  name: string;

  /**
   * Describes the properties of a gallery image definition.
   */
  @extension("x-ms-client-flatten", true)
  properties?: CommunityGalleryImageProperties;
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
