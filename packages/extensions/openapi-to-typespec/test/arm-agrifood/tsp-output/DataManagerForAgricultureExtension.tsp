import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AgFoodPlatform;
/**
 * DataManagerForAgriculture extension resource.
 */
@tenantResource
model DataManagerForAgricultureExtension
  is Azure.ResourceManager.ProxyResource<DataManagerForAgricultureExtensionProperties> {
  ...ResourceNameParameter<
    Resource = DataManagerForAgricultureExtension,
    KeyName = "dataManagerForAgricultureExtensionId",
    SegmentName = "farmBeatsExtensionDefinitions",
    NamePattern = "^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$"
  >;
}

@armResourceOperations
interface DataManagerForAgricultureExtensions {
  /**
   * Get Data Manager For Agriculture extension.
   */
  get is ArmResourceRead<
    DataManagerForAgricultureExtension,
    Azure.ResourceManager.Foundations.TenantBaseParameters
  >;

  /**
   * Get list of Data Manager For Agriculture extension.
   */
  list is ArmResourceListByParent<
    DataManagerForAgricultureExtension,
    Azure.ResourceManager.Foundations.TenantBaseParameters,
    Parameters = {
      /**
       * DataManagerForAgricultureExtension ids.
       */
      @query(#{ name: "farmBeatsExtensionIds", explode: true })
      farmBeatsExtensionIds?: string[];

      /**
       * DataManagerForAgriculture extension names.
       */
      @query(#{ name: "farmBeatsExtensionNames", explode: true })
      farmBeatsExtensionNames?: string[];

      /**
       * Extension categories.
       */
      @query(#{ name: "extensionCategories", explode: true })
      extensionCategories?: string[];

      /**
       * Publisher ids.
       */
      @query(#{ name: "publisherIds", explode: true })
      publisherIds?: string[];

      /**
       * Maximum number of items needed (inclusive).
       * Minimum = 10, Maximum = 1000, Default value = 50.
       */
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;
    }
  >;
}

@@doc(DataManagerForAgricultureExtension.name,
  "dataManagerForAgricultureExtensionId to be queried."
);
@@doc(DataManagerForAgricultureExtension.properties,
  "DataManagerForAgricultureExtension properties."
);
