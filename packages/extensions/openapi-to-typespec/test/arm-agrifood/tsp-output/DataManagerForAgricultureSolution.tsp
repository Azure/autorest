import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("DataManagerForAgriculture solution resource.")
@tenantResource
model DataManagerForAgricultureSolution
  is ProxyResource<DataManagerForAgricultureSolutionProperties> {
  @doc("dataManagerForAgricultureSolutionId to be queried.")
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  @key("dataManagerForAgricultureSolutionId")
  @segment("farmBeatsSolutionDefinitions")
  name: string;
}

@armResourceOperations
interface SolutionsDiscoverability {
  @doc("Get Data Manager For Agriculture solution by id.")
  get is ArmResourceRead<DataManagerForAgricultureSolution>;
  @doc("Get list of Data Manager For Agriculture solutions.")
  list is ArmResourceListByParent<
    DataManagerForAgricultureSolution,
    {
      ...BaseParameters<DataManagerForAgricultureSolution>;

      @doc("Ids of Data Manager For Agriculture Solutions which the customer requests to fetch.")
      @query({
        name: "farmBeatsSolutionIds",
        format: "multi",
      })
      farmBeatsSolutionIds?: string[];

      @doc("Names of Data Manager For Agriculture Solutions which the customer requests to fetch.")
      @query({
        name: "farmBeatsSolutionNames",
        format: "multi",
      })
      farmBeatsSolutionNames?: string[];

      @doc("""
Maximum number of items needed (inclusive).
Minimum = 10, Maximum = 1000, Default value = 50.
""")
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;
    }
  >;
}
