import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CommunityGallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery image definition that you want to create or update.
 */
@parentResource(CommunityGallery)
model CommunityGalleryImage
  is Azure.ResourceManager.ProxyResource<CommunityGalleryImageProperties> {
  ...ResourceNameParameter<
    Resource = CommunityGalleryImage,
    KeyName = "galleryImageName",
    SegmentName = "images",
    NamePattern = ""
  >;
}

@armResourceOperations
interface CommunityGalleryImages {
  /**
   * Get a community gallery image.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("CommunityGalleryImages_Get")
  get is ArmResourceRead<CommunityGalleryImage>;

  /**
   * List community gallery images inside a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("CommunityGalleryImages_List")
  list is ArmResourceListByParent<
    CommunityGalleryImage,
    Response = ArmResponse<CommunityGalleryImageList>
  >;
}

@@doc(CommunityGalleryImage.name,
  "The name of the community gallery image definition."
);
@@doc(CommunityGalleryImage.properties,
  "Describes the properties of a gallery image definition."
);
