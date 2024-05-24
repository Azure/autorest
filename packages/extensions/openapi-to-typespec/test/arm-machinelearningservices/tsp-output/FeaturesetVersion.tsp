import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./FeaturesetContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(FeaturesetContainer)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(FeaturesetVersionProperties)
model FeaturesetVersion extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = FeaturesetVersion,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: FeaturesetVersionProperties;
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
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<FeaturesetVersion>;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FeaturesetVersions_List")
  list is ArmResourceListByParent<
    FeaturesetVersion,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FeaturesetVersion>;

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
    FeaturesetJob
  >;

  /**
   * List materialization Jobs.
   */
  listMaterializationJobs is ArmResourceActionSync<
    FeaturesetVersion,
    void,
    FeaturesetJobArmPaginatedResult,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FeaturesetVersion>;

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

@@doc(FeaturesetVersion.name, "Version identifier. This is case-sensitive.");
@@encodedName(FeaturesetVersions.createOrUpdate::parameters.resource,
  "application/json",
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
