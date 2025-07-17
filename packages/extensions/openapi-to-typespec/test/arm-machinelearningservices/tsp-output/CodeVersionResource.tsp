import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CodeContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(CodeContainerResource)
model CodeVersionResource
  is Azure.ResourceManager.ProxyResource<CodeVersion, false> {
  ...ResourceNameParameter<
    Resource = CodeVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface CodeVersionResourceOps
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
        @segment("codes")
        @key
        @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
        codeName: string,
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
interface CodeVersionResources {
  /**
   * Get version.
   */
  get is CodeVersionResourceOps.Read<CodeVersionResource>;

  /**
   * Create or update version.
   */
  createOrUpdate is CodeVersionResourceOps.CreateOrUpdateAsync<CodeVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is CodeVersionResourceOps.DeleteWithoutOkAsync<
    CodeVersionResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List versions.
   */
  list is CodeVersionResourceOps.List<
    CodeVersionResource,
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
    },
    Response = ArmResponse<CodeVersionResourceArmPaginatedResult>
  >;

  /**
   * Generate a storage location and credential for the client to upload a code asset to.
   */
  @action("startPendingUpload")
  createOrGetStartPendingUpload is CodeVersionResourceOps.ActionSync<
    CodeVersionResource,
    PendingUploadRequestDto,
    ArmResponse<PendingUploadResponseDto>
  >;
}
@armResourceOperations
interface CodeVersionOps
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
        @segment("codes")
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
interface CodeVersions {
  /**
   * Get version.
   */
  get is CodeVersionOps.Read<CodeVersionResource>;

  /**
   * Create or update version.
   */
  createOrUpdate is CodeVersionOps.CreateOrUpdateSync<CodeVersionResource>;

  /**
   * Delete version.
   */
  delete is CodeVersionOps.DeleteSync<CodeVersionResource>;

  /**
   * List versions.
   */
  list is CodeVersionOps.List<
    CodeVersionResource,
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
       * If specified, return CodeVersion assets with specified content hash value, regardless of name
       */
      @query("hash")
      hash?: string;

      /**
       * Hash algorithm version when listing by hash
       */
      @query("hashVersion")
      hashVersion?: string;
    },
    Response = ArmResponse<CodeVersionResourceArmPaginatedResult>
  >;

  /**
   * Generate a storage location and credential for the client to upload a code asset to.
   */
  @action("startPendingUpload")
  createOrGetStartPendingUpload is CodeVersionOps.ActionSync<
    CodeVersionResource,
    PendingUploadRequestDto,
    ArmResponse<PendingUploadResponseDto>
  >;
}

@@doc(CodeVersionResource.name, "Version identifier.");
@@doc(CodeVersionResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(CodeVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(CodeVersionResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
@@doc(CodeVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(CodeVersions.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
