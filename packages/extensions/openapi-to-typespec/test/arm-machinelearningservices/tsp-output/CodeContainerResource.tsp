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
model CodeContainerResource is ProxyResource<CodeContainer> {
  @doc("Container name.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("codeName")
  @segment("codes")
  name: string;
}

@armResourceOperations
interface CodeContainerResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get Code container.")
  @operationId("RegistryCodeContainers_Get")
  get is ArmResourceRead<CodeContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update Code container.")
  @operationId("RegistryCodeContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CodeContainerResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete Code container.")
  @operationId("RegistryCodeContainers_Delete")
  delete is ArmResourceDeleteAsync<
    CodeContainerResource,
    BaseParameters<CodeContainerResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List containers.")
  @operationId("RegistryCodeContainers_List")
  list is ArmResourceListByParent<
    CodeContainerResource,
    {
      ...BaseParameters<CodeContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;
}

@@projectedName(CodeContainerResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(CodeContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(CodeContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
