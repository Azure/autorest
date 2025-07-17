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
model JobBaseResource is Azure.ResourceManager.ProxyResource<JobBase, false> {
  ...ResourceNameParameter<
    Resource = JobBaseResource,
    KeyName = "id",
    SegmentName = "jobs",
    NamePattern = ""
  >;
}

@armResourceOperations
interface JobBaseResources {
  /**
   * Gets a Job by name/id.
   */
  get is ArmResourceRead<JobBaseResource>;

  /**
   * Creates and executes a Job.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Jobs_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<JobBaseResource>;

  /**
   * Updates a Job.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    JobBaseResource,
    PatchModel = PartialJobBasePartialResource
  >;

  /**
   * Deletes a Job (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    JobBaseResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists Jobs in the workspace.
   */
  list is ArmResourceListByParent<
    JobBaseResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Type of job to be returned.
       */
      @query("jobType")
      jobType?: string;

      /**
       * Jobs returned will have this tag key.
       */
      @query("tag")
      tag?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * Asset name the job's named output is registered with
       */
      @query("assetName")
      assetName?: string;

      /**
       * Indicator whether the job is scheduled job.
       */
      @query("scheduled")
      scheduled?: boolean;

      /**
       * The scheduled id for listing the job triggered from
       */
      @query("scheduleId")
      scheduleId?: string;
    },
    Response = ArmResponse<JobBaseResourceArmPaginatedResult>
  >;

  /**
   * Cancels a Job (asynchronous).
   */
  cancel is ArmResourceActionAsync<JobBaseResource, void, OkResponse>;
}

@@doc(JobBaseResource.name,
  "The name and identifier for the Job. This is case-sensitive."
);
@@doc(JobBaseResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(JobBaseResources.createOrUpdate::parameters.resource,
  "Job definition object."
);
@@doc(JobBaseResources.update::parameters.properties,
  "Job definition to apply during the operation."
);
