import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./OnlineEndpointTrackedResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(OnlineEndpointTrackedResource)
model OnlineDeploymentTrackedResource is TrackedResource<OnlineDeployment> {
  @doc("Inference Endpoint Deployment name.")
  @path
  @key("deploymentName")
  @segment("deployments")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
interface OnlineDeploymentTrackedResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get Inference Deployment Deployment.")
  @operationId("OnlineDeployments_Get")
  get is ArmResourceRead<OnlineDeploymentTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update Inference Endpoint Deployment (asynchronous).")
  @operationId("OnlineDeployments_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<OnlineDeploymentTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update Online Deployment (asynchronous).")
  @operationId("OnlineDeployments_Update")
  update is ArmCustomPatchAsync<
    OnlineDeploymentTrackedResource,
    PartialMinimalTrackedResourceWithSku
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete Inference Endpoint Deployment (asynchronous).")
  @operationId("OnlineDeployments_Delete")
  delete is ArmResourceDeleteAsync<
    OnlineDeploymentTrackedResource,
    BaseParameters<OnlineDeploymentTrackedResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List Inference Endpoint Deployments.")
  @operationId("OnlineDeployments_List")
  list is ArmResourceListByParent<
    OnlineDeploymentTrackedResource,
    {
      ...BaseParameters<OnlineDeploymentTrackedResource>;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Top of list.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Polls an Endpoint operation.")
  @operationId("OnlineDeployments_GetLogs")
  getLogs is ArmResourceActionSync<
    OnlineDeploymentTrackedResource,
    DeploymentLogsRequest,
    DeploymentLogs
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("OnlineDeployments_ListSkus")
  @summary("List Inference Endpoint Deployment Skus.")
  @doc("List Inference Endpoint Deployment Skus.")
  // FIXME: OnlineDeployments_ListSkus could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/onlineEndpoints/{endpointName}/deployments/{deploymentName}/skus")
  @get
  listSkus is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("The name of the resource group. The name is case insensitive.")
      @maxLength(90)
      @minLength(1)
      @path
      resourceGroupName: string;

      @doc("Name of Azure Machine Learning workspace.")
      @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
      @path
      workspaceName: string;

      @doc("Inference endpoint name.")
      @path
      endpointName: string;

      @doc("Inference Endpoint Deployment name.")
      @path
      deploymentName: string;

      @doc("Number of Skus to be retrieved in a page of results.")
      @query("count")
      count?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    },
    SkuResourceArmPaginatedResult
  >;
}

@@projectedName(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(OnlineDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "Inference Endpoint entity to apply during operation."
);
@@projectedName(OnlineDeploymentTrackedResources.update::parameters.properties,
  "json",
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
