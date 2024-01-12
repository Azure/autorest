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
model EnvironmentContainerResource is ProxyResource<EnvironmentContainer> {
  @doc("Container name. This is case-sensitive.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("environmentName")
  @segment("environments")
  name: string;
}

@armResourceOperations
interface EnvironmentContainerResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get container.")
  @operationId("RegistryEnvironmentContainers_Get")
  get is ArmResourceRead<EnvironmentContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update container.")
  @operationId("RegistryEnvironmentContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<EnvironmentContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete container.")
  @operationId("RegistryEnvironmentContainers_Delete")
  delete is ArmResourceDeleteAsync<
    EnvironmentContainerResource,
    BaseParameters<EnvironmentContainerResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List environment containers.")
  @operationId("RegistryEnvironmentContainers_List")
  list is ArmResourceListByParent<
    EnvironmentContainerResource,
    {
      ...BaseParameters<EnvironmentContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}

@@projectedName(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
