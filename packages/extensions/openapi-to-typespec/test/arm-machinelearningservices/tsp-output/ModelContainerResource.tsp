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
interface ModelContainerResourceOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = Registry,
          KeyName = "registryName",
          SegmentName = "registries",
          NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$"
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = ModelContainerResource,
        KeyName = "modelName",
        SegmentName = "models",
        NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
      >>
    > {}

@armResourceOperations
interface ModelContainerResources {
  /**
   * Get container.
   */
  get is ModelContainerResourceOps.Read<ModelContainerResource>;

  /**
   * Create or update model container.
   */
  createOrUpdate is ModelContainerResourceOps.CreateOrUpdateAsync<ModelContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ModelContainerResourceOps.DeleteWithoutOkAsync<
    ModelContainerResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List model containers.
   */
  list is ModelContainerResourceOps.List<
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
    },
    Response = ArmResponse<ModelContainerResourceArmPaginatedResult>
  >;
}
@armResourceOperations
interface ModelContainerOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = Workspace,
          KeyName = "workspaceName",
          SegmentName = "workspaces",
          NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$"
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = ModelContainerResource,
        KeyName = "name",
        SegmentName = "models",
        NamePattern = ""
      >>
    > {}

@armResourceOperations
interface ModelContainers {
  /**
   * Get container.
   */
  get is ModelContainerOps.Read<ModelContainerResource>;

  /**
   * Create or update container.
   */
  createOrUpdate is ModelContainerOps.CreateOrUpdateSync<ModelContainerResource>;

  /**
   * Delete container.
   */
  delete is ModelContainerOps.DeleteSync<ModelContainerResource>;

  /**
   * List model containers.
   */
  list is ModelContainerOps.List<
    ModelContainerResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Maximum number of results to return.
       */
      @query("count")
      count?: int32;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    },
    Response = ArmResponse<ModelContainerResourceArmPaginatedResult>
  >;
}

@@doc(ModelContainerResource.name, "Container name. This is case-sensitive.");
@@doc(ModelContainerResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(ModelContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
@@doc(ModelContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
