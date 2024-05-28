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
 * Specifies information about the gallery Application Definition that you want to create or update.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Gallery)
@includeInapplicableMetadataInPayload(false)
model GalleryApplication extends Resource {
  ...ResourceNameParameter<
    Resource = GalleryApplication,
    KeyName = "galleryApplicationName",
    SegmentName = "applications",
    NamePattern = ""
  >;

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
  @parameterVisibility
  update is ArmCustomPatchAsync<GalleryApplication, GalleryApplicationUpdate>;

  /**
   * Delete a gallery Application.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<GalleryApplication>;

  /**
   * List gallery Application Definitions in a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GalleryApplications_ListByGallery")
  listByGallery is ArmResourceListByParent<GalleryApplication>;
}

@@doc(GalleryApplication.name,
  "The name of the gallery Application Definition to be retrieved."
);
@@encodedName(GalleryApplications.createOrUpdate::parameters.resource,
  "application/json",
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
  "application/json",
  "galleryApplication"
);
@@extension(GalleryApplications.update::parameters.properties,
  "x-ms-client-name",
  "galleryApplication"
);
@@doc(GalleryApplications.update::parameters.properties,
  "Parameters supplied to the update gallery Application operation."
);
