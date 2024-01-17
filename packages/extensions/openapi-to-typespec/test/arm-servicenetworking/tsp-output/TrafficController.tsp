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
interface TrafficControllers {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get a TrafficController")
  @operationId("TrafficControllerInterface_Get")
  get is ArmResourceRead<TrafficController>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create a TrafficController")
  @operationId("TrafficControllerInterface_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    TrafficController,
    BaseParameters<TrafficController>,
    ArmAsyncOperationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update a TrafficController")
  @parameterVisibility("read")
  @operationId("TrafficControllerInterface_Update")
  update is ArmCustomPatchSync<TrafficController, TrafficControllerUpdate>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete a TrafficController")
  @operationId("TrafficControllerInterface_Delete")
  delete is ArmResourceDeleteAsync<
    TrafficController,
    BaseParameters<TrafficController>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List TrafficController resources by resource group")
  @operationId("TrafficControllerInterface_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<TrafficController>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List TrafficController resources by subscription ID")
  @operationId("TrafficControllerInterface_ListBySubscription")
  listBySubscription is ArmListBySubscription<TrafficController>;
}
