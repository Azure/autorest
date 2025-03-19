import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(Workspace)
model BatchEndpointTrackedResource
  is Azure.ResourceManager.TrackedResource<BatchEndpoint, false> {
  ...ResourceNameParameter<
    Resource = BatchEndpointTrackedResource,
    KeyName = "endpointName",
    SegmentName = "batchEndpoints",
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
interface BatchEndpointTrackedResources {
  /**
   * Gets a batch inference endpoint by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BatchEndpoints_Get")
  get is ArmResourceRead<BatchEndpointTrackedResource>;

  /**
   * Creates a batch inference endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BatchEndpoints_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<BatchEndpointTrackedResource>;

  /**
   * Update a batch inference endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @patch(#{ implicitOptionality: false })
  @operationId("BatchEndpoints_Update")
  update is ArmCustomPatchAsync<
    BatchEndpointTrackedResource,
    PatchModel = PartialMinimalTrackedResourceWithIdentity
  >;

  /**
   * Delete Batch Inference Endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("BatchEndpoints_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    BatchEndpointTrackedResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists Batch inference endpoint in the workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("BatchEndpoints_List")
  list is ArmResourceListByParent<
    BatchEndpointTrackedResource,
    Parameters = {
      /**
       * Number of endpoints to be retrieved in a page of results.
       */
      @query("count")
      count?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    },
    Response = ArmResponse<BatchEndpointTrackedResourceArmPaginatedResult>
  >;

  /**
   * Lists batch Inference Endpoint keys.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("listkeys")
  @operationId("BatchEndpoints_ListKeys")
  listKeys is ArmResourceActionSync<
    BatchEndpointTrackedResource,
    void,
    ArmResponse<EndpointAuthKeys>
  >;
}

@@doc(BatchEndpointTrackedResource.name, "Name for the Batch Endpoint.");
@@doc(BatchEndpointTrackedResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "Batch inference endpoint definition object."
);
@@doc(BatchEndpointTrackedResources.update::parameters.properties,
  "Mutable batch inference endpoint definition object."
);
