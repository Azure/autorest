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
/**
 * Specifies information about the gallery image version that you want to create or update.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(CommunityGalleryImage)
@includeInapplicableMetadataInPayload(false)
model CommunityGalleryImageVersion extends PirCommunityGalleryResource {
  ...ResourceNameParameter<
    Resource = CommunityGalleryImageVersion,
    KeyName = "galleryImageVersionName",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a gallery image version.
   */
  @extension("x-ms-client-flatten", true)
  properties?: CommunityGalleryImageVersionProperties;
}

@armResourceOperations
interface CommunityGalleryImageVersions {
  /**
   * Get a community gallery image version.
   */
  get is ArmResourceRead<CommunityGalleryImageVersion>;

  /**
   * List community gallery image versions inside an image.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CommunityGalleryImageVersions_List")
  list is ArmResourceListByParent<CommunityGalleryImageVersion>;
}

@@doc(CommunityGalleryImageVersion.name,
  "The name of the community gallery image version. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>"
);
