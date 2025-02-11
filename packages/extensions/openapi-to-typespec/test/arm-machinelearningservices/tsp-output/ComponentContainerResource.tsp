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
model ComponentContainerResource
  is Azure.ResourceManager.ProxyResource<ComponentContainer, false> {
  ...ResourceNameParameter<
    Resource = ComponentContainerResource,
    KeyName = "componentName",
    SegmentName = "components",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;
}

@armResourceOperations
interface ComponentContainerResourceOps
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
        Resource = ComponentContainerResource,
        KeyName = "componentName",
        SegmentName = "components",
        NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
      >>
    > {}

@armResourceOperations
interface ComponentContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryComponentContainers_Get")
  get is ComponentContainerResourceOps.Read<ComponentContainerResource>;

  /**
   * Create or update container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryComponentContainers_CreateOrUpdate")
  createOrUpdate is ComponentContainerResourceOps.CreateOrUpdateAsync<ComponentContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("RegistryComponentContainers_Delete")
  delete is ComponentContainerResourceOps.DeleteWithoutOkAsync<
    ComponentContainerResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryComponentContainers_List")
  list is ComponentContainerResourceOps.List<
    ComponentContainerResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    },
    Response = ArmResponse<ComponentContainerResourceArmPaginatedResult>
  >;
}
@armResourceOperations
interface ComponentContainerOps
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
        Resource = ComponentContainerResource,
        KeyName = "name",
        SegmentName = "components",
        NamePattern = ""
      >>
    > {}

@armResourceOperations
interface ComponentContainers {
  /**
   * Get container.
   */
  get is ComponentContainerOps.Read<ComponentContainerResource>;

  /**
   * Create or update container.
   */
  createOrUpdate is ComponentContainerOps.CreateOrUpdateSync<ComponentContainerResource>;

  /**
   * Delete container.
   */
  delete is ComponentContainerOps.DeleteSync<ComponentContainerResource>;

  /**
   * List component containers.
   */
  list is ComponentContainerOps.List<
    ComponentContainerResource,
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
    Response = ArmResponse<ComponentContainerResourceArmPaginatedResult>
  >;
}

@@doc(ComponentContainerResource.name, "Container name.");
@@doc(ComponentContainerResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(ComponentContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
@@doc(ComponentContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
