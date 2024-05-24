import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Registry.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
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
@Azure.ResourceManager.Private.armResourceInternal(ComponentContainer)
model ComponentContainerResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ComponentContainerResource,
    KeyName = "componentName",
    SegmentName = "components",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;

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
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryComponentContainers_Delete")
  delete is ArmResourceDeleteAsync<ComponentContainerResource>;

  /**
   * List containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentContainers_List")
  list is ArmResourceListByParent<
    ComponentContainerResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ComponentContainerResource>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    }
  >;
}

@@doc(ComponentContainerResource.name, "Container name.");
@@encodedName(ComponentContainerResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(ComponentContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(ComponentContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
