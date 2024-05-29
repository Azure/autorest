import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./SharedGallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery image definition that you want to create or update.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(SharedGallery)
@includeInapplicableMetadataInPayload(false)
model SharedGalleryImage extends PirSharedGalleryResource {
  ...ResourceNameParameter<
    Resource = SharedGalleryImage,
    KeyName = "galleryImageName",
    SegmentName = "images",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a gallery image definition.
   */
  @extension("x-ms-client-flatten", true)
  properties?: SharedGalleryImageProperties;
}

@armResourceOperations
interface SharedGalleryImages {
  /**
   * Get a shared gallery image by subscription id or tenant id.
   */
  get is ArmResourceRead<SharedGalleryImage>;

  /**
   * List shared gallery images by subscription id or tenant id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SharedGalleryImages_List")
  list is ArmResourceListByParent<
    SharedGalleryImage,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<SharedGalleryImage>;

      /**
       * The query parameter to decide what shared galleries to fetch when doing listing operations.
       */
      @query("sharedTo")
      sharedTo?: SharedToValues;
    }
  >;
}

@@doc(SharedGalleryImage.name,
  "The name of the Shared Gallery Image Definition from which the Image Versions are to be listed."
);
