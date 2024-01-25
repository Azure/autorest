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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Registry)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(CodeContainer)
model CodeContainerResource extends ProxyResourceBase {
  /**
   * Container name.
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("codeName")
  @segment("codes")
  @visibility("read")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: CodeContainer;
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
