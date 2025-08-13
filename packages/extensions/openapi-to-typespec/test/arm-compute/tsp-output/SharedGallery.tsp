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
@subscriptionResource
model SharedGallery is Azure.ResourceManager.ProxyResource<{}> {
  ...ResourceNameParameter<
    Resource = SharedGallery,
    KeyName = "galleryUniqueName",
    SegmentName = "sharedGalleries",
    NamePattern = ""
  >;
}

@armResourceOperations
interface SharedGalleries {
  /**
   * Get a shared gallery by subscription id or tenant id.
   */
  get is ArmResourceRead<
    SharedGallery,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * List shared galleries by subscription id or tenant id.
   */
  list is ArmResourceListByParent<
    SharedGallery,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters,
    Parameters = {
      /**
       * The query parameter to decide what shared galleries to fetch when doing listing operations.
       */
      @query("sharedTo")
      sharedTo?: SharedToValues;
    },
    Response = ArmResponse<SharedGalleryList>
  >;
}

@@doc(SharedGallery.name, "The unique name of the Shared Gallery.");
