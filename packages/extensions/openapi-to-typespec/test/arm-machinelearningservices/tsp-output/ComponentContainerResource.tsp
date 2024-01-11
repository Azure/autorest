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
model ComponentContainerResource is ProxyResource<ComponentContainer> {
  @doc("Container name.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("componentName")
  @segment("components")
  name: string;
}

@armResourceOperations
interface ComponentContainerResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get container.")
  @operationId("RegistryComponentContainers_Get")
  get is ArmResourceRead<ComponentContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update container.")
  @operationId("RegistryComponentContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ComponentContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete container.")
  @operationId("RegistryComponentContainers_Delete")
  delete is ArmResourceDeleteAsync<
    ComponentContainerResource,
    BaseParameters<ComponentContainerResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List containers.")
  @operationId("RegistryComponentContainers_List")
  list is ArmResourceListByParent<
    ComponentContainerResource,
    {
      ...BaseParameters<ComponentContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;
}
