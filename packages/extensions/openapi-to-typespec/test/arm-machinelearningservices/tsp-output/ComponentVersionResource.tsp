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
        ...KeysOf<ResourceNameParameter<
          Resource = Registry,
          KeyName = "registryName",
          SegmentName = "registries",
          NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$"
        >>,
        ...KeysOf<ResourceNameParameter<
          Resource = ComponentContainerResource,
          KeyName = "componentName",
          SegmentName = "components",
          NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = ComponentVersionResource,
        KeyName = "version",
        SegmentName = "versions",
        NamePattern = ""
      >>
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
        ...KeysOf<ResourceNameParameter<
          Resource = Workspace,
          KeyName = "workspaceName",
          SegmentName = "workspaces",
          NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$"
        >>,
        ...KeysOf<ResourceNameParameter<
          Resource = ComponentContainerResource,
          KeyName = "name",
          SegmentName = "components",
          NamePattern = ""
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = ComponentVersionResource,
        KeyName = "version",
        SegmentName = "versions",
        NamePattern = ""
      >>
    > {}

@armResourceOperations
interface ComponentVersions {
  /**
   * Get version.
   */
  get is ComponentVersionOps.Read<ComponentVersionResource>;

  /**
   * Create or update version.
   */
  createOrUpdate is ComponentVersionOps.CreateOrUpdateSync<ComponentVersionResource>;

  /**
   * Delete version.
   */
  delete is ComponentVersionOps.DeleteSync<ComponentVersionResource>;

  /**
   * List component versions.
   */
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
