import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AgFoodPlatform;
/**
 * The private endpoint connection resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(DataManagerForAgriculture)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  PrivateEndpointConnectionProperties
)
model PrivateEndpointConnection extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = PrivateEndpointConnection,
    KeyName = "privateEndpointConnectionName",
    SegmentName = "privateEndpointConnections",
    NamePattern = ""
  >;

  /**
   * Resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PrivateEndpointConnectionProperties;
}

@armResourceOperations
interface PrivateEndpointConnections {
  /**
   * Get Private endpoint connection object.
   */
  get is ArmResourceRead<PrivateEndpointConnection>;

  /**
   * Approves or Rejects a Private endpoint connection request.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<PrivateEndpointConnection>;

  /**
   * Delete Private endpoint connection request.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<PrivateEndpointConnection>;

  /**
   * Get list of Private endpoint connections.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PrivateEndpointConnections_ListByResource")
  listByResource is ArmResourceListByParent<PrivateEndpointConnection>;
}

@@doc(PrivateEndpointConnection.name, "Private endpoint connection name.");
@@encodedName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "application/json",
  "request"
);
@@extension(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "request"
);
@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "Request object."
);
