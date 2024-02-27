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

namespace Microsoft.ServiceNetworking;
/**
 * Concrete tracked resource types can be created by aliasing this type using a specific property type.
 */
model TrafficController is TrackedResource<TrafficControllerProperties> {
  /**
   * traffic controller name for path
   */
  @pattern("^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$")
  @path
  @key("trafficControllerName")
  @segment("trafficControllers")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface TrafficControllers {
  /**
   * Get a TrafficController
   */
  get is ArmResourceRead<TrafficController>;

  /**
   * Create a TrafficController
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<TrafficController>;

  /**
   * Update a TrafficController
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<TrafficController, TrafficControllerUpdate>;

  /**
   * Delete a TrafficController
   */
  delete is ArmResourceDeleteAsync<TrafficController>;

  /**
   * List TrafficController resources by resource group
   */
  listByResourceGroup is ArmResourceListByParent<TrafficController>;

  /**
   * List TrafficController resources by subscription ID
   */
  listBySubscription is ArmListBySubscription<TrafficController>;
}
