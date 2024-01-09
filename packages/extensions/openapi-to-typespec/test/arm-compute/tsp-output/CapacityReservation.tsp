import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./CapacityReservationGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Specifies information about the capacity reservation.")
@parentResource(CapacityReservationGroup)
model CapacityReservation is TrackedResource<CapacityReservationProperties> {
  @doc("The name of the capacity reservation.")
  @key("capacityReservationName")
  @segment("capacityReservations")
  name: string;

  @doc("Availability Zone to use for this capacity reservation. The zone has to be single value and also should be part for the list of zones specified during the capacity reservation group creation. The zone can be assigned only during creation. If not provided, the reservation supports only non-zonal deployments. If provided, enforces VM/VMSS using this capacity reservation to be in same zone.")
  zones?: string[];

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface CapacityReservations {
  @doc("The operation that retrieves information about the capacity reservation.")
  get is ArmResourceRead<
    CapacityReservation,
    {
      ...BaseParameters<CapacityReservation>;

      @doc("The expand expression to apply on the operation. 'InstanceView' retrieves a snapshot of the runtime properties of the capacity reservation that is managed by the platform and can change outside of control plane operations.")
      @query("$expand")
      $expand?: CapacityReservationInstanceViewTypes;
    }
  >;

  @doc("The operation to create or update a capacity reservation. Please note some properties can be set only during capacity reservation creation. Please refer to https://aka.ms/CapacityReservation for more details.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CapacityReservation>;

  @doc("The operation to update a capacity reservation.")
  update is ArmCustomPatchAsync<CapacityReservation, CapacityReservationUpdate>;

  @doc("The operation to delete a capacity reservation. This operation is allowed only when all the associated resources are disassociated from the capacity reservation. Please refer to https://aka.ms/CapacityReservation for more details.")
  delete is ArmResourceDeleteAsync<CapacityReservation>;

  @doc("Lists all of the capacity reservations in the specified capacity reservation group. Use the nextLink property in the response to get the next page of capacity reservations.")
  listByCapacityReservationGroup is ArmResourceListByParent<CapacityReservation>;
}
