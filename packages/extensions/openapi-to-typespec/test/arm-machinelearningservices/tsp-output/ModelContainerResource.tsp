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
@Azure.ResourceManager.Private.armResourceInternal(ModelContainer)
model ModelContainerResource extends ProxyResourceBase {
  /**
   * Container name. This is case-sensitive.
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("modelName")
  @segment("models")
  @visibility("read")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: ModelContainer;
}

@armResourceOperations
interface ModelContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelContainers_Get")
  get is ArmResourceRead<ModelContainerResource>;

  /**
   * Create or update model container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ModelContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelContainers_Delete")
  delete is ArmResourceDeleteAsync<ModelContainerResource>;

  /**
   * List model containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelContainers_List")
  list is ArmResourceListByParent<
    ModelContainerResource,
    {
      ...BaseParameters<ModelContainerResource>;

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

@@encodedName(ModelContainerResources.createOrUpdate::parameters.resource,
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
