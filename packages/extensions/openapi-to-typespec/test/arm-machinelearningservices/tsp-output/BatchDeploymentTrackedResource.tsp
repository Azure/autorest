import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./BatchEndpointTrackedResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(BatchEndpointTrackedResource)
model BatchDeploymentTrackedResource is TrackedResource<BatchDeployment> {
  @doc("The identifier for the Batch deployments.")
  @key("deploymentName")
  @segment("deployments")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
@projectedName("client", "BatchDeployments")
interface BatchDeploymentTrackedResources_BatchDeployments {
  @doc("Gets a batch inference deployment by id.")
  get is ArmResourceRead<BatchDeploymentTrackedResource>;
  @doc("Creates/updates a batch inference deployment (asynchronous).")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<BatchDeploymentTrackedResource>;
  @doc("Update a batch inference deployment (asynchronous).")
  update is ArmCustomPatchAsync<
    BatchDeploymentTrackedResource,
    PartialBatchDeploymentPartialMinimalTrackedResourceWithProperties
  >;
  @doc("Delete Batch Inference deployment (asynchronous).")
  delete is ArmResourceDeleteAsync<BatchDeploymentTrackedResource>;
  @doc("Lists Batch inference deployments in the workspace.")
  list is ArmResourceListByParent<
    BatchDeploymentTrackedResource,
    {
      ...BaseParameters<BatchDeploymentTrackedResource>;

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
}
