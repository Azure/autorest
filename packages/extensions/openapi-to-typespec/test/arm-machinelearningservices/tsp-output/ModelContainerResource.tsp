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
model ModelContainerResource is ProxyResource<ModelContainer> {
  @doc("Container name. This is case-sensitive.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("modelName")
  @segment("models")
  name: string;
}

@armResourceOperations
interface ModelContainerResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get container.")
  @operationId("RegistryModelContainers_Get")
  get is ArmResourceRead<ModelContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update model container.")
  @operationId("RegistryModelContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ModelContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete container.")
  @operationId("RegistryModelContainers_Delete")
  delete is ArmResourceDeleteAsync<
    ModelContainerResource,
    BaseParameters<ModelContainerResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List model containers.")
  @operationId("RegistryModelContainers_List")
  list is ArmResourceListByParent<
    ModelContainerResource,
    {
      ...BaseParameters<ModelContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}

@@projectedName(ModelContainerResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(ModelContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(ModelContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
