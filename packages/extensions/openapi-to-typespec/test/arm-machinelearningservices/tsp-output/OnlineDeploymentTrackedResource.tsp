import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./OnlineEndpointTrackedResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

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
interface OnlineDeployments {
  @doc("Get Inference Deployment Deployment.")
  get is ArmResourceRead<OnlineDeploymentTrackedResource>;
  @doc("Create or update Inference Endpoint Deployment (asynchronous).")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<OnlineDeploymentTrackedResource>;
  // FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property
  @doc("Update Online Deployment (asynchronous).")
  update is ArmCustomPatchAsync<
    OnlineDeploymentTrackedResource,
    PartialMinimalTrackedResourceWithSku
  >;
  @doc("Delete Inference Endpoint Deployment (asynchronous).")
  delete is ArmResourceDeleteAsync<OnlineDeploymentTrackedResource>;
  @doc("List Inference Endpoint Deployments.")
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
  @doc("Polls an Endpoint operation.")
  getLogs is ArmResourceActionSync<
    OnlineDeploymentTrackedResource,
    DeploymentLogsRequest,
    DeploymentLogs
  >;
  @summary("List Inference Endpoint Deployment Skus.")
  @doc("List Inference Endpoint Deployment Skus.")
  // FIXME: OnlineDeployments_ListSkus could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/onlineEndpoints/{endpointName}/deployments/{deploymentName}/skus")
  @get
  ListSkus is Azure.Core.Foundations.Operation<
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
