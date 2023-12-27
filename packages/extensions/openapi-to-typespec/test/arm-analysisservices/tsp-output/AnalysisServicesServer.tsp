import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Analysis;
@doc("Represents an instance of an Analysis Services resource.")
model AnalysisServicesServer
  is TrackedResource<AnalysisServicesServerProperties> {
  @doc("The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.")
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9]*$")
  @key("serverName")
  @segment("servers")
  name: string;
}

@armResourceOperations
interface Servers {
  @doc("Gets details about the specified Analysis Services server.")
  getDetails is ArmResourceRead<AnalysisServicesServer>;
  @doc("Provisions the specified Analysis Services server based on the configuration specified in the request.")
  create is ArmResourceCreateOrUpdateAsync<AnalysisServicesServer>;
  @doc("Updates the current state of the specified Analysis Services server.")
  update is ArmCustomPatchAsync<
    AnalysisServicesServer,
    AnalysisServicesServerUpdateParameters
  >;
  @doc("Deletes the specified Analysis Services server.")
  delete is ArmResourceDeleteAsync<AnalysisServicesServer>;
  @doc("Gets all the Analysis Services servers for the given resource group.")
  listByResourceGroup is ArmResourceListByParent<AnalysisServicesServer>;
  @doc("Lists all the Analysis Services servers for the given subscription.")
  list is ArmListBySubscription<AnalysisServicesServer>;
  @doc("Lists eligible SKUs for Analysis Services resource provider.")
  listSkusForNew is ArmListBySubscription<AnalysisServicesServer>;
  @doc("Suspends operation of the specified Analysis Services server instance.")
  suspend is ArmResourceActionAsync<AnalysisServicesServer, void, void>;
  @doc("Resumes operation of the specified Analysis Services server instance.")
  resume is ArmResourceActionAsync<AnalysisServicesServer, void, void>;
  @doc("Return the gateway status of the specified Analysis Services server instance.")
  listGatewayStatus is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    GatewayListStatusLive
  >;
  @doc("Dissociates a Unified Gateway associated with the server.")
  dissociateGateway is ArmResourceActionSync<
    AnalysisServicesServer,
    void,
    void
  >;
  @doc("Lists eligible SKUs for an Analysis Services resource.")
  // FIXME: Servers_ListSkusForExisting could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/skus")
  @get
  ListSkusForExisting is Azure.Core.Foundations.Operation<
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
