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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TrafficControllerInterface_Get")
  get is ArmResourceRead<TrafficController>;

  /**
   * Create a TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TrafficControllerInterface_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    TrafficController,
    BaseParameters<TrafficController>,
    ArmAsyncOperationHeader
  >;

  /**
   * Update a TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("TrafficControllerInterface_Update")
  update is ArmCustomPatchSync<TrafficController, TrafficControllerUpdate>;

  /**
   * Delete a TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TrafficControllerInterface_Delete")
  delete is ArmResourceDeleteAsync<
    TrafficController,
    BaseParameters<TrafficController>,
    ArmLroLocationHeader
  >;

  /**
   * List TrafficController resources by resource group
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TrafficControllerInterface_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<TrafficController>;

  /**
   * List TrafficController resources by subscription ID
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TrafficControllerInterface_ListBySubscription")
  listBySubscription is ArmListBySubscription<TrafficController>;
}
