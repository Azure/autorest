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

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  kind?: string;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
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
  @parameterVisibility
  @operationId("OnlineDeployments_Update")
  update is ArmCustomPatchAsync<
    OnlineDeploymentTrackedResource,
    PartialMinimalTrackedResourceWithSku
  >;

  /**
   * Delete Inference Endpoint Deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("OnlineDeployments_Delete")
  delete is ArmResourceDeleteAsync<OnlineDeploymentTrackedResource>;

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
    }
  >;

  /**
   * Polls an Endpoint operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineDeployments_GetLogs")
  getLogs is ArmResourceActionSync<
    OnlineDeploymentTrackedResource,
    DeploymentLogsRequest,
    DeploymentLogs
  >;

  /**
   * List Inference Endpoint Deployment Skus.
   */
  // FIXME: OnlineDeployments_ListSkus could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineDeployments_ListSkus")
  @summary("List Inference Endpoint Deployment Skus.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/onlineEndpoints/{endpointName}/deployments/{deploymentName}/skus")
  @get
  listSkus(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Name of Azure Machine Learning workspace.
     */
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    @path
    workspaceName: string,

    /**
     * Inference endpoint name.
     */
    @path
    endpointName: string,

    /**
     * Inference Endpoint Deployment name.
     */
    @path
    deploymentName: string,

    /**
     * Number of Skus to be retrieved in a page of results.
     */
    @query("count")
    count?: int32,

    /**
     * Continuation token for pagination.
     */
    @query("$skip")
    $skip?: string,
  ): ArmResponse<SkuResourceArmPaginatedResult> | ErrorResponse;
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
