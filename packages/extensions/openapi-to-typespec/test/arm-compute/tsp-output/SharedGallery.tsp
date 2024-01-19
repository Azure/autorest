import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
// FIXME: SharedGallery has no properties property
/**
 * Specifies information about the Shared Gallery that you want to create or update.
 */
@locationResource
model SharedGallery is ProxyResource<{}> {
  /**
   * The unique name of the Shared Gallery.
   */
  @path
  @key("galleryUniqueName")
  @segment("sharedGalleries")
  name: string;
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
      ...BaseParameters<SharedGallery>;

      /**
       * The query parameter to decide what shared galleries to fetch when doing listing operations.
       */
      @query("sharedTo")
      sharedTo?: SharedToValues;
    }
  >;
}
