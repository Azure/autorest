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
 * Specifies information about the gallery image definition that you want to create or update.
 */
@parentResource(Gallery)
model GalleryImage is TrackedResource<GalleryImageProperties> {
  /**
   * The name of the gallery image definition to be retrieved.
   */
  @path
  @key("galleryImageName")
  @segment("images")
  name: string;
}

@armResourceOperations
interface GalleryImages {
  /**
   * Retrieves information about a gallery image definition.
   */
  get is ArmResourceRead<GalleryImage>;

  /**
   * Create or update a gallery image definition.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<GalleryImage>;

  /**
   * Update a gallery image definition.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<GalleryImage, GalleryImageUpdate>;

  /**
   * Delete a gallery image.
   */
  delete is ArmResourceDeleteAsync<GalleryImage>;

  /**
   * List gallery image definitions in a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GalleryImages_ListByGallery")
  listByGallery is ArmResourceListByParent<GalleryImage>;
}

@@projectedName(GalleryImages.createOrUpdate::parameters.resource,
  "json",
  "galleryImage"
);
@@extension(GalleryImages.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "galleryImage"
);
@@doc(GalleryImages.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery image operation."
);
@@projectedName(GalleryImages.update::parameters.properties,
  "json",
  "galleryImage"
);
@@extension(GalleryImages.update::parameters.properties,
  "x-ms-client-name",
  "galleryImage"
);
@@doc(GalleryImages.update::parameters.properties,
  "Parameters supplied to the update gallery image operation."
);
