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
/**
 * Specifies information about the gallery image version that you want to create or update.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(SharedGalleryImage)
@includeInapplicableMetadataInPayload(false)
model SharedGalleryImageVersion extends PirSharedGalleryResource {
  ...ResourceNameParameter<
    Resource = SharedGalleryImageVersion,
    KeyName = "galleryImageVersionName",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a gallery image version.
   */
  @extension("x-ms-client-flatten", true)
  properties?: SharedGalleryImageVersionProperties;
}

@armResourceOperations
interface SharedGalleryImageVersions {
  /**
   * Get a shared gallery image version by subscription id or tenant id.
   */
  get is ArmResourceRead<SharedGalleryImageVersion>;

  /**
   * List shared gallery image versions by subscription id or tenant id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SharedGalleryImageVersions_List")
  list is ArmResourceListByParent<
    SharedGalleryImageVersion,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<SharedGalleryImageVersion>;

      /**
       * The query parameter to decide what shared galleries to fetch when doing listing operations.
       */
      @query("sharedTo")
      sharedTo?: SharedToValues;
    }
  >;
}

@@doc(SharedGalleryImageVersion.name,
  "The name of the gallery image version to be created. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>"
);
