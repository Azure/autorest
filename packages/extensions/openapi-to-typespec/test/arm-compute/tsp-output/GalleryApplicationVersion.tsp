import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GalleryApplication.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery Application Version that you want to create or update.
 */
@parentResource(GalleryApplication)
model GalleryApplicationVersion
  is TrackedResource<GalleryApplicationVersionProperties> {
  /**
   * The name of the gallery Application Version to be retrieved.
   */
  @path
  @key("galleryApplicationVersionName")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface GalleryApplicationVersions {
  /**
   * Retrieves information about a gallery Application Version.
   */
  get is ArmResourceRead<
    GalleryApplicationVersion,
    {
      ...BaseParameters<GalleryApplicationVersion>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: ReplicationStatusTypes;
    }
  >;

  /**
   * Create or update a gallery Application Version.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<GalleryApplicationVersion>;

  /**
   * Update a gallery Application Version.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    GalleryApplicationVersion,
    GalleryApplicationVersionUpdate
  >;

  /**
   * Delete a gallery Application Version.
   */
  delete is ArmResourceDeleteAsync<GalleryApplicationVersion>;

  /**
   * List gallery Application Versions in a gallery Application Definition.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GalleryApplicationVersions_ListByGalleryApplication")
  listByGalleryApplication is ArmResourceListByParent<GalleryApplicationVersion>;
}

@@projectedName(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "json",
  "galleryApplicationVersion"
);
@@extension(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "galleryApplicationVersion"
);
@@doc(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery Application Version operation."
);
@@projectedName(GalleryApplicationVersions.update::parameters.properties,
  "json",
  "galleryApplicationVersion"
);
@@extension(GalleryApplicationVersions.update::parameters.properties,
  "x-ms-client-name",
  "galleryApplicationVersion"
);
@@doc(GalleryApplicationVersions.update::parameters.properties,
  "Parameters supplied to the update gallery Application Version operation."
);
