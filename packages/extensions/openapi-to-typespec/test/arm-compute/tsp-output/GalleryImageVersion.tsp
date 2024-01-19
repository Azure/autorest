import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GalleryImage.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery image version that you want to create or update.
 */
@parentResource(GalleryImage)
model GalleryImageVersion is TrackedResource<GalleryImageVersionProperties> {
  /**
   * The name of the gallery image version to be retrieved.
   */
  @path
  @key("galleryImageVersionName")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface GalleryImageVersions {
  /**
   * Retrieves information about a gallery image version.
   */
  get is ArmResourceRead<
    GalleryImageVersion,
    {
      ...BaseParameters<GalleryImageVersion>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<GalleryImageVersion, GalleryImageVersionUpdate>;

  /**
   * Delete a gallery image version.
   */
  delete is ArmResourceDeleteAsync<GalleryImageVersion>;

  /**
   * List gallery image versions in a gallery image definition.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GalleryImageVersions_ListByGalleryImage")
  listByGalleryImage is ArmResourceListByParent<GalleryImageVersion>;
}

@@projectedName(GalleryImageVersions.createOrUpdate::parameters.resource,
  "json",
  "galleryImageVersion"
);
@@extension(GalleryImageVersions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "galleryImageVersion"
);
@@doc(GalleryImageVersions.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery image version operation."
);
@@projectedName(GalleryImageVersions.update::parameters.properties,
  "json",
  "galleryImageVersion"
);
@@extension(GalleryImageVersions.update::parameters.properties,
  "x-ms-client-name",
  "galleryImageVersion"
);
@@doc(GalleryImageVersions.update::parameters.properties,
  "Parameters supplied to the update gallery image version operation."
);
