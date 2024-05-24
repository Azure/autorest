import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Gallery.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery image definition that you want to create or update.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Gallery)
@includeInapplicableMetadataInPayload(false)
model GalleryImage extends Resource {
  ...ResourceNameParameter<
    Resource = GalleryImage,
    KeyName = "galleryImageName",
    SegmentName = "images",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a gallery image definition.
   */
  @extension("x-ms-client-flatten", true)
  properties?: GalleryImageProperties;
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
  @parameterVisibility
  update is ArmCustomPatchAsync<GalleryImage, GalleryImageUpdate>;

  /**
   * Delete a gallery image.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<GalleryImage>;

  /**
   * List gallery image definitions in a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GalleryImages_ListByGallery")
  listByGallery is ArmResourceListByParent<GalleryImage>;
}

@@doc(GalleryImage.name,
  "The name of the gallery image definition to be retrieved."
);
@@encodedName(GalleryImages.createOrUpdate::parameters.resource,
  "application/json",
  "galleryImage"
);
@@extension(GalleryImages.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "galleryImage"
);
@@doc(GalleryImages.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery image operation."
);
@@encodedName(GalleryImages.update::parameters.properties,
  "application/json",
  "galleryImage"
);
@@extension(GalleryImages.update::parameters.properties,
  "x-ms-client-name",
  "galleryImage"
);
@@doc(GalleryImages.update::parameters.properties,
  "Parameters supplied to the update gallery image operation."
);
