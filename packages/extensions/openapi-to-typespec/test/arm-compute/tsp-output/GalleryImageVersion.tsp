import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery image version that you want to create or update.
 */
@parentResource(GalleryImage)
model GalleryImageVersion
  is Azure.ResourceManager.TrackedResource<GalleryImageVersionProperties> {
  ...ResourceNameParameter<
    Resource = GalleryImageVersion,
    KeyName = "galleryImageVersionName",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GalleryImageVersions {
  /**
   * Retrieves information about a gallery image version.
   */
  get is ArmResourceRead<
    GalleryImageVersion,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: ReplicationStatusTypes;
    }
  >;

  /**
   * Create or update a gallery image version.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<GalleryImageVersion>;

  /**
   * Update a gallery image version.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<GalleryImageVersion, GalleryImageVersionUpdate>;

  /**
   * Delete a gallery image version.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<GalleryImageVersion>;

  /**
   * List gallery image versions in a gallery image definition.
   */
  listByGalleryImage is ArmResourceListByParent<GalleryImageVersion>;
}

@@doc(GalleryImageVersion.name,
  "The name of the gallery image version to be retrieved."
);
@@doc(GalleryImageVersion.properties,
  "Describes the properties of a gallery image version."
);
@@doc(GalleryImageVersions.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery image version operation."
);
@@doc(GalleryImageVersions.update::parameters.properties,
  "Parameters supplied to the update gallery image version operation."
);
