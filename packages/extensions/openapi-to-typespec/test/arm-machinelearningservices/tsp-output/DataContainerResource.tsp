import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Registry.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(Registry)
model DataContainerResource is ProxyResource<DataContainer> {
  @doc("Container name.")
  @path
  @key("name")
  @segment("data")
  name: string;
}

@armResourceOperations
interface DataContainerResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get container.")
  @operationId("RegistryDataContainers_Get")
  get is ArmResourceRead<DataContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update container.")
  @operationId("RegistryDataContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<DataContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete container.")
  @operationId("RegistryDataContainers_Delete")
  delete is ArmResourceDeleteAsync<
    DataContainerResource,
    BaseParameters<DataContainerResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List Data containers.")
  @operationId("RegistryDataContainers_List")
  list is ArmResourceListByParent<
    DataContainerResource,
    {
      ...BaseParameters<DataContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}
