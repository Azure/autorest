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
model JobBaseResource is ProxyResource<JobBase> {
  @doc("The name and identifier for the Job. This is case-sensitive.")
  @path
  @key("id")
  @segment("jobs")
  name: string;
}

@armResourceOperations
interface JobBaseResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a Job by name/id.")
  @operationId("Jobs_Get")
  get is ArmResourceRead<JobBaseResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates and executes a Job.")
  @operationId("Jobs_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<JobBaseResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates a Job.")
  @parameterVisibility("read")
  @operationId("Jobs_Update")
  update is ArmCustomPatchSync<JobBaseResource, PartialJobBasePartialResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes a Job (asynchronous).")
  @operationId("Jobs_Delete")
  delete is ArmResourceDeleteAsync<
    JobBaseResource,
    BaseParameters<JobBaseResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists Jobs in the workspace.")
  @operationId("Jobs_List")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Cancels a Job (asynchronous).")
  @operationId("Jobs_Cancel")
  cancel is ArmResourceActionAsync<
    JobBaseResource,
    void,
    void,
    BaseParameters<JobBaseResource>,
    ArmLroLocationHeader
  >;
}

@@projectedName(JobBaseResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(JobBaseResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(JobBaseResources.createOrUpdate::parameters.resource,
  "Job definition object."
);
@@projectedName(JobBaseResources.update::parameters.properties, "json", "body");
@@extension(JobBaseResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(JobBaseResources.update::parameters.properties,
  "Job definition to apply during the operation."
);
