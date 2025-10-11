import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./SharedGalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/** Specifies information about the gallery image version that you want to create or update. */
@subscriptionResource
@parentResource(SharedGalleryImage)
model SharedGalleryImageVersion
  is Azure.ResourceManager.ProxyResource<SharedGalleryImageVersionProperties> {
  ...ResourceNameParameter<
    Resource = SharedGalleryImageVersion,
    KeyName = "galleryImageVersionName",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /** Resource location */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  location?: string;

  /** The identifier information of shared gallery. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identifier?: SharedGalleryIdentifier;
}

@armResourceOperations
interface SharedGalleryImageVersions {
  /** Get a shared gallery image version by subscription id or tenant id. */
  get is ArmResourceRead<
    SharedGalleryImageVersion,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /** List shared gallery image versions by subscription id or tenant id. */
  list is ArmResourceListByParent<
    SharedGalleryImageVersion,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters,
    Parameters = {
      /** The query parameter to decide what shared galleries to fetch when doing listing operations. */
      @query("sharedTo")
      sharedTo?: SharedToValues;
    },
    Response = ArmResponse<SharedGalleryImageVersionList>
  >;
}

@@doc(SharedGalleryImageVersion.name,
  "The name of the gallery image version to be created. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>"
);
@@doc(SharedGalleryImageVersion.properties,
  "Describes the properties of a gallery image version."
);
