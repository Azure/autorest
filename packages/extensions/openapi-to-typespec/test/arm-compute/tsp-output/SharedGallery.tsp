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
// FIXME: SharedGallery has no properties property
/**
 * Specifies information about the Shared Gallery that you want to create or update.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@parentResource(SubscriptionLocationResource)
@includeInapplicableMetadataInPayload(false)
model SharedGallery extends PirSharedGalleryResource {
  ...ResourceNameParameter<
    Resource = SharedGallery,
    KeyName = "galleryUniqueName",
    SegmentName = "sharedGalleries",
    NamePattern = ""
  >;

  @extension("x-ms-client-flatten", true)
  @visibility("read,create")
  properties?: {};
}

@armResourceOperations
interface SharedGalleries {
  /**
   * Get a shared gallery by subscription id or tenant id.
   */
  get is ArmResourceRead<SharedGallery>;

  /**
   * List shared galleries by subscription id or tenant id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SharedGalleries_List")
  list is ArmResourceListByParent<
    SharedGallery,
    {
      ...Azure.ResourceManager.Foundations.SubscriptionBaseParameters;

      /**
       * The query parameter to decide what shared galleries to fetch when doing listing operations.
       */
      @query("sharedTo")
      sharedTo?: SharedToValues;
    }
  >;
}

@@doc(SharedGallery.name, "The unique name of the Shared Gallery.");
