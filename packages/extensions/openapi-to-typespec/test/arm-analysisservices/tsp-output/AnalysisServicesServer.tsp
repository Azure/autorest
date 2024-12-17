import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Analysis;
/**
 * Represents an instance of an Analysis Services resource.
 */
model AnalysisServicesServer
  is Azure.ResourceManager.TrackedResource<AnalysisServicesServerProperties> {
  ...ResourceNameParameter<
    Resource = AnalysisServicesServer,
    KeyName = "serverName",
    SegmentName = "servers",
    NamePattern = "^[a-z][a-z0-9]*$"
  >;
}

@armResourceOperations
interface AnalysisServicesServersOperationGroup {
  /**
   * Gets details about the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_GetDetails")
  getDetails is ArmResourceRead<AnalysisServicesServer>;

  /**
   * Provisions the specified Analysis Services server based on the configuration specified in the request.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("Servers_Create")
  create is ArmResourceCreateOrReplaceAsync<
    AnalysisServicesServer,
    Response = ArmResourceUpdatedResponse<AnalysisServicesServer> | ArmResourceCreatedResponse<
      AnalysisServicesServer,
      ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
    > | (ArmAcceptedLroResponse & {
      @bodyRoot
      body: AnalysisServicesServer;
    })
  >;

  /**
   * Updates the current state of the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Servers_Update")
  update is ArmCustomPatchAsync<
    AnalysisServicesServer,
    PatchModel = AnalysisServicesServerUpdateParameters
  >;

  /**
   * Deletes the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("Servers_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    AnalysisServicesServer,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Gets all the Analysis Services servers for the given resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    AnalysisServicesServer,
    Response = ArmResponse<AnalysisServicesServers>
  >;

  /**
   * Lists all the Analysis Services servers for the given subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_List")
  list is ArmListBySubscription<
    AnalysisServicesServer,
    Response = ArmResponse<AnalysisServicesServers>
  >;

  /**
   * Suspends operation of the specified Analysis Services server instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_Suspend")
  suspend is ArmResourceActionAsync<AnalysisServicesServer, void, void>;

  /**
   * Resumes operation of the specified Analysis Services server instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_Resume")
  resume is ArmResourceActionAsync<AnalysisServicesServer, void, void>;

  /**
   * Lists eligible SKUs for an Analysis Services resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("skus")
  @operationId("Servers_ListSkusForExisting")
  listSkusForExisting is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    ArmResponse<SkuEnumerationForExistingResourceResult>
  >;

  /**
   * Return the gateway status of the specified Analysis Services server instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_ListGatewayStatus")
  listGatewayStatus is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    ArmResponse<GatewayListStatusLive>
  >;

  /**
   * Dissociates a Unified Gateway associated with the server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Servers_DissociateGateway")
  dissociateGateway is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    void
  >;
}

@@maxLength(AnalysisServicesServer.name, 63);
@@minLength(AnalysisServicesServer.name, 3);
@@doc(AnalysisServicesServer.name,
  "The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63."
);
@@doc(AnalysisServicesServer.properties,
  "Properties of the provision operation request."
);
@@doc(AnalysisServicesServersOperationGroup.create::parameters.resource,
  "Contains the information used to provision the Analysis Services server."
);
@@doc(AnalysisServicesServersOperationGroup.update::parameters.properties,
  "Request object that contains the updated information for the server."
);
