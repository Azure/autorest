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
@Azure.ResourceManager.Private.armResourceInternal(ComponentContainer)
@includeInapplicableMetadataInPayload(false)
model ComponentContainerResource extends ProxyResourceBase {
  /**
   * Container name.
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("componentName")
  @segment("components")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: ComponentContainer;
}

@armResourceOperations
interface ComponentContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentContainers_Get")
  get is ArmResourceRead<ComponentContainerResource>;

  /**
   * Create or update container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ComponentContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentContainers_Delete")
  delete is ArmResourceDeleteAsync<
    ComponentContainerResource,
    BaseParameters<ComponentContainerResource>,
    ArmLroLocationHeader
  >;

  /**
   * List containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentContainers_List")
  list is ArmResourceListByParent<
    ComponentContainerResource,
    {
      ...BaseParameters<ComponentContainerResource>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    }
  >;
}

@@projectedName(ComponentContainerResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(ComponentContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(ComponentContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
