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

namespace Azure.ResourceManager.AgFoodPlatform;
/**
 * DataManagerForAgriculture extension resource.
 */
@tenantResource
model DataManagerForAgricultureExtension
  is ProxyResource<DataManagerForAgricultureExtensionProperties> {
  /**
   * dataManagerForAgricultureExtensionId to be queried.
   */
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  @path
  @key("dataManagerForAgricultureExtensionId")
  @segment("farmBeatsExtensionDefinitions")
  name: string;
}

@armResourceOperations
interface DataManagerForAgricultureExtensions {
  /**
   * Get Data Manager For Agriculture extension.
   */
  get is ArmResourceRead<DataManagerForAgricultureExtension>;

  /**
   * Get list of Data Manager For Agriculture extension.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataManagerForAgricultureExtensions_List")
  list is ArmResourceListByParent<
    DataManagerForAgricultureExtension,
    {
      ...BaseParameters<DataManagerForAgricultureExtension>;

      /**
       * DataManagerForAgricultureExtension ids.
       */
      @query({
        name: "farmBeatsExtensionIds",
        format: "multi",
      })
      farmBeatsExtensionIds?: string[];

      /**
       * DataManagerForAgriculture extension names.
       */
      @query({
        name: "farmBeatsExtensionNames",
        format: "multi",
      })
      farmBeatsExtensionNames?: string[];

      /**
       * Extension categories.
       */
      @query({
        name: "extensionCategories",
        format: "multi",
      })
      extensionCategories?: string[];

      /**
       * Publisher ids.
       */
      @query({
        name: "publisherIds",
        format: "multi",
      })
      publisherIds?: string[];

      /**
* Maximum number of items needed (inclusive).
Minimum = 10, Maximum = 1000, Default value = 50.
*/
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;
    }
  >;
}
