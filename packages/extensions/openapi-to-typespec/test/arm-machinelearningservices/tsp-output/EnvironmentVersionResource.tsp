import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./EnvironmentContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(EnvironmentContainerResource)
model EnvironmentVersionResource is ProxyResource<EnvironmentVersion> {
  @doc("Version identifier. This is case-sensitive.")
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
@projectedName("client", "RegistryEnvironmentVersions")
interface EnvironmentVersionResources_RegistryEnvironmentVersions {
  @doc("Get version.")
  get is ArmResourceRead<EnvironmentVersionResource>;

  @doc("Create or update version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<EnvironmentVersionResource>;

  @doc("Delete version.")
  delete is ArmResourceDeleteAsync<EnvironmentVersionResource>;

  @doc("List versions.")
  list is ArmResourceListByParent<
    EnvironmentVersionResource,
    {
      ...BaseParameters<EnvironmentVersionResource>;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("Stage for including/excluding (for example) archived entities. Takes priority over listViewType")
      @query("stage")
      stage?: string;
    }
  >;
}
