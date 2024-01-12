import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

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
interface BatchEndpointTrackedResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a batch inference endpoint by name.")
  @operationId("BatchEndpoints_Get")
  get is ArmResourceRead<BatchEndpointTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a batch inference endpoint (asynchronous).")
  @operationId("BatchEndpoints_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<BatchEndpointTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update a batch inference endpoint (asynchronous).")
  @operationId("BatchEndpoints_Update")
  update is ArmCustomPatchAsync<
    BatchEndpointTrackedResource,
    PartialMinimalTrackedResourceWithIdentity
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete Batch Inference Endpoint (asynchronous).")
  @operationId("BatchEndpoints_Delete")
  delete is ArmResourceDeleteAsync<
    BatchEndpointTrackedResource,
    BaseParameters<BatchEndpointTrackedResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists Batch inference endpoint in the workspace.")
  @operationId("BatchEndpoints_List")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists batch Inference Endpoint keys.")
  @operationId("BatchEndpoints_ListKeys")
  listKeys is ArmResourceActionSync<
    BatchEndpointTrackedResource,
    void,
    EndpointAuthKeys
  >;
}

@@projectedName(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "Batch inference endpoint definition object."
);
@@projectedName(BatchEndpointTrackedResources.update::parameters.properties,
  "json",
  "body"
);
@@extension(BatchEndpointTrackedResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(BatchEndpointTrackedResources.update::parameters.properties,
  "Mutable batch inference endpoint definition object."
);
