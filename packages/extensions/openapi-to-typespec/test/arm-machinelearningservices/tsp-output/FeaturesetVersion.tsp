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
/** Azure Resource Manager resource envelope. */
@parentResource(FeaturesetContainer)
model FeaturesetVersion
  is Azure.ResourceManager.ProxyResource<FeaturesetVersionProperties, false> {
  ...ResourceNameParameter<
    Resource = FeaturesetVersion,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface FeaturesetVersions {
  /** Get version. */
  get is ArmResourceRead<FeaturesetVersion>;

  /** Create or update version. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<FeaturesetVersion>;

  /** Delete version. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    FeaturesetVersion,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /** List versions. */
  list is ArmResourceListByParent<
    FeaturesetVersion,
    Parameters = {
      /** Continuation token for pagination. */
      @query("$skip")
      $skip?: string;

      /** Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2 */
      @query("tags")
      tags?: string;

      /** [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities. */
      @query("listViewType")
      listViewType?: ListViewType;

      /** page size */
      @query("pageSize")
      pageSize?: int32 = 20;

      /** name for the featureset version */
      @query("versionName")
      versionName?: string;

      /** description for the feature set version */
      @query("description")
      description?: string;

      /** createdBy user name */
      @query("createdBy")
      createdBy?: string;

      /** Specifies the featurestore stage */
      @query("stage")
      stage?: string;
    },
    Response = ArmResponse<FeaturesetVersionResourceArmPaginatedResult>
  >;

  /** Backfill. */
  backfill is ArmResourceActionAsync<
    FeaturesetVersion,
    FeaturesetVersionBackfillRequest,
    ArmResponse<FeaturesetJob>
  >;

  /** List materialization Jobs. */
  @list
  listMaterializationJobs is ArmResourceActionSync<
    FeaturesetVersion,
    void,
    ArmResponse<FeaturesetJobArmPaginatedResult>,
    Parameters = {
      /** Continuation token for pagination. */
      @query("$skip")
      $skip?: string;

      /** Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2 */
      @query("filters")
      filters?: string;

      /** Start time of the feature window to filter materialization jobs. */
      @query("featureWindowStart")
      featureWindowStart?: string;

      /** End time of the feature window to filter materialization jobs. */
      @query("featureWindowEnd")
      featureWindowEnd?: string;
    }
  >;
}

@@doc(FeaturesetVersion.name, "Version identifier. This is case-sensitive.");
@@doc(FeaturesetVersion.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(FeaturesetVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(FeaturesetVersions.backfill::parameters.body,
  "Feature set version backfill request entity."
);
