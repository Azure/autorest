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

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(BatchEndpoint)
model BatchEndpointTrackedResource extends Foundations.TrackedResource {
  ...ResourceNameParameter<
    Resource = BatchEndpointTrackedResource,
    KeyName = "endpointName",
    SegmentName = "batchEndpoints",
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
  properties: BatchEndpoint;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface BatchEndpointTrackedResources {
  /**
   * Gets a batch inference endpoint by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchEndpoints_Get")
  get is ArmResourceRead<BatchEndpointTrackedResource>;

  /**
   * Creates a batch inference endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchEndpoints_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<BatchEndpointTrackedResource>;

  /**
   * Update a batch inference endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("BatchEndpoints_Update")
  update is ArmCustomPatchAsync<
    BatchEndpointTrackedResource,
    PartialMinimalTrackedResourceWithIdentity
  >;

  /**
   * Delete Batch Inference Endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("BatchEndpoints_Delete")
  delete is ArmResourceDeleteAsync<BatchEndpointTrackedResource>;

  /**
   * Lists Batch inference endpoint in the workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchEndpoints_List")
  list is ArmResourceListByParent<
    BatchEndpointTrackedResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<BatchEndpointTrackedResource>;

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
    }
  >;

  /**
   * Lists batch Inference Endpoint keys.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BatchEndpoints_ListKeys")
  listKeys is ArmResourceActionSync<
    BatchEndpointTrackedResource,
    void,
    EndpointAuthKeys
  >;
}

@@doc(BatchEndpointTrackedResource.name, "Name for the Batch Endpoint.");
@@encodedName(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
  "Batch inference endpoint definition object."
);
@@encodedName(BatchEndpointTrackedResources.update::parameters.properties,
  "application/json",
  "body"
);
@@extension(BatchEndpointTrackedResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(BatchEndpointTrackedResources.update::parameters.properties,
  "Mutable batch inference endpoint definition object."
);
