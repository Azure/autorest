import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(LabelingJobProperties)
model LabelingJob extends ProxyResourceBase {
  /**
   * The name and identifier for the LabelingJob.
   */
  @path
  @key("id")
  @segment("labelingJobs")
  @visibility("read")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: LabelingJobProperties;
}

@armResourceOperations
interface LabelingJobs {
  /**
   * Gets a labeling job by name/id.
   */
  get is ArmResourceRead<
    LabelingJob,
    {
      ...BaseParameters<LabelingJob>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("LabelingJobs_List")
  list is ArmResourceListByParent<
    LabelingJob,
    {
      ...BaseParameters<LabelingJob>;

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
    }
  >;

  /**
   * Export labels from a labeling job (asynchronous).
   */
  exportLabels is ArmResourceActionAsync<
    LabelingJob,
    ExportSummary,
    ExportSummary
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

@@encodedName(LabelingJobs.createOrUpdate::parameters.resource, "json", "body");
@@extension(LabelingJobs.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(LabelingJobs.createOrUpdate::parameters.resource,
  "LabelingJob definition object."
);
@@doc(LabelingJobs.exportLabels::parameters.body, "The export summary.");
