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

        /** Name of Azure Machine Learning registry. This is case-insensitive */
        @path
        @segment("registries")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$")
        registryName: string,
      },
      {
        /** Container name. This is case-sensitive. */
        @path
        @segment("environments")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
        environmentName: string,
      }
    > {}

@armResourceOperations
interface EnvironmentContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryEnvironmentContainers_Get")
  get is EnvironmentContainerResourceOps.Read<EnvironmentContainerResource>;

  /**
   * Create or update container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryEnvironmentContainers_CreateOrUpdate")
  createOrUpdate is EnvironmentContainerResourceOps.CreateOrUpdateAsync<EnvironmentContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("RegistryEnvironmentContainers_Delete")
  delete is EnvironmentContainerResourceOps.DeleteWithoutOkAsync<
    EnvironmentContainerResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List environment containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryEnvironmentContainers_List")
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

        /** Name of Azure Machine Learning workspace. */
        @path
        @segment("workspaces")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
        workspaceName: string,
      },
      {
        /** Container name. This is case-sensitive. */
        @path
        @segment("environments")
        @key
        name: string,
      }
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
