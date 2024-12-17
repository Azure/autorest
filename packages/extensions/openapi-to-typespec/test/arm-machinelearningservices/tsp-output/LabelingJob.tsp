import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Workspace)
model LabelingJob
  is Azure.ResourceManager.ProxyResource<LabelingJobProperties, false> {
  ...ResourceNameParameter<
    Resource = LabelingJob,
    KeyName = "id",
    SegmentName = "labelingJobs",
    NamePattern = ""
  >;
}

@armResourceOperations
interface LabelingJobs {
  /**
   * Gets a labeling job by name/id.
   */
  get is ArmResourceRead<
    LabelingJob,
    Parameters = {
      /**
       * Boolean value to indicate whether to include JobInstructions in response.
       */
      @query("includeJobInstructions")
      includeJobInstructions?: boolean;

      /**
       * Boolean value to indicate Whether to include LabelCategories in response.
       */
      @query("includeLabelCategories")
      includeLabelCategories?: boolean;
    }
  >;

  /**
   * Creates or updates a labeling job (asynchronous).
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<LabelingJob>;

  /**
   * Delete a labeling job.
   */
  delete is ArmResourceDeleteSync<LabelingJob>;

  /**
   * Lists labeling jobs in the workspace.
   */
  list is ArmResourceListByParent<
    LabelingJob,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Number of labeling jobs to return.
       */
      @query("$top")
      $top?: int32;
    },
    Response = ArmResponse<LabelingJobResourceArmPaginatedResult>
  >;

  /**
   * Export labels from a labeling job (asynchronous).
   */
  exportLabels is ArmResourceActionAsync<
    LabelingJob,
    ExportSummary,
    ArmResponse<ExportSummary>
  >;

  /**
   * Pause a labeling job.
   */
  pause is ArmResourceActionSync<LabelingJob, void, void>;

  /**
   * Resume a labeling job (asynchronous).
   */
  resume is ArmResourceActionAsync<LabelingJob, void, void>;
}

@@doc(LabelingJob.name, "The name and identifier for the LabelingJob.");
@@doc(LabelingJob.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(LabelingJobs.createOrUpdate::parameters.resource,
  "LabelingJob definition object."
);
@@doc(LabelingJobs.exportLabels::parameters.body, "The export summary.");
