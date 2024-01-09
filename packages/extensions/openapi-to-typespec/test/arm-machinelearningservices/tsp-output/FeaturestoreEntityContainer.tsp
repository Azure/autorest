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
model FeaturestoreEntityContainer
  is ProxyResource<FeaturestoreEntityContainerProperties> {
  @doc("Container name. This is case-sensitive.")
  @key("name")
  @segment("featurestoreEntities")
  name: string;
}

@armResourceOperations
interface FeaturestoreEntityContainers {
  @doc("Get container.")
  getEntity is ArmResourceRead<FeaturestoreEntityContainer>;

  @doc("Create or update container.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<FeaturestoreEntityContainer>;

  @doc("Delete container.")
  delete is ArmResourceDeleteAsync<FeaturestoreEntityContainer>;

  @doc("List featurestore entity containers.")
  list is ArmResourceListByParent<
    FeaturestoreEntityContainer,
    {
      ...BaseParameters<FeaturestoreEntityContainer>;

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

      @doc("description for the featurestore entity")
      @query("description")
      description?: string;

      @doc("createdBy user name")
      @query("createdBy")
      createdBy?: string;
    }
  >;
}
