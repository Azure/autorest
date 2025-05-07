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

namespace Microsoft.AgFoodPlatform;
/**
 * The private endpoint connection resource.
 */
@parentResource(DataManagerForAgriculture)
model PrivateEndpointConnection
  is Azure.ResourceManager.ProxyResource<PrivateEndpointConnectionProperties> {
  ...ResourceNameParameter<
    Resource = PrivateEndpointConnection,
    KeyName = "privateEndpointConnectionName",
    SegmentName = "privateEndpointConnections",
    NamePattern = ""
  >;
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PrivateEndpointConnection,
    Response = ArmResourceUpdatedResponse<Azure.ResourceManager.CommonTypes.PrivateEndpointConnection>
  >;

  /**
   * Delete Private endpoint connection request.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    PrivateEndpointConnection,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse<ArmAsyncOperationHeader &
      Azure.Core.Foundations.RetryAfterHeader> | ArmDeletedNoContentResponse
  >;

  /**
   * Get list of Private endpoint connections.
   */
  listByResource is ArmResourceListByParent<
    PrivateEndpointConnection,
    Response = ArmResponse<Azure.ResourceManager.CommonTypes.PrivateEndpointConnectionListResultV5>
  >;
}

@@doc(PrivateEndpointConnection.name, "Private endpoint connection name.");
@@doc(PrivateEndpointConnection.properties, "Resource properties.");
@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "Request object."
);
