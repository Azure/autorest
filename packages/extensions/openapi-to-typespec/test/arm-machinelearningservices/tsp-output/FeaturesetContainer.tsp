import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(Workspace)
model FeaturesetContainer is ProxyResource<FeaturesetContainerProperties> {
  @doc("Container name. This is case-sensitive.")
  @key("name")
  @segment("featuresets")
  name: string;
}

@armResourceOperations
interface FeaturesetContainers {
  @doc("Get container.")
  getEntity is ArmResourceRead<FeaturesetContainer>;

  @doc("Create or update container.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<FeaturesetContainer>;

  @doc("Delete container.")
  delete is ArmResourceDeleteAsync<FeaturesetContainer>;

  @doc("List featurestore entity containers.")
  list is ArmResourceListByParent<
    FeaturesetContainer,
    {
      ...BaseParameters<FeaturesetContainer>;

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

      @doc("description for the feature set")
      @query("description")
      description?: string;

      @doc("createdBy user name")
      @query("createdBy")
      createdBy?: string;
    }
  >;
}
