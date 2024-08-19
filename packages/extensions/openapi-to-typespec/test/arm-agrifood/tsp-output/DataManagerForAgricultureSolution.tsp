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
 * DataManagerForAgriculture solution resource.
 */
@tenantResource
model DataManagerForAgricultureSolution
  is Azure.ResourceManager.ProxyResource<DataManagerForAgricultureSolutionProperties> {
  ...ResourceNameParameter<
    Resource = DataManagerForAgricultureSolution,
    KeyName = "dataManagerForAgricultureSolutionId",
    SegmentName = "farmBeatsSolutionDefinitions",
    NamePattern = "^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$"
  >;
}

@armResourceOperations
interface DataManagerForAgricultureSolutions {
  /**
   * Get Data Manager For Agriculture solution by id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SolutionsDiscoverability_Get")
  get is ArmResourceRead<DataManagerForAgricultureSolution>;

  /**
   * Get list of Data Manager For Agriculture solutions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SolutionsDiscoverability_List")
  list is ArmResourceListByParent<
    DataManagerForAgricultureSolution,
    {
      ...Azure.ResourceManager.Foundations.TenantBaseParameters;

      /**
       * Ids of Data Manager For Agriculture Solutions which the customer requests to fetch.
       */
      @query(#{ name: "farmBeatsSolutionIds", explode: true })
      farmBeatsSolutionIds?: string[];

      /**
       * Names of Data Manager For Agriculture Solutions which the customer requests to fetch.
       */
      @query(#{ name: "farmBeatsSolutionNames", explode: true })
      farmBeatsSolutionNames?: string[];

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

@@doc(DataManagerForAgricultureSolution.name,
  "dataManagerForAgricultureSolutionId to be queried."
);
@@doc(DataManagerForAgricultureSolution.properties,
  "DataManagerForAgricultureSolution properties."
);
