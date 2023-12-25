import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.ServiceNetworking;
@doc("Concrete tracked resource types can be created by aliasing this type using a specific property type.")
model TrafficController is TrackedResource<TrafficControllerProperties> {
  @doc("traffic controller name for path")
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @path
  @key("trafficControllerName")
  @segment("trafficControllers")
  name: string;
}

@armResourceOperations
interface TrafficControllerInterface {
  @doc("Get a TrafficController")
  get is ArmResourceRead<TrafficController>;
  @doc("Create a TrafficController")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<TrafficController>;
  @doc("Update a TrafficController")
  update is ArmCustomPatchSync<TrafficController, TrafficControllerUpdate>;
  @doc("Delete a TrafficController")
  delete is ArmResourceDeleteAsync<TrafficController>;
  @doc("List TrafficController resources by resource group")
  listByResourceGroup is ArmResourceListByParent<TrafficController>;
  @doc("List TrafficController resources by subscription ID")
  listBySubscription is ArmListBySubscription<TrafficController>;
}
