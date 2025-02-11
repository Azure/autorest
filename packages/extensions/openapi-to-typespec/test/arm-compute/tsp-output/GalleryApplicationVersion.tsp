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
@parentResource(GalleryApplication)
model GalleryApplicationVersion
  is Azure.ResourceManager.TrackedResource<GalleryApplicationVersionProperties> {
  ...ResourceNameParameter<
    Resource = GalleryApplicationVersion,
    KeyName = "galleryApplicationVersionName",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GalleryApplicationVersions {
  /**
   * Retrieves information about a gallery Application Version.
   */
  get is ArmResourceRead<
    GalleryApplicationVersion,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    GalleryApplicationVersion,
    Response = ArmResourceUpdatedResponse<GalleryApplicationVersion> | ArmResourceCreatedResponse<
      GalleryApplicationVersion,
      ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
    > | (ArmAcceptedLroResponse & {
      @bodyRoot
      _: GalleryApplicationVersion;
    })
  >;

  /**
   * Update a gallery Application Version.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<
    GalleryApplicationVersion,
    PatchModel = GalleryApplicationVersionUpdate,
    Response = ArmResponse<GalleryApplicationVersion>
  >;

  /**
   * Delete a gallery Application Version.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    GalleryApplicationVersion,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List gallery Application Versions in a gallery Application Definition.
   */
  listByGalleryApplication is ArmResourceListByParent<
    GalleryApplicationVersion,
    Response = ArmResponse<GalleryApplicationVersionList>
  >;
}

@@doc(GalleryApplicationVersion.name,
  "The name of the gallery Application Version to be retrieved."
);
@@doc(GalleryApplicationVersion.properties,
  "Describes the properties of a gallery image version."
);
@@doc(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update gallery Application Version operation."
);
@@doc(GalleryApplicationVersions.update::parameters.properties,
  "Parameters supplied to the update gallery Application Version operation."
);
