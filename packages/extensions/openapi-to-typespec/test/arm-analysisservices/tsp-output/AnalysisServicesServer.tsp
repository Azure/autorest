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

  /**
   * The SKU of the Analysis Services resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku: ResourceSku;
}

@armResourceOperations
interface Servers {
  /**
   * Gets details about the specified Analysis Services server.
   */
  getDetails is ArmResourceRead<AnalysisServicesServer>;

  /**
   * Provisions the specified Analysis Services server based on the configuration specified in the request.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  create is ArmResourceCreateOrReplaceAsync<
    AnalysisServicesServer,
    Response = ArmResourceUpdatedResponse<AnalysisServicesServer> | ArmResourceCreatedResponse<
      AnalysisServicesServer,
      ArmLroLocationHeader<FinalResult = AnalysisServicesServer> &
        Azure.Core.Foundations.RetryAfterHeader
    > | (ArmAcceptedLroResponse & {
      @bodyRoot
      _: AnalysisServicesServer;
    })
  >;

  /**
   * Updates the current state of the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    AnalysisServicesServer,
    PatchModel = AnalysisServicesServerUpdateParameters,
    Response = ArmResponse<AnalysisServicesServer> | (ArmAcceptedLroResponse & {
      @bodyRoot
      _: AnalysisServicesServer;
    })
  >;

  /**
   * Deletes the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    AnalysisServicesServer,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Gets all the Analysis Services servers for the given resource group.
   */
  listByResourceGroup is ArmResourceListByParent<
    AnalysisServicesServer,
    Response = ArmResponse<AnalysisServicesServers>
  >;

  /**
   * Lists all the Analysis Services servers for the given subscription.
   */
  list is ArmListBySubscription<
    AnalysisServicesServer,
    Response = ArmResponse<AnalysisServicesServers>
  >;

  /**
   * Suspends operation of the specified Analysis Services server instance.
   */
  suspend is ArmResourceActionAsync<AnalysisServicesServer, void, OkResponse>;

  /**
   * Resumes operation of the specified Analysis Services server instance.
   */
  resume is ArmResourceActionAsync<AnalysisServicesServer, void, OkResponse>;

  /**
   * Lists eligible SKUs for an Analysis Services resource.
   */
  @list
  @get
  @action("skus")
  listSkusForExisting is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    ArmResponse<SkuEnumerationForExistingResourceResult>
  >;

  /**
   * Return the gateway status of the specified Analysis Services server instance.
   */
  listGatewayStatus is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    ArmResponse<GatewayListStatusLive>
  >;

  /**
   * Dissociates a Unified Gateway associated with the server.
   */
  dissociateGateway is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    OkResponse
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
@@doc(Servers.create::parameters.resource,
  "Contains the information used to provision the Analysis Services server."
);
@@doc(Servers.update::parameters.properties,
  "Request object that contains the updated information for the server."
);
