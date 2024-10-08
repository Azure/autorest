import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the Shared Image Gallery that you want to create or update.
 */
model Gallery is Azure.ResourceManager.TrackedResource<GalleryProperties> {
  ...ResourceNameParameter<
    Resource = Gallery,
    KeyName = "galleryName",
    SegmentName = "galleries",
    NamePattern = ""
  >;
}

@armResourceOperations
interface Galleries {
  /**
   * Retrieves information about a Shared Image Gallery.
   */
  get is ArmResourceRead<
    Gallery,
    Parameters = {
      /**
       * The select expression to apply on the operation.
       */
      @query("$select")
      $select?: SelectPermissions;

      /**
       * The expand query option to apply on the operation.
       */
      @query("$expand")
      $expand?: GalleryExpandParams;
    }
  >;

  /**
   * Create or update a Shared Image Gallery.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Gallery>;

  /**
   * Update a Shared Image Gallery.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<Gallery, GalleryUpdate>;

  /**
   * Delete a Shared Image Gallery.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<Gallery>;

  /**
   * List galleries under a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<Gallery>;

  /**
   * List galleries under a subscription.
   */
  list is ArmListBySubscription<Gallery>;

  /**
   * Update sharing profile of a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GallerySharingProfile_Update")
  gallerySharingProfileUpdate is ArmResourceActionAsync<
    Gallery,
    SharingUpdate,
    SharingUpdate
  >;
}

@@doc(Gallery.name, "The name of the Shared Image Gallery.");
@@doc(Gallery.properties,
  "Describes the properties of a Shared Image Gallery."
);
@@doc(Galleries.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update Shared Image Gallery operation."
);
@@doc(Galleries.update::parameters.properties,
  "Parameters supplied to the update Shared Image Gallery operation."
);
@@doc(Galleries.gallerySharingProfileUpdate::parameters.body,
  "Parameters supplied to the update gallery sharing profile."
);
