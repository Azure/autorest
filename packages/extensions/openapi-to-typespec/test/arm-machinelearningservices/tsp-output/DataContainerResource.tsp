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
model DataContainerResource
  is Azure.ResourceManager.ProxyResource<DataContainer, false> {
  ...ResourceNameParameter<
    Resource = DataContainerResource,
    KeyName = "name",
    SegmentName = "data",
    NamePattern = ""
  >;
}

@armResourceOperations
interface DataContainerResourceOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,

        /** Name of Azure Machine Learning registry. This is case-insensitive */
        @path
        @segment("registries")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$")
        registryName: string,
      },
      {
        /** Container name. */
        @path
        @segment("data")
        @key
        name: string,
      }
    > {}

@armResourceOperations
interface DataContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryDataContainers_Get")
  get is DataContainerResourceOps.Read<DataContainerResource>;

  /**
   * Create or update container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryDataContainers_CreateOrUpdate")
  createOrUpdate is DataContainerResourceOps.CreateOrUpdateAsync<DataContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("RegistryDataContainers_Delete")
  delete is DataContainerResourceOps.DeleteWithoutOkAsync<
    DataContainerResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List Data containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryDataContainers_List")
  list is DataContainerResourceOps.List<
    DataContainerResource,
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
    },
    Response = ArmResponse<DataContainerResourceArmPaginatedResult>
  >;
}
@armResourceOperations
interface DataContainerOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,

        /** Name of Azure Machine Learning workspace. */
        @path
        @segment("workspaces")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
        workspaceName: string,
      },
      {
        /** Container name. */
        @path
        @segment("data")
        @key
        name: string,
      }
    > {}

@armResourceOperations
interface DataContainers {
  /**
   * Get container.
   */
  get is DataContainerOps.Read<DataContainerResource>;

  /**
   * Create or update container.
   */
  createOrUpdate is DataContainerOps.CreateOrUpdateSync<DataContainerResource>;

  /**
   * Delete container.
   */
  delete is DataContainerOps.DeleteSync<DataContainerResource>;

  /**
   * List data containers.
   */
  list is DataContainerOps.List<
    DataContainerResource,
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
    },
    Response = ArmResponse<DataContainerResourceArmPaginatedResult>
  >;
}

@@doc(DataContainerResource.name, "Container name.");
@@doc(DataContainerResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(DataContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
@@doc(DataContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
