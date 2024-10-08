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
@parentResource(Gallery)
model GalleryApplication
  is Azure.ResourceManager.TrackedResource<GalleryApplicationProperties> {
  ...ResourceNameParameter<
    Resource = GalleryApplication,
    KeyName = "galleryApplicationName",
    SegmentName = "applications",
    NamePattern = ""
  >;
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
  listByGallery is ArmResourceListByParent<GalleryApplication>;
}

@@doc(GalleryApplication.name,
  "The name of the gallery Application Definition to be retrieved."
);
@@doc(GalleryApplication.properties,
  "Describes the properties of a gallery Application Definition."
);
@@doc(GalleryApplications.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery Application operation."
);
@@doc(GalleryApplications.update::parameters.properties,
  "Parameters supplied to the update gallery Application operation."
);
