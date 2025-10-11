import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/** Azure Resource Manager resource envelope. */
@parentResource(DataContainerResource)
model DataVersionBaseResource
  is Azure.ResourceManager.ProxyResource<DataVersionBase, false> {
  ...ResourceNameParameter<
    Resource = DataVersionBaseResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

alias DataVersionBaseResourceOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** Name of Azure Machine Learning registry. This is case-insensitive */
    @path
    @segment("registries")
    @key
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$")
    registryName: string;

    /** Container name. */
    @path
    @segment("data")
    @key
    name: string;
  },
  {
    /** Version identifier. */
    @path
    @segment("versions")
    @key
    version: string;
  }
>;

@armResourceOperations
interface DataVersionBaseResources {
  /** Get version. */
  get is DataVersionBaseResourceOps.Read<DataVersionBaseResource>;

  /** Create or update version. */
  createOrUpdate is DataVersionBaseResourceOps.CreateOrUpdateAsync<DataVersionBaseResource>;

  /** Delete version. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is DataVersionBaseResourceOps.DeleteWithoutOkAsync<
    DataVersionBaseResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /** List data versions in the data container */
  list is DataVersionBaseResourceOps.List<
    DataVersionBaseResource,
    Parameters = {
      /** Please choose OrderBy value from ['createdtime', 'modifiedtime'] */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Top count of results, top count cannot be greater than the page size.
       *                               If topCount > page size, results with be default page size count will be returned
       */
      @query("$top")
      $top?: int32;

      /** Continuation token for pagination. */
      @query("$skip")
      $skip?: string;

      /** Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2 */
      @query("$tags")
      $tags?: string;

      /** [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities. */
      @query("listViewType")
      listViewType?: ListViewType;
    },
    Response = ArmResponse<DataVersionBaseResourceArmPaginatedResult>
  >;

  /** Generate a storage location and credential for the client to upload a data asset to. */
  @action("startPendingUpload")
  createOrGetStartPendingUpload is DataVersionBaseResourceOps.ActionSync<
    DataVersionBaseResource,
    PendingUploadRequestDto,
    ArmResponse<PendingUploadResponseDto>
  >;
}
alias DataVersionOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** Name of Azure Machine Learning workspace. */
    @path
    @segment("workspaces")
    @key
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    workspaceName: string;

    /** Container name. */
    @path
    @segment("data")
    @key
    name: string;
  },
  {
    /** Version identifier. */
    @path
    @segment("versions")
    @key
    version: string;
  }
>;

@armResourceOperations
interface DataVersions {
  /** Get version. */
  get is DataVersionOps.Read<DataVersionBaseResource>;

  /** Create or update version. */
  createOrUpdate is DataVersionOps.CreateOrUpdateSync<DataVersionBaseResource>;

  /** Delete version. */
  delete is DataVersionOps.DeleteSync<DataVersionBaseResource>;

  /** List data versions in the data container */
  list is DataVersionOps.List<
    DataVersionBaseResource,
    Parameters = {
      /** Please choose OrderBy value from ['createdtime', 'modifiedtime'] */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Top count of results, top count cannot be greater than the page size.
       *                               If topCount > page size, results with be default page size count will be returned
       */
      @query("$top")
      $top?: int32;

      /** Continuation token for pagination. */
      @query("$skip")
      $skip?: string;

      /** Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2 */
      @query("$tags")
      $tags?: string;

      /** [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities. */
      @query("listViewType")
      listViewType?: ListViewType;

      /** data stage */
      @query("stage")
      stage?: string;
    },
    Response = ArmResponse<DataVersionBaseResourceArmPaginatedResult>
  >;
}

@@doc(DataVersionBaseResource.name, "Version identifier.");
@@doc(DataVersionBaseResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(DataVersionBaseResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
@@doc(DataVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
