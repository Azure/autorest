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
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Registry)
model CodeContainerResource is ProxyResource<CodeContainer> {
  /**
   * Container name.
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("codeName")
  @segment("codes")
  name: string;
}

@armResourceOperations
interface CodeContainerResources {
  /**
   * Get Code container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeContainers_Get")
  get is ArmResourceRead<CodeContainerResource>;

  /**
   * Create or update Code container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CodeContainerResource>;

  /**
   * Delete Code container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeContainers_Delete")
  delete is ArmResourceDeleteAsync<
    CodeContainerResource,
    BaseParameters<CodeContainerResource>,
    ArmLroLocationHeader
  >;

  /**
   * List containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeContainers_List")
  list is ArmResourceListByParent<
    CodeContainerResource,
    {
      ...BaseParameters<CodeContainerResource>;

      /**
       * Continuation token for pagination.
       */
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
