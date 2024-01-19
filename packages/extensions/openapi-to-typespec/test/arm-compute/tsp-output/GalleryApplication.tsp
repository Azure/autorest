import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Gallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery Application Definition that you want to create or update.
 */
@parentResource(Gallery)
model GalleryApplication is TrackedResource<GalleryApplicationProperties> {
  /**
   * The name of the gallery Application Definition to be retrieved.
   */
  @path
  @key("galleryApplicationName")
  @segment("applications")
  name: string;
}

@armResourceOperations
interface GalleryApplications {
  /**
   * Retrieves information about a gallery Application Definition.
   */
  get is ArmResourceRead<GalleryApplication>;

  /**
   * Create or update a gallery Application Definition.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<GalleryApplication>;

  /**
   * Update a gallery Application Definition.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<GalleryApplication, GalleryApplicationUpdate>;

  /**
   * Delete a gallery Application.
   */
  delete is ArmResourceDeleteAsync<GalleryApplication>;

  /**
   * List gallery Application Definitions in a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GalleryApplications_ListByGallery")
  listByGallery is ArmResourceListByParent<GalleryApplication>;
}

@@projectedName(GalleryApplications.createOrUpdate::parameters.resource,
  "json",
  "galleryApplication"
);
@@extension(GalleryApplications.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "galleryApplication"
);
@@doc(GalleryApplications.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery Application operation."
);
@@projectedName(GalleryApplications.update::parameters.properties,
  "json",
  "galleryApplication"
);
@@extension(GalleryApplications.update::parameters.properties,
  "x-ms-client-name",
  "galleryApplication"
);
@@doc(GalleryApplications.update::parameters.properties,
  "Parameters supplied to the update gallery Application operation."
);
