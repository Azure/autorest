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
@doc("Azure Resource Manager resource envelope.")
@parentResource(Workspace)
model LabelingJob is ProxyResource<LabelingJobProperties> {
  @doc("The name and identifier for the LabelingJob.")
  @path
  @key("id")
  @segment("labelingJobs")
  name: string;
}

@armResourceOperations
interface LabelingJobs {
  @doc("Gets a labeling job by name/id.")
  get is ArmResourceRead<
    LabelingJob,
    {
      ...BaseParameters<LabelingJob>;

      @doc("Boolean value to indicate whether to include JobInstructions in response.")
      @query("includeJobInstructions")
      includeJobInstructions?: boolean;

      @doc("Boolean value to indicate Whether to include LabelCategories in response.")
      @query("includeLabelCategories")
      includeLabelCategories?: boolean;
    }
  >;

  @doc("Creates or updates a labeling job (asynchronous).")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<LabelingJob>;

  @doc("Delete a labeling job.")
  delete is ArmResourceDeleteSync<LabelingJob>;

  @doc("Lists labeling jobs in the workspace.")
  list is ArmResourceListByParent<
    LabelingJob,
    {
      ...BaseParameters<LabelingJob>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Number of labeling jobs to return.")
      @query("$top")
      $top?: int32;
    }
  >;

  @doc("Export labels from a labeling job (asynchronous).")
  exportLabels is ArmResourceActionAsync<
    LabelingJob,
    ExportSummary,
    ExportSummary,
    BaseParameters<LabelingJob>,
    ArmLroLocationHeader
  >;

  @doc("Pause a labeling job.")
  pause is ArmResourceActionSync<LabelingJob, void, void>;

  @doc("Resume a labeling job (asynchronous).")
  resume is ArmResourceActionAsync<
    LabelingJob,
    void,
    void,
    BaseParameters<LabelingJob>,
    ArmLroLocationHeader
  >;
}
