import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(Workspace)
model JobBaseResource is ProxyResource<JobBase> {
  @doc("The name and identifier for the Job. This is case-sensitive.")
  @path
  @key("id")
  @segment("jobs")
  name: string;
}

@armResourceOperations
interface Jobs {
  @doc("Gets a Job by name/id.")
  get is ArmResourceRead<JobBaseResource>;
  @doc("Creates and executes a Job.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<JobBaseResource>;
  @doc("Updates a Job.")
  update is ArmCustomPatchSync<JobBaseResource, PartialJobBasePartialResource>;
  @doc("Deletes a Job (asynchronous).")
  delete is ArmResourceDeleteAsync<JobBaseResource>;
  @doc("Lists Jobs in the workspace.")
  list is ArmResourceListByParent<
    JobBaseResource,
    {
      ...BaseParameters<JobBaseResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Type of job to be returned.")
      @query("jobType")
      jobType?: string;

      @doc("Jobs returned will have this tag key.")
      @query("tag")
      tag?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("Asset name the job's named output is registered with")
      @query("assetName")
      assetName?: string;

      @doc("Indicator whether the job is scheduled job.")
      @query("scheduled")
      scheduled?: boolean;

      @doc("The scheduled id for listing the job triggered from")
      @query("scheduleId")
      scheduleId?: string;
    }
  >;
  @doc("Cancels a Job (asynchronous).")
  cancel is ArmResourceActionAsync<JobBaseResource, void, void>;
}
