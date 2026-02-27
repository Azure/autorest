import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AgFoodPlatform;
/** DataManagerForAgriculture extension resource. */
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
  /** Get Data Manager For Agriculture extension. */
  get is ArmResourceRead<
    DataManagerForAgricultureExtension,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters
  >;

  /** Get list of Data Manager For Agriculture extension. */
  list is ArmResourceListByParent<
    DataManagerForAgricultureExtension,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    Parameters = {
      /** DataManagerForAgricultureExtension ids. */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "farmBeatsExtensionIds", explode: true })
      farmBeatsExtensionIds?: string[];

      /** DataManagerForAgriculture extension names. */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "farmBeatsExtensionNames", explode: true })
      farmBeatsExtensionNames?: string[];

      /** Extension categories. */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "extensionCategories", explode: true })
      extensionCategories?: string[];

      /** Publisher ids. */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
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
    },
    Response = ArmResponse<DataManagerForAgricultureExtensionListResponse>
  >;
}

@@doc(DataManagerForAgricultureExtension.name,
  "dataManagerForAgricultureExtensionId to be queried."
);
@@doc(DataManagerForAgricultureExtension.properties,
  "DataManagerForAgricultureExtension properties."
);
