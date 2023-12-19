import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./FarmBeat.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("Extension resource.")
@parentResource(FarmBeat)
model Extension is ProxyResource<ExtensionProperties> {
  @doc("Id of extension resource.")
  @path
  @key("extensionId")
  @segment("extensions")
  name: string;

  @doc("The ETag value to implement optimistic concurrency.")
  @visibility("read")
  eTag?: string;

  ...Azure.ResourceManager.EntityTag;
}

@armResourceOperations
interface Extensions {
  @doc("Get installed extension details by extension id.")
  get is ArmResourceRead<Extension>;
  @doc("Install extension.")
  create is ArmResourceCreateOrReplaceSync<Extension>;
  // FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property
  @doc("Upgrade to latest extension.")
  update is ArmCustomPatchSync<Extension, void>;
  @doc("Uninstall extension.")
  delete is ArmResourceDeleteSync<Extension>;
  @doc("Get installed extensions details.")
  listByFarmBeats is ArmResourceListByParent<
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
      @query("$maxPageSize")
      $maxPageSize?: int32;

      @doc("Skip token for getting next set of results.")
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}
