import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GalleryApplication.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the gallery Application Version that you want to create or update.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(GalleryApplication)
@includeInapplicableMetadataInPayload(false)
model GalleryApplicationVersion extends Resource {
  ...ResourceNameParameter<
    Resource = GalleryApplicationVersion,
    KeyName = "galleryApplicationVersionName",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a gallery image version.
   */
  @extension("x-ms-client-flatten", true)
  properties?: GalleryApplicationVersionProperties;
}

@armResourceOperations
interface GalleryApplicationVersions {
  /**
   * Retrieves information about a gallery Application Version.
   */
  get is ArmResourceRead<
    GalleryApplicationVersion,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GalleryApplicationVersion>;

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
  @parameterVisibility
  update is ArmCustomPatchAsync<
    GalleryApplicationVersion,
    GalleryApplicationVersionUpdate
  >;

  /**
   * Delete a gallery Application Version.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<GalleryApplicationVersion>;

  /**
   * List gallery Application Versions in a gallery Application Definition.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GalleryApplicationVersions_ListByGalleryApplication")
  listByGalleryApplication is ArmResourceListByParent<GalleryApplicationVersion>;
}

@@doc(GalleryApplicationVersion.name,
  "The name of the gallery Application Version to be retrieved."
);
@@encodedName(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "application/json",
  "galleryApplicationVersion"
);
@@extension(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "galleryApplicationVersion"
);
@@doc(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery Application Version operation."
);
@@encodedName(GalleryApplicationVersions.update::parameters.properties,
  "application/json",
  "galleryApplicationVersion"
);
@@extension(GalleryApplicationVersions.update::parameters.properties,
  "x-ms-client-name",
  "galleryApplicationVersion"
);
@@doc(GalleryApplicationVersions.update::parameters.properties,
  "Parameters supplied to the update gallery Application Version operation."
);
