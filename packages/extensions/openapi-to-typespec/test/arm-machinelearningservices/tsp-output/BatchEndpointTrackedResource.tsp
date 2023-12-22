import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(Workspace)
model BatchEndpointTrackedResource is TrackedResource<BatchEndpoint> {
  @doc("Name for the Batch Endpoint.")
  @path
  @key("endpointName")
  @segment("batchEndpoints")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
interface BatchEndpoints {
  @doc("Gets a batch inference endpoint by name.")
  get is ArmResourceRead<BatchEndpointTrackedResource>;
  @doc("Creates a batch inference endpoint (asynchronous).")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<BatchEndpointTrackedResource>;
  // FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property
  @doc("Update a batch inference endpoint (asynchronous).")
  update is ArmCustomPatchAsync<
    BatchEndpointTrackedResource,
    PartialMinimalTrackedResourceWithIdentity
  >;
  @doc("Delete Batch Inference Endpoint (asynchronous).")
  delete is ArmResourceDeleteAsync<BatchEndpointTrackedResource>;
  @doc("Lists Batch inference endpoint in the workspace.")
  list is ArmResourceListByParent<
    BatchEndpointTrackedResource,
    {
      ...BaseParameters<BatchEndpointTrackedResource>;

      @doc("Number of endpoints to be retrieved in a page of results.")
      @query("count")
      count?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;
  @doc("Lists batch Inference Endpoint keys.")
  listKeys is ArmResourceActionSync<
    BatchEndpointTrackedResource,
    void,
    EndpointAuthKeys
  >;
}
