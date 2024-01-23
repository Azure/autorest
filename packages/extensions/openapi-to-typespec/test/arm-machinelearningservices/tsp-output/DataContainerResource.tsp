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
@Azure.ResourceManager.Private.armResourceInternal(DataContainer)
@includeInapplicableMetadataInPayload(false)
model DataContainerResource extends ProxyResourceBase {
  /**
   * Container name.
   */
  @path
  @key("name")
  @segment("data")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: DataContainer;
}

@armResourceOperations
interface DataContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataContainers_Get")
  get is ArmResourceRead<DataContainerResource>;

  /**
   * Create or update container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DataContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataContainers_Delete")
  delete is ArmResourceDeleteAsync<
    DataContainerResource,
    BaseParameters<DataContainerResource>,
    ArmLroLocationHeader
  >;

  /**
   * List Data containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataContainers_List")
  list is ArmResourceListByParent<
    DataContainerResource,
    {
      ...BaseParameters<DataContainerResource>;

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

@@projectedName(DataContainerResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(DataContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(DataContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
