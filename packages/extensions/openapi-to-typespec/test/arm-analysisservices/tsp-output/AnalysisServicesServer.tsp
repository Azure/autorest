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
@doc("Represents an instance of an Analysis Services resource.")
model AnalysisServicesServer
  is TrackedResource<AnalysisServicesServerProperties> {
  @doc("The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.")
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9]*$")
  @path
  @key("serverName")
  @segment("servers")
  name: string;
}

@armResourceOperations
interface AnalysisServicesServers {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets details about the specified Analysis Services server.")
  @operationId("Servers_GetDetails")
  getDetails is ArmResourceRead<AnalysisServicesServer>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Provisions the specified Analysis Services server based on the configuration specified in the request.")
  @operationId("Servers_Create")
  create is ArmResourceCreateOrUpdateAsync<AnalysisServicesServer>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the current state of the specified Analysis Services server.")
  @operationId("Servers_Update")
  update is ArmCustomPatchAsync<
    AnalysisServicesServer,
    AnalysisServicesServerUpdateParameters
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified Analysis Services server.")
  @operationId("Servers_Delete")
  delete is ArmResourceDeleteAsync<AnalysisServicesServer>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets all the Analysis Services servers for the given resource group.")
  @operationId("Servers_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<AnalysisServicesServer>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all the Analysis Services servers for the given subscription.")
  @operationId("Servers_List")
  list is ArmListBySubscription<AnalysisServicesServer>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists eligible SKUs for Analysis Services resource provider.")
  @operationId("Servers_ListSkusForNew")
  listSkusForNew is ArmListBySubscription<AnalysisServicesServer>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Suspends operation of the specified Analysis Services server instance.")
  @operationId("Servers_Suspend")
  suspend is ArmResourceActionAsync<AnalysisServicesServer, void, void>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Resumes operation of the specified Analysis Services server instance.")
  @operationId("Servers_Resume")
  resume is ArmResourceActionAsync<AnalysisServicesServer, void, void>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Return the gateway status of the specified Analysis Services server instance.")
  @operationId("Servers_ListGatewayStatus")
  listGatewayStatus is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    GatewayListStatusLive
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Dissociates a Unified Gateway associated with the server.")
  @operationId("Servers_DissociateGateway")
  dissociateGateway is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    void
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Check the name availability in the target location.")
  @operationId("Servers_CheckNameAvailability")
  checkNameAvailability is checkLocalNameAvailability<
    CheckServerNameAvailabilityParameters,
    CheckServerNameAvailabilityResult
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Servers_ListSkusForExisting")
  @doc("Lists eligible SKUs for an Analysis Services resource.")
  // FIXME: Servers_ListSkusForExisting could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/skus")
  @get
  listSkusForExisting is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.")
      @maxLength(90)
      @minLength(1)
      @pattern("^[-\\w\\._\\(\\)]+$")
      @path
      resourceGroupName: string;

      @doc("The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.")
      @maxLength(63)
      @minLength(3)
      @pattern("^[a-z][a-z0-9]*$")
      @path
      serverName: string;

      @doc("A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    SkuEnumerationForExistingResourceResult
  >;
}
