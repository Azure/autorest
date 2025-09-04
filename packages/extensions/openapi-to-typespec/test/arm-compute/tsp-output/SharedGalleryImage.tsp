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
@subscriptionResource
@parentResource(SharedGallery)
model SharedGalleryImage
  is Azure.ResourceManager.ProxyResource<SharedGalleryImageProperties> {
  ...ResourceNameParameter<
    Resource = SharedGalleryImage,
    KeyName = "galleryImageName",
    SegmentName = "images",
    NamePattern = ""
  >;

  /**
   * Resource location
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  location?: string;

  /**
   * The identifier information of shared gallery.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identifier?: SharedGalleryIdentifier;
}

@armResourceOperations
interface SharedGalleryImages {
  /**
   * Get a shared gallery image by subscription id or tenant id.
   */
  get is ArmResourceRead<
    SharedGalleryImage,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * List shared gallery images by subscription id or tenant id.
   */
  list is ArmResourceListByParent<
    SharedGalleryImage,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters,
    Parameters = {
      /**
       * The query parameter to decide what shared galleries to fetch when doing listing operations.
       */
      @query("sharedTo")
      sharedTo?: SharedToValues;
    },
    Response = ArmResponse<SharedGalleryImageList>
  >;
}

@@doc(SharedGalleryImage.name,
  "The name of the Shared Gallery Image Definition from which the Image Versions are to be listed."
);
@@doc(SharedGalleryImage.properties,
  "Describes the properties of a gallery image definition."
);
