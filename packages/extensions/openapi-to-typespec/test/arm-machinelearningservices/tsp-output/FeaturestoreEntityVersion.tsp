import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./FeaturestoreEntityContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(FeaturestoreEntityContainer)
model FeaturestoreEntityVersion
  is ProxyResource<FeaturestoreEntityVersionProperties> {
  @doc("Version identifier. This is case-sensitive.")
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface FeaturestoreEntityVersions {
  @doc("Get version.")
  get is ArmResourceRead<FeaturestoreEntityVersion>;
  @doc("Create or update version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<FeaturestoreEntityVersion>;
  @doc("Delete version.")
  delete is ArmResourceDeleteAsync<FeaturestoreEntityVersion>;
  @doc("List versions.")
  list is ArmResourceListByParent<
    FeaturestoreEntityVersion,
    {
      ...BaseParameters<FeaturestoreEntityVersion>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("tags")
      tags?: string;

      @doc("[ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("page size")
      @query("pageSize")
      pageSize?: int32 = 20;

      @doc("name for the featurestore entity version")
      @query("versionName")
      versionName?: string;

      @doc("description for the feature entity version")
      @query("description")
      description?: string;

      @doc("createdBy user name")
      @query("createdBy")
      createdBy?: string;

      @doc("Specifies the featurestore stage")
      @query("stage")
      stage?: string;
    }
  >;
}
