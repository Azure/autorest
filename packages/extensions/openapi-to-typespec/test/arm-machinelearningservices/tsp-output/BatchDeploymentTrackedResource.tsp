import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BatchEndpointTrackedResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(BatchEndpointTrackedResource)
model BatchDeploymentTrackedResource is TrackedResource<BatchDeployment> {
  @doc("The identifier for the Batch deployments.")
  @path
  @key("deploymentName")
  @segment("deployments")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
interface BatchDeploymentTrackedResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a batch inference deployment by id.")
  @operationId("BatchDeployments_Get")
  get is ArmResourceRead<BatchDeploymentTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates/updates a batch inference deployment (asynchronous).")
  @operationId("BatchDeployments_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<BatchDeploymentTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update a batch inference deployment (asynchronous).")
  @parameterVisibility("read")
  @operationId("BatchDeployments_Update")
  update is ArmCustomPatchAsync<
    BatchDeploymentTrackedResource,
    PartialBatchDeploymentPartialMinimalTrackedResourceWithProperties
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete Batch Inference deployment (asynchronous).")
  @operationId("BatchDeployments_Delete")
  delete is ArmResourceDeleteAsync<
    BatchDeploymentTrackedResource,
    BaseParameters<BatchDeploymentTrackedResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists Batch inference deployments in the workspace.")
  @operationId("BatchDeployments_List")
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

@@projectedName(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(BatchDeploymentTrackedResources.createOrUpdate::parameters.resource,
  "Batch inference deployment definition object."
);
@@projectedName(BatchDeploymentTrackedResources.update::parameters.properties,
  "json",
  "body"
);
@@extension(BatchDeploymentTrackedResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(BatchDeploymentTrackedResources.update::parameters.properties,
  "Batch inference deployment definition object."
);
