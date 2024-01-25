import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An image resource belonging to a catalog resource.
 */
@parentResource(Catalog)
model Image is ProxyResource<ImageProperties> {
  /**
   * Image name. Use .default for image creation.
   */
  @path
  @key("imageName")
  @segment("images")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Images {
  /**
   * Get a Image
   */
  get is ArmResourceRead<Image>;

  /**
   * Create a Image
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Image,
    BaseParameters<Image>,
    ArmAsyncOperationHeader
  >;

  /**
   * Delete a Image
   */
  delete is ArmResourceDeleteAsync<
    Image,
    BaseParameters<Image>,
    ArmLroLocationHeader
  >;

  /**
   * List Image resources by Catalog
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Images_ListByCatalog")
  listByCatalog is ArmResourceListByParent<
    Image,
    {
      ...BaseParameters<Image>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
}
