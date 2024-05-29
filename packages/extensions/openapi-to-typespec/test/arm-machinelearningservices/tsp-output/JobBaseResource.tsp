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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(JobBase)
model JobBaseResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = JobBaseResource,
    KeyName = "id",
    SegmentName = "jobs",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: JobBase;
}

@armResourceOperations
interface JobBaseResources {
  /**
   * Gets a Job by name/id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Jobs_Get")
  get is ArmResourceRead<JobBaseResource>;

  /**
   * Creates and executes a Job.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Jobs_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<JobBaseResource>;

  /**
   * Updates a Job.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Jobs_Update")
  update is ArmCustomPatchSync<JobBaseResource, PartialJobBasePartialResource>;

  /**
   * Deletes a Job (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Jobs_Delete")
  delete is ArmResourceDeleteAsync<JobBaseResource>;

  /**
   * Lists Jobs in the workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Jobs_List")
  list is ArmResourceListByParent<
    JobBaseResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<JobBaseResource>;

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
    }
  >;

  /**
   * Cancels a Job (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Jobs_Cancel")
  cancel is ArmResourceActionAsync<JobBaseResource, void, void>;
}

@@doc(JobBaseResource.name,
  "The name and identifier for the Job. This is case-sensitive."
);
@@encodedName(JobBaseResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(JobBaseResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(JobBaseResources.createOrUpdate::parameters.resource,
  "Job definition object."
);
@@encodedName(JobBaseResources.update::parameters.properties,
  "application/json",
  "body"
);
@@extension(JobBaseResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(JobBaseResources.update::parameters.properties,
  "Job definition to apply during the operation."
);
