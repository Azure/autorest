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

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(OnlineEndpointTrackedResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(OnlineDeployment)
model OnlineDeploymentTrackedResource extends Foundations.TrackedResource {
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

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: OnlineDeployment;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface OnlineDeploymentTrackedResources {
  /**
   * Get Inference Deployment Deployment.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OnlineDeployments_Get")
  get is ArmResourceRead<OnlineDeploymentTrackedResource>;

  /**
   * Create or update Inference Endpoint Deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OnlineDeployments_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<OnlineDeploymentTrackedResource>;

  /**
   * Update Online Deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("OnlineDeployments_Update")
  update is ArmCustomPatchAsync<
    OnlineDeploymentTrackedResource,
    PartialMinimalTrackedResourceWithSku
  >;

  /**
   * Delete Inference Endpoint Deployment (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("OnlineDeployments_Delete")
  delete is ArmResourceDeleteAsync<OnlineDeploymentTrackedResource>;

  /**
   * List Inference Endpoint Deployments.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OnlineDeployments_List")
  list is ArmResourceListByParent<
    OnlineDeploymentTrackedResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<OnlineDeploymentTrackedResource>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
@@encodedName(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "Inference Endpoint entity to apply during operation."
);
@@encodedName(OnlineDeploymentTrackedResources.update::parameters.properties,
  "application/json",
  "body"
);
@@extension(OnlineDeploymentTrackedResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(OnlineDeploymentTrackedResources.update::parameters.properties,
  "Online Endpoint entity to apply during operation."
);
@@doc(OnlineDeploymentTrackedResources.getLogs::parameters.body,
  "The request containing parameters for retrieving logs."
);
