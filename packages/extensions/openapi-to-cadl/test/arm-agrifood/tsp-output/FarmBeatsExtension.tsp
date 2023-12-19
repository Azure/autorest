import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("FarmBeats extension resource.")
@tenantResource
model FarmBeatsExtension is ProxyResource<FarmBeatsExtensionProperties> {
  @doc("farmBeatsExtensionId to be queried.")
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  @path
  @key("farmBeatsExtensionId")
  @segment("farmBeatsExtensionDefinitions")
  name: string;
}

@armResourceOperations
interface FarmBeatsExtensions {
  @doc("Get farmBeats extension.")
  get is ArmResourceRead<FarmBeatsExtension>;
  @doc("Get list of farmBeats extension.")
  list is ArmResourceListByParent<
    FarmBeatsExtension,
    {
      ...BaseParameters<FarmBeatsExtension>;

      @doc("FarmBeatsExtension ids.")
      @query({
        name: "farmBeatsExtensionIds",
        format: "multi",
      })
      farmBeatsExtensionIds?: string[];

      @doc("FarmBeats extension names.")
      @query({
        name: "farmBeatsExtensionNames",
        format: "multi",
      })
      farmBeatsExtensionNames?: string[];

      @doc("Extension categories.")
      @query({
        name: "extensionCategories",
        format: "multi",
      })
      extensionCategories?: string[];

      @doc("Publisher ids.")
      @query({
        name: "publisherIds",
        format: "multi",
      })
      publisherIds?: string[];

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
