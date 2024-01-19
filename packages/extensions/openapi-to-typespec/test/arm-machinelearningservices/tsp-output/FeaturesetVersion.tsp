import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./FeaturesetContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(FeaturesetContainer)
model FeaturesetVersion is ProxyResource<FeaturesetVersionProperties> {
  /**
   * Version identifier. This is case-sensitive.
   */
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface FeaturesetVersions {
  /**
   * Get version.
   */
  get is ArmResourceRead<FeaturesetVersion>;

  /**
   * Create or update version.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<FeaturesetVersion>;

  /**
   * Delete version.
   */
  delete is ArmResourceDeleteAsync<
    FeaturesetVersion,
    BaseParameters<FeaturesetVersion>,
    ArmLroLocationHeader
  >;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FeaturesetVersions_List")
  list is ArmResourceListByParent<
    FeaturesetVersion,
    {
      ...BaseParameters<FeaturesetVersion>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("tags")
      tags?: string;

      /**
       * [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * page size
       */
      @query("pageSize")
      pageSize?: int32 = 20;

      /**
       * name for the featureset version
       */
      @query("versionName")
      versionName?: string;

      /**
       * description for the feature set version
       */
      @query("description")
      description?: string;

      /**
       * createdBy user name
       */
      @query("createdBy")
      createdBy?: string;

      /**
       * Specifies the featurestore stage
       */
      @query("stage")
      stage?: string;
    }
  >;

  /**
   * Backfill.
   */
  backfill is ArmResourceActionAsync<
    FeaturesetVersion,
    FeaturesetVersionBackfillRequest,
    FeaturesetJob,
    BaseParameters<FeaturesetVersion>,
    ArmLroLocationHeader
  >;

  /**
   * List materialization Jobs.
   */
  listMaterializationJobs is ArmResourceActionSync<
    FeaturesetVersion,
    void,
    FeaturesetJobArmPaginatedResult,
    {
      ...BaseParameters<FeaturesetVersion>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("filters")
      filters?: string;

      /**
       * Start time of the feature window to filter materialization jobs.
       */
      @query("featureWindowStart")
      featureWindowStart?: string;

      /**
       * End time of the feature window to filter materialization jobs.
       */
      @query("featureWindowEnd")
      featureWindowEnd?: string;
    }
  >;
}

@@projectedName(FeaturesetVersions.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(FeaturesetVersions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(FeaturesetVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(FeaturesetVersions.backfill::parameters.body,
  "Feature set version backfill request entity."
);
