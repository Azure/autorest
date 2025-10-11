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
/** Specifies information about the gallery image definition that you want to create or update. */
@subscriptionResource
@parentResource(CommunityGallery)
model CommunityGalleryImage
  is Azure.ResourceManager.ProxyResource<CommunityGalleryImageProperties> {
  ...ResourceNameParameter<
    Resource = CommunityGalleryImage,
    KeyName = "galleryImageName",
    SegmentName = "images",
    NamePattern = ""
  >;

  /** Resource location */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  location?: string;

  /** The identifier information of community gallery. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identifier?: CommunityGalleryIdentifier;
}

@armResourceOperations
interface CommunityGalleryImages {
  /** Get a community gallery image. */
  get is ArmResourceRead<
    CommunityGalleryImage,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /** List community gallery images inside a gallery. */
  list is ArmResourceListByParent<
    CommunityGalleryImage,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters,
    Response = ArmResponse<CommunityGalleryImageList>
  >;
}

@@doc(CommunityGalleryImage.name,
  "The name of the community gallery image definition."
);
@@doc(CommunityGalleryImage.properties,
  "Describes the properties of a gallery image definition."
);
