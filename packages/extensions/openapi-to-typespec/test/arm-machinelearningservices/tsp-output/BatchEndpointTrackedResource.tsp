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

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(BatchEndpoint)
model BatchEndpointTrackedResource extends TrackedResourceBase {
  /**
   * Name for the Batch Endpoint.
   */
  @path
  @key("endpointName")
  @segment("batchEndpoints")
  @visibility("read")
  name: string;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  kind?: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: BatchEndpoint;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
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
  @parameterVisibility("read")
  @operationId("BatchEndpoints_Update")
  update is ArmCustomPatchAsync<
    BatchEndpointTrackedResource,
    PartialMinimalTrackedResourceWithIdentity
  >;

  /**
   * Delete Batch Inference Endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
      ...BaseParameters<BatchEndpointTrackedResource>;

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

@@encodedName(BatchEndpointTrackedResources.createOrUpdate::parameters.resource,
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
@@encodedName(BatchEndpointTrackedResources.update::parameters.properties,
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
