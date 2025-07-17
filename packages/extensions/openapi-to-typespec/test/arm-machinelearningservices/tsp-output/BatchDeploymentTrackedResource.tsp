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
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  kind?: string;

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
  @operationId("BatchDeployments_Update")
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    BatchDeploymentTrackedResource,
    PatchModel = PartialBatchDeploymentPartialMinimalTrackedResourceWithProperties
  >;

  /**
   * Delete Batch Inference deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("BatchDeployments_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    BatchDeploymentTrackedResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

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
    Response = ArmResponse<BatchDeploymentTrackedResourceArmPaginatedResult>
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
