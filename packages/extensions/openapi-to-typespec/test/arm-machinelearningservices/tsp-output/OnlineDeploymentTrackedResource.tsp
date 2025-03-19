import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./OnlineEndpointTrackedResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(OnlineEndpointTrackedResource)
model OnlineDeploymentTrackedResource
  is Azure.ResourceManager.TrackedResource<OnlineDeployment, false> {
  ...ResourceNameParameter<
    Resource = OnlineDeploymentTrackedResource,
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
interface OnlineDeploymentTrackedResources {
  /**
   * Get Inference Deployment Deployment.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineDeployments_Get")
  get is ArmResourceRead<OnlineDeploymentTrackedResource>;

  /**
   * Create or update Inference Endpoint Deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineDeployments_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<OnlineDeploymentTrackedResource>;

  /**
   * Update Online Deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @patch(#{ implicitOptionality: false })
  @operationId("OnlineDeployments_Update")
  update is ArmCustomPatchAsync<
    OnlineDeploymentTrackedResource,
    PatchModel = PartialMinimalTrackedResourceWithSku
  >;

  /**
   * Delete Inference Endpoint Deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("OnlineDeployments_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    OnlineDeploymentTrackedResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List Inference Endpoint Deployments.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineDeployments_List")
  list is ArmResourceListByParent<
    OnlineDeploymentTrackedResource,
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
    Response = ArmResponse<OnlineDeploymentTrackedResourceArmPaginatedResult>
  >;

  /**
   * Polls an Endpoint operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineDeployments_GetLogs")
  getLogs is ArmResourceActionSync<
    OnlineDeploymentTrackedResource,
    DeploymentLogsRequest,
    ArmResponse<DeploymentLogs>
  >;

  /**
   * List Inference Endpoint Deployment Skus.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("skus")
  @operationId("OnlineDeployments_ListSkus")
  listSkus is ArmResourceActionSync<
    OnlineDeploymentTrackedResource,
    void,
    ArmResponse<SkuResourceArmPaginatedResult>,
    Parameters = {
      /**
       * Number of Skus to be retrieved in a page of results.
       */
      @query("count")
      count?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    }
  >;
}

@@doc(OnlineDeploymentTrackedResource.name,
  "Inference Endpoint Deployment name."
);
@@doc(OnlineDeploymentTrackedResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "Inference Endpoint entity to apply during operation."
);
@@doc(OnlineDeploymentTrackedResources.update::parameters.properties,
  "Online Endpoint entity to apply during operation."
);
@@doc(OnlineDeploymentTrackedResources.getLogs::parameters.body,
  "The request containing parameters for retrieving logs."
);
