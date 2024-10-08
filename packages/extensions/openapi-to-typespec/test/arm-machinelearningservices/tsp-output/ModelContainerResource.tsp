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
@parentResource(Registry)
model ModelContainerResource
  is Azure.ResourceManager.ProxyResource<ModelContainer, false> {
  ...ResourceNameParameter<
    Resource = ModelContainerResource,
    KeyName = "modelName",
    SegmentName = "models",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;
}

@armResourceOperations
interface ModelContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryModelContainers_Get")
  get is ArmResourceRead<ModelContainerResource>;

  /**
   * Create or update model container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryModelContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ModelContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryModelContainers_Delete")
  delete is ArmResourceDeleteAsync<ModelContainerResource>;

  /**
   * List model containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryModelContainers_List")
  list is ArmResourceListByParent<
    ModelContainerResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}

@@doc(ModelContainerResource.name, "Container name. This is case-sensitive.");
@@doc(ModelContainerResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(ModelContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
