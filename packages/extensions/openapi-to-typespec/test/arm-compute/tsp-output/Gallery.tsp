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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model Gallery extends Resource {
  ...ResourceNameParameter<
    Resource = Gallery,
    KeyName = "galleryName",
    SegmentName = "galleries",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a Shared Image Gallery.
   */
  @extension("x-ms-client-flatten", true)
  properties?: GalleryProperties;
}

@armResourceOperations
interface Galleries {
  /**
   * Retrieves information about a Shared Image Gallery.
   */
  get is ArmResourceRead<
    Gallery,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Gallery>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Galleries_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<Gallery>;

  /**
   * List galleries under a subscription.
   */
  list is ArmListBySubscription<Gallery>;

  /**
   * Update sharing profile of a gallery.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GallerySharingProfile_Update")
  update is ArmResourceActionAsync<Gallery, SharingUpdate, SharingUpdate>;
}

@@doc(Gallery.name, "The name of the Shared Image Gallery.");
@@encodedName(Galleries.createOrUpdate::parameters.resource,
  "application/json",
  "gallery"
);
@@extension(Galleries.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "gallery"
);
@@doc(Galleries.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update Shared Image Gallery operation."
);
@@encodedName(Galleries.update::parameters.properties,
  "application/json",
  "gallery"
);
@@extension(Galleries.update::parameters.properties,
  "x-ms-client-name",
  "gallery"
);
@@doc(Galleries.update::parameters.properties,
  "Parameters supplied to the update Shared Image Gallery operation."
);
@@encodedName(Galleries.update::parameters.body,
  "application/json",
  "sharingUpdate"
);
@@extension(Galleries.update::parameters.body,
  "x-ms-client-name",
  "sharingUpdate"
);
@@doc(Galleries.update::parameters.body,
  "Parameters supplied to the update gallery sharing profile."
);
