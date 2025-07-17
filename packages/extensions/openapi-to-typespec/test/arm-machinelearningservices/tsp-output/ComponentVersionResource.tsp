import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ComponentContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(ComponentContainerResource)
model ComponentVersionResource
  is Azure.ResourceManager.ProxyResource<ComponentVersion, false> {
  ...ResourceNameParameter<
    Resource = ComponentVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface ComponentVersionResourceOps
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

        /** Container name. */
        @path
        @segment("components")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
        componentName: string,
      },
      {
        /** Version identifier. */
        @path
        @segment("versions")
        @key
        version: string,
      }
    > {}

@armResourceOperations
interface ComponentVersionResources {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryComponentVersions_Get")
  get is ComponentVersionResourceOps.Read<ComponentVersionResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryComponentVersions_CreateOrUpdate")
  createOrUpdate is ComponentVersionResourceOps.CreateOrUpdateAsync<ComponentVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("RegistryComponentVersions_Delete")
  delete is ComponentVersionResourceOps.DeleteWithoutOkAsync<
    ComponentVersionResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryComponentVersions_List")
  list is ComponentVersionResourceOps.List<
    ComponentVersionResource,
    Parameters = {
      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Maximum number of records to return.
       */
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Component stage.
       */
      @query("stage")
      stage?: string;
    },
    Response = ArmResponse<ComponentVersionResourceArmPaginatedResult>
  >;
}
@armResourceOperations
interface ComponentVersionOps
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

        /** Container name. */
        @path
        @segment("components")
        @key
        name: string,
      },
      {
        /** Version identifier. */
        @path
        @segment("versions")
        @key
        version: string,
      }
    > {}

@armResourceOperations
interface ComponentVersions {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ComponentVersions_Get")
  get is ComponentVersionOps.Read<ComponentVersionResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ComponentVersions_CreateOrUpdate")
  createOrUpdate is ComponentVersionOps.CreateOrUpdateSync<ComponentVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ComponentVersions_Delete")
  delete is ComponentVersionOps.DeleteSync<ComponentVersionResource>;

  /**
   * List component versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ComponentVersions_List")
  list is ComponentVersionOps.List<
    ComponentVersionResource,
    Parameters = {
      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Maximum number of records to return.
       */
      @query("$top")
      $top?: int32;

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

      /**
       * Component stage.
       */
      @query("stage")
      stage?: string;
    },
    Response = ArmResponse<ComponentVersionResourceArmPaginatedResult>
  >;
}

@@doc(ComponentVersionResource.name, "Version identifier.");
@@doc(ComponentVersionResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(ComponentVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(ComponentVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
