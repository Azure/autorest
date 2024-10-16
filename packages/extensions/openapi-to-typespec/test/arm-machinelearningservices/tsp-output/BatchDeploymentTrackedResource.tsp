import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BatchEndpointTrackedResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(BatchEndpointTrackedResource)
model BatchDeploymentTrackedResource
  is Azure.ResourceManager.TrackedResource<BatchDeployment, false> {
  ...ResourceNameParameter<
    Resource = BatchDeploymentTrackedResource,
    KeyName = "deploymentName",
    SegmentName = "deployments",
    NamePattern = ""
  >;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  kind?: string;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface BatchDeploymentTrackedResources {
  /**
   * Gets a batch inference deployment by id.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BatchDeployments_Get")
  get is ArmResourceRead<BatchDeploymentTrackedResource>;

  /**
   * Creates/updates a batch inference deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BatchDeployments_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<BatchDeploymentTrackedResource>;

  /**
   * Update a batch inference deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("BatchDeployments_Update")
  update is ArmCustomPatchAsync<
    BatchDeploymentTrackedResource,
    PartialBatchDeploymentPartialMinimalTrackedResourceWithProperties
  >;

  /**
   * Delete Batch Inference deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("BatchDeployments_Delete")
  delete is ArmResourceDeleteAsync<BatchDeploymentTrackedResource>;

  /**
   * Lists Batch inference deployments in the workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BatchDeployments_List")
  list is ArmResourceListByParent<
    BatchDeploymentTrackedResource,
    Parameters = {
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
    },
    Response = BatchDeploymentTrackedResourceArmPaginatedResult
  >;
}

@@doc(BatchDeploymentTrackedResource.name,
  "The identifier for the Batch deployments."
);
@@doc(BatchDeploymentTrackedResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "Batch inference deployment definition object."
);
@@doc(BatchDeploymentTrackedResources.update::parameters.properties,
  "Batch inference deployment definition object."
);
