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
/**
 * The Private Endpoint Connection resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  PrivateEndpointConnectionProperties
)
model PrivateEndpointConnection extends Foundations.TrackedResource {
  ...ResourceNameParameter<
    Resource = PrivateEndpointConnection,
    KeyName = "privateEndpointConnectionName",
    SegmentName = "privateEndpointConnections",
    NamePattern = ""
  >;

  /**
   * Private endpoint connection properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PrivateEndpointConnectionProperties;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface PrivateEndpointConnections {
  /**
   * Called by end-users to get a PE connection.
   */
  get is ArmResourceRead<PrivateEndpointConnection>;

  /**
   * Called by end-users to approve or reject a PE connection.
   * This method must validate and forward the call to NRP.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<PrivateEndpointConnection>;

  /**
   * Called by end-users to delete a PE connection.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<PrivateEndpointConnection>;

  /**
   * Called by end-users to get all PE connections.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PrivateEndpointConnections_List")
  list is ArmResourceListByParent<PrivateEndpointConnection>;
}

@@doc(PrivateEndpointConnection.name, "NRP Private Endpoint Connection Name");
@@encodedName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "PrivateEndpointConnection object"
);
