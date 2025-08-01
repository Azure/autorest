import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CapacityReservationGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the capacity reservation.
 */
@parentResource(CapacityReservationGroup)
model CapacityReservation
  is Azure.ResourceManager.TrackedResource<CapacityReservationProperties> {
  ...ResourceNameParameter<
    Resource = CapacityReservation,
    KeyName = "capacityReservationName",
    SegmentName = "capacityReservations",
    NamePattern = ""
  >;

  /**
   * SKU of the resource for which capacity needs be reserved. The SKU name and capacity is required to be set. Currently VM Skus with the capability called 'CapacityReservationSupported' set to true are supported. Refer to List Microsoft.Compute SKUs in a region (https://docs.microsoft.com/rest/api/compute/resourceskus/list) for supported values.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku: Sku;

  ...Azure.ResourceManager.AvailabilityZonesProperty;
}

@armResourceOperations
interface CapacityReservations {
  /**
   * The operation that retrieves information about the capacity reservation.
   */
  get is ArmResourceRead<
    CapacityReservation,
    Parameters = {
      /**
       * The expand expression to apply on the operation. 'InstanceView' retrieves a snapshot of the runtime properties of the capacity reservation that is managed by the platform and can change outside of control plane operations.
       */
      @query("$expand")
      $expand?: CapacityReservationInstanceViewTypes;
    }
  >;

  /**
   * The operation to create or update a capacity reservation. Please note some properties can be set only during capacity reservation creation. Please refer to https://aka.ms/CapacityReservation for more details.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    CapacityReservation,
    LroHeaders = ArmLroLocationHeader<FinalResult = CapacityReservation> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * The operation to update a capacity reservation.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    CapacityReservation,
    PatchModel = CapacityReservationUpdate
  >;

  /**
   * The operation to delete a capacity reservation. This operation is allowed only when all the associated resources are disassociated from the capacity reservation. Please refer to https://aka.ms/CapacityReservation for more details.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    CapacityReservation,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all of the capacity reservations in the specified capacity reservation group. Use the nextLink property in the response to get the next page of capacity reservations.
   */
  listByCapacityReservationGroup is ArmResourceListByParent<CapacityReservation>;
}

@@doc(CapacityReservation.name, "The name of the capacity reservation.");
@@doc(CapacityReservation.properties,
  "Properties of the Capacity reservation."
);
@@doc(CapacityReservations.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create capacity reservation."
);
@@doc(CapacityReservations.update::parameters.properties,
  "Parameters supplied to the Update capacity reservation operation."
);
