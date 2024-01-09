import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("Extension resource.")
@parentResource(DataManagerForAgriculture)
model Extension is ProxyResource<ExtensionProperties> {
  @doc("Id of extension resource.")
  @key("extensionId")
  @segment("extensions")
  name: string;

  ...Azure.ResourceManager.EntityTag;
}

@armResourceOperations
interface Extensions {
  @doc("Get installed extension details by extension id.")
  get is ArmResourceRead<Extension>;

  @doc("Install or Update extension. Additional Api Properties are merged patch and if the extension is updated to a new version then the obsolete entries will be auto deleted from Additional Api Properties.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<Extension>;

  @doc("Uninstall extension.")
  delete is ArmResourceDeleteSync<Extension>;

  @doc("Get installed extensions details.")
  listByDataManagerForAgriculture is ArmResourceListByParent<
    Extension,
    {
      ...BaseParameters<Extension>;

      @doc("Installed extension ids.")
      @query({
        name: "extensionIds",
        format: "multi",
      })
      extensionIds?: string[];

      @doc("Installed extension categories.")
      @query({
        name: "extensionCategories",
        format: "multi",
      })
      extensionCategories?: string[];

      @doc("""
Maximum number of items needed (inclusive).
Minimum = 10, Maximum = 1000, Default value = 50.
""")
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      @doc("Skip token for getting next set of results.")
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}
