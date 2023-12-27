import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ComponentContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(ComponentContainerResource)
model ComponentVersionResource is ProxyResource<ComponentVersion> {
  @doc("Version identifier.")
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface RegistryComponentVersions {
  @doc("Get version.")
  get is ArmResourceRead<ComponentVersionResource>;
  @doc("Create or update version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ComponentVersionResource>;
  @doc("Delete version.")
  delete is ArmResourceDeleteAsync<ComponentVersionResource>;
  @doc("List versions.")
  list is ArmResourceListByParent<
    ComponentVersionResource,
    {
      ...BaseParameters<ComponentVersionResource>;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Component stage.")
      @query("stage")
      stage?: string;
    }
  >;
}
