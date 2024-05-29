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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@tenantResource
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  DataManagerForAgricultureExtensionProperties
)
model DataManagerForAgricultureExtension extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = DataManagerForAgricultureExtension,
    KeyName = "dataManagerForAgricultureExtensionId",
    SegmentName = "farmBeatsExtensionDefinitions",
    NamePattern = "^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$"
  >;

  /**
   * DataManagerForAgricultureExtension properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: DataManagerForAgricultureExtensionProperties;
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
      ...Azure.ResourceManager.Foundations.TenantBaseParameters;

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
