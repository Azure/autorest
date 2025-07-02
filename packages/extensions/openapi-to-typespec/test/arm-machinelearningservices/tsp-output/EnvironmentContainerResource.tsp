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
model EnvironmentContainerResource
  is Azure.ResourceManager.ProxyResource<EnvironmentContainer, false> {
  ...ResourceNameParameter<
    Resource = EnvironmentContainerResource,
    KeyName = "environmentName",
    SegmentName = "environments",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;
}

@armResourceOperations
interface EnvironmentContainerResourceOps
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
        Resource = EnvironmentContainerResource,
        KeyName = "environmentName",
        SegmentName = "environments",
        NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
      >>
    > {}

@armResourceOperations
interface EnvironmentContainerResources {
  /**
   * Get container.
   */
  get is EnvironmentContainerResourceOps.Read<EnvironmentContainerResource>;

  /**
   * Create or update container.
   */
  createOrUpdate is EnvironmentContainerResourceOps.CreateOrUpdateAsync<EnvironmentContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is EnvironmentContainerResourceOps.DeleteWithoutOkAsync<
    EnvironmentContainerResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List environment containers.
   */
  list is EnvironmentContainerResourceOps.List<
    EnvironmentContainerResource,
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
    Response = ArmResponse<EnvironmentContainerResourceArmPaginatedResult>
  >;
}
@armResourceOperations
interface EnvironmentContainerOps
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
        Resource = EnvironmentContainerResource,
        KeyName = "name",
        SegmentName = "environments",
        NamePattern = ""
      >>
    > {}

@armResourceOperations
interface EnvironmentContainers {
  /**
   * Get container.
   */
  get is EnvironmentContainerOps.Read<EnvironmentContainerResource>;

  /**
   * Create or update container.
   */
  createOrUpdate is EnvironmentContainerOps.CreateOrUpdateSync<EnvironmentContainerResource>;

  /**
   * Delete container.
   */
  delete is EnvironmentContainerOps.DeleteSync<EnvironmentContainerResource>;

  /**
   * List environment containers.
   */
  list is EnvironmentContainerOps.List<
    EnvironmentContainerResource,
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
    Response = ArmResponse<EnvironmentContainerResourceArmPaginatedResult>
  >;
}

@@doc(EnvironmentContainerResource.name,
  "Container name. This is case-sensitive."
);
@@doc(EnvironmentContainerResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
@@doc(EnvironmentContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
