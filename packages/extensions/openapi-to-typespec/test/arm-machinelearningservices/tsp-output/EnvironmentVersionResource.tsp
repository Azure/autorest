import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./EnvironmentContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(EnvironmentContainerResource)
model EnvironmentVersionResource
  is Azure.ResourceManager.ProxyResource<EnvironmentVersion, false> {
  ...ResourceNameParameter<
    Resource = EnvironmentVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface EnvironmentVersionResourceOps
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

        /** Container name. This is case-sensitive. */
        @path
        @segment("environments")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
        environmentName: string,
      },
      {
        /** Version identifier. This is case-sensitive. */
        @path
        @segment("versions")
        @key
        version: string,
      }
    > {}

@armResourceOperations
interface EnvironmentVersionResources {
  /**
   * Get version.
   */
  get is EnvironmentVersionResourceOps.Read<EnvironmentVersionResource>;

  /**
   * Create or update version.
   */
  createOrUpdate is EnvironmentVersionResourceOps.CreateOrUpdateAsync<EnvironmentVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is EnvironmentVersionResourceOps.DeleteWithoutOkAsync<
    EnvironmentVersionResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List versions.
   */
  list is EnvironmentVersionResourceOps.List<
    EnvironmentVersionResource,
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
       * Stage for including/excluding (for example) archived entities. Takes priority over listViewType
       */
      @query("stage")
      stage?: string;
    },
    Response = ArmResponse<EnvironmentVersionResourceArmPaginatedResult>
  >;
}
@armResourceOperations
interface EnvironmentVersionOps
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

        /** Container name. This is case-sensitive. */
        @path
        @segment("environments")
        @key
        name: string,
      },
      {
        /** Version identifier. This is case-sensitive. */
        @path
        @segment("versions")
        @key
        version: string,
      }
    > {}

@armResourceOperations
interface EnvironmentVersions {
  /**
   * Get version.
   */
  get is EnvironmentVersionOps.Read<EnvironmentVersionResource>;

  /**
   * Creates or updates an EnvironmentVersion.
   */
  createOrUpdate is EnvironmentVersionOps.CreateOrUpdateSync<EnvironmentVersionResource>;

  /**
   * Delete version.
   */
  delete is EnvironmentVersionOps.DeleteSync<EnvironmentVersionResource>;

  /**
   * List versions.
   */
  list is EnvironmentVersionOps.List<
    EnvironmentVersionResource,
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
       * Stage for including/excluding (for example) archived entities. Takes priority over listViewType
       */
      @query("stage")
      stage?: string;
    },
    Response = ArmResponse<EnvironmentVersionResourceArmPaginatedResult>
  >;
}

@@doc(EnvironmentVersionResource.name,
  "Version identifier. This is case-sensitive."
);
@@doc(EnvironmentVersionResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(EnvironmentVersions.createOrUpdate::parameters.resource,
  "Definition of EnvironmentVersion."
);
