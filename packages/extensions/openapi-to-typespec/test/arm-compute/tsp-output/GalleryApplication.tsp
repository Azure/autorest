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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Gallery)
@includeInapplicableMetadataInPayload(false)
model GalleryApplication extends Resource {
  /**
   * The name of the gallery Application Definition to be retrieved.
   */
  @path
  @key("galleryApplicationName")
  @segment("applications")
  @visibility("read")
  name: string;

  /**
   * Describes the properties of a gallery Application Definition.
   */
  @extension("x-ms-client-flatten", true)
  properties?: GalleryApplicationProperties;
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

@@encodedName(GalleryApplications.createOrUpdate::parameters.resource,
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
@@encodedName(GalleryApplications.update::parameters.properties,
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
