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
@doc("Azure Resource Manager resource envelope.")
@parentResource(FeaturesetContainer)
model FeaturesetVersion is ProxyResource<FeaturesetVersionProperties> {
  @doc("Version identifier. This is case-sensitive.")
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface FeaturesetVersions {
  @doc("Get version.")
  get is ArmResourceRead<FeaturesetVersion>;

  @doc("Create or update version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<FeaturesetVersion>;

  @doc("Delete version.")
  delete is ArmResourceDeleteAsync<
    FeaturesetVersion,
    BaseParameters<FeaturesetVersion>,
    ArmLroLocationHeader
  >;

  @doc("List versions.")
  list is ArmResourceListByParent<
    FeaturesetVersion,
    {
      ...BaseParameters<FeaturesetVersion>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("tags")
      tags?: string;

      @doc("[ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("page size")
      @query("pageSize")
      pageSize?: int32 = 20;

      @doc("name for the featureset version")
      @query("versionName")
      versionName?: string;

      @doc("description for the feature set version")
      @query("description")
      description?: string;

      @doc("createdBy user name")
      @query("createdBy")
      createdBy?: string;

      @doc("Specifies the featurestore stage")
      @query("stage")
      stage?: string;
    }
  >;

  @doc("Backfill.")
  backfill is ArmResourceActionAsync<
    FeaturesetVersion,
    FeaturesetVersionBackfillRequest,
    FeaturesetJob,
    BaseParameters<FeaturesetVersion>,
    ArmLroLocationHeader
  >;

  @doc("List materialization Jobs.")
  listMaterializationJobs is ArmResourceActionSync<
    FeaturesetVersion,
    void,
    FeaturesetJobArmPaginatedResult,
    {
      ...BaseParameters<FeaturesetVersion>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("filters")
      filters?: string;

      @doc("Start time of the feature window to filter materialization jobs.")
      @query("featureWindowStart")
      featureWindowStart?: string;

      @doc("End time of the feature window to filter materialization jobs.")
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
