import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * The Private Endpoint Connection resource.
 */
model PrivateEndpointConnection is PrivateEndpointConnectionResource;
alias PrivateEndpointOperations = PrivateEndpoints<PrivateEndpointConnection>;

@armResourceOperations
interface PrivateEndpointConnections {
  /**
   * Gets the details of the Private Endpoint Connection specified by its identifier.
   */
  getByName is PrivateEndpointOperations.Read<
    ApiManagementServiceResource,
    PrivateEndpointConnection
  >;

  /**
   * Creates a new Private Endpoint Connection or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is PrivateEndpointOperations.CreateOrReplaceAsync<
    ApiManagementServiceResource,
    PrivateEndpointConnection,
    Request = PrivateEndpointConnectionRequest,
    Response = ArmResourceUpdatedResponse<Azure.ResourceManager.CommonTypes.PrivateEndpointConnection> | ArmAcceptedLroResponse,
    LroHeaders = ArmLroLocationHeader<FinalResult = PrivateEndpointConnection> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Deletes the specified Private Endpoint Connection.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is PrivateEndpointOperations.DeleteAsync<
    ApiManagementServiceResource,
    PrivateEndpointConnection,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all private endpoint connections of the API Management service instance.
   */
  listByService is PrivateEndpointOperations.ListByParent<
    ApiManagementServiceResource,
    PrivateEndpointConnection,
    Response = ArmResponse<Azure.ResourceManager.CommonTypes.PrivateEndpointConnectionListResultV5>
  >;
}

@@doc(PrivateEndpointConnection.properties, "Resource properties.");
@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource, "");
