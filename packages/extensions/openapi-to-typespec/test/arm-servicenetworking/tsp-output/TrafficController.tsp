import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.ServiceNetworking;
/**
 * Concrete tracked resource types can be created by aliasing this type using a specific property type.
 */
model TrafficController
  is Azure.ResourceManager.TrackedResource<TrafficControllerProperties> {
  ...ResourceNameParameter<
    Resource = TrafficController,
    KeyName = "trafficControllerName",
    SegmentName = "trafficControllers",
    NamePattern = "^[A-Za-z0-9]([A-Za-z0-9-_.]{0,62}[A-Za-z0-9])?$"
  >;
}

@armResourceOperations
interface TrafficControllers {
  /**
   * Get a TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TrafficControllerInterface_Get")
  get is ArmResourceRead<TrafficController>;

  /**
   * Create a TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TrafficControllerInterface_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<TrafficController>;

  /**
   * Update a TrafficController
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    TrafficController,
    PatchModel = TrafficControllerUpdate
  >;

  /**
   * Delete a TrafficController
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TrafficControllerInterface_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    TrafficController,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List TrafficController resources by resource group
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TrafficControllerInterface_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<TrafficController>;

  /**
   * List TrafficController resources by subscription ID
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TrafficControllerInterface_ListBySubscription")
  listBySubscription is ArmListBySubscription<TrafficController>;
}

@@doc(TrafficController.name, "traffic controller name for path");
@@doc(TrafficController.properties,
  "The resource-specific properties for this resource."
);
