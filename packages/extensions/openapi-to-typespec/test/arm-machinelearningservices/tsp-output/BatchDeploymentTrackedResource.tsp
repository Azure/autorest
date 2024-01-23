import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BatchEndpointTrackedResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(BatchEndpointTrackedResource)
@Azure.ResourceManager.Private.armResourceInternal(BatchDeployment)
@includeInapplicableMetadataInPayload(false)
model BatchDeploymentTrackedResource extends TrackedResourceBase {
  /**
   * The identifier for the Batch deployments.
   */
  @path
  @key("deploymentName")
  @segment("deployments")
  name: string;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  kind?: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: BatchDeployment;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface BatchDeploymentTrackedResources {
  /**
   * Gets a batch inference deployment by id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchDeployments_Get")
  get is ArmResourceRead<BatchDeploymentTrackedResource>;

  /**
   * Creates/updates a batch inference deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchDeployments_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<BatchDeploymentTrackedResource>;

  /**
   * Update a batch inference deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("BatchDeployments_Update")
  update is ArmCustomPatchAsync<
    BatchDeploymentTrackedResource,
    PartialBatchDeploymentPartialMinimalTrackedResourceWithProperties
  >;

  /**
   * Delete Batch Inference deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchDeployments_Delete")
  delete is ArmResourceDeleteAsync<
    BatchDeploymentTrackedResource,
    BaseParameters<BatchDeploymentTrackedResource>,
    ArmLroLocationHeader
  >;

  /**
   * Lists Batch inference deployments in the workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchDeployments_List")
  list is ArmResourceListByParent<
    BatchDeploymentTrackedResource,
    {
      ...BaseParameters<BatchDeploymentTrackedResource>;

      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Top of list.
       */
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    }
  >;
}

@@projectedName(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "Batch inference deployment definition object."
);
@@projectedName(BatchDeploymentTrackedResources.update::parameters.properties,
  "json",
  "body"
);
@@extension(BatchDeploymentTrackedResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(BatchDeploymentTrackedResources.update::parameters.properties,
  "Batch inference deployment definition object."
);
