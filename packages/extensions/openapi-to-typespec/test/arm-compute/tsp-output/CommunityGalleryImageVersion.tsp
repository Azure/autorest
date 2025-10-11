import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CommunityGalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/** Specifies information about the gallery image version that you want to create or update. */
@subscriptionResource
@parentResource(CommunityGalleryImage)
model CommunityGalleryImageVersion
  is Azure.ResourceManager.ProxyResource<CommunityGalleryImageVersionProperties> {
  ...ResourceNameParameter<
    Resource = CommunityGalleryImageVersion,
    KeyName = "galleryImageVersionName",
    SegmentName = "versions",
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
interface CommunityGalleryImageVersions {
  /** Get a community gallery image version. */
  get is ArmResourceRead<
    CommunityGalleryImageVersion,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /** List community gallery image versions inside an image. */
  list is ArmResourceListByParent<
    CommunityGalleryImageVersion,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters,
    Response = ArmResponse<CommunityGalleryImageVersionList>
  >;
}

@@doc(CommunityGalleryImageVersion.name,
  "The name of the community gallery image version. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>"
);
@@doc(CommunityGalleryImageVersion.properties,
  "Describes the properties of a gallery image version."
);
