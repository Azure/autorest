import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An image resource belonging to a catalog resource.
 */
@parentResource(Catalog)
model Image is Azure.ResourceManager.ProxyResource<ImageProperties> {
  ...ResourceNameParameter<
    Resource = Image,
    KeyName = "imageName",
    SegmentName = "images",
    NamePattern = ""
  >;
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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Image>;

  /**
   * Delete a Image
   */
  delete is ArmResourceDeleteAsync<Image>;

  /**
   * List Image resources by Catalog
   */
  listByCatalog is ArmResourceListByParent<
    Image,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Image>;

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

@@doc(Image.name, "Image name. Use .default for image creation.");
