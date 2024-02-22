import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Analysis;
/**
 * Represents an instance of an Analysis Services resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model AnalysisServicesServer extends Resource {
  /**
   * The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
   */
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9]*$")
  @path
  @key("serverName")
  @segment("servers")
  @visibility("read")
  name: string;

  /**
   * Properties of the provision operation request.
   */
  @extension("x-ms-client-flatten", true)
  properties?: AnalysisServicesServerProperties;
}

@armResourceOperations
interface AnalysisServicesServers {
  /**
   * Gets details about the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_GetDetails")
  getDetails is ArmResourceRead<AnalysisServicesServer>;

  /**
   * Provisions the specified Analysis Services server based on the configuration specified in the request.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_Create")
  create is ArmResourceCreateOrReplaceAsync<AnalysisServicesServer>;

  /**
   * Updates the current state of the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("Servers_Update")
  update is ArmCustomPatchAsync<
    AnalysisServicesServer,
    AnalysisServicesServerUpdateParameters
  >;

  /**
   * Deletes the specified Analysis Services server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_Delete")
  delete is ArmResourceDeleteAsync<AnalysisServicesServer>;

  /**
   * Gets all the Analysis Services servers for the given resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<AnalysisServicesServer>;

  /**
   * Lists all the Analysis Services servers for the given subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_List")
  list is ArmListBySubscription<AnalysisServicesServer>;

  /**
   * Lists eligible SKUs for Analysis Services resource provider.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_ListSkusForNew")
  listSkusForNew is ArmListBySubscription<AnalysisServicesServer>;

  /**
   * Suspends operation of the specified Analysis Services server instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_Suspend")
  suspend is ArmResourceActionAsync<AnalysisServicesServer, void, void>;

  /**
   * Resumes operation of the specified Analysis Services server instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_Resume")
  resume is ArmResourceActionAsync<AnalysisServicesServer, void, void>;

  /**
   * Return the gateway status of the specified Analysis Services server instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_ListGatewayStatus")
  listGatewayStatus is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    GatewayListStatusLive
  >;

  /**
   * Dissociates a Unified Gateway associated with the server.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_DissociateGateway")
  dissociateGateway is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    void
  >;

  /**
   * Check the name availability in the target location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_CheckNameAvailability")
  checkNameAvailability is checkLocalNameAvailability<
    CheckServerNameAvailabilityParameters,
    CheckServerNameAvailabilityResult
  >;

  /**
   * Lists eligible SKUs for an Analysis Services resource.
   */
  // FIXME: Servers_ListSkusForExisting could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_ListSkusForExisting")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/skus")
  @get
  listSkusForExisting is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
       */
      @maxLength(90)
      @minLength(1)
      @pattern("^[-\\w\\._\\(\\)]+$")
      @path
      resourceGroupName: string;

      /**
       * The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
       */
      @maxLength(63)
      @minLength(3)
      @pattern("^[a-z][a-z0-9]*$")
      @path
      serverName: string;

      /**
       * A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    SkuEnumerationForExistingResourceResult
  >;
}

@@encodedName(AnalysisServicesServers.create::parameters.resource,
  "application/json",
  "serverParameters"
);
@@extension(AnalysisServicesServers.create::parameters.resource,
  "x-ms-client-name",
  "serverParameters"
);
@@doc(AnalysisServicesServers.create::parameters.resource,
  "Contains the information used to provision the Analysis Services server."
);
@@encodedName(AnalysisServicesServers.update::parameters.properties,
  "application/json",
  "serverUpdateParameters"
);
@@extension(AnalysisServicesServers.update::parameters.properties,
  "x-ms-client-name",
  "serverUpdateParameters"
);
@@doc(AnalysisServicesServers.update::parameters.properties,
  "Request object that contains the updated information for the server."
);
