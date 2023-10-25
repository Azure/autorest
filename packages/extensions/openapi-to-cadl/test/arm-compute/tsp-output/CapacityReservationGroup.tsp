import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("""
Specifies information about the capacity reservation group that the capacity
reservations should be assigned to. Currently, a capacity reservation can only
be added to a capacity reservation group at creation time. An existing capacity
reservation cannot be added or moved to another capacity reservation group.
""")
model CapacityReservationGroup
  is TrackedResource<CapacityReservationGroupProperties> {
  @doc("The name of the capacity reservation group.")
  @path
  @key("capacityReservationGroupName")
  @segment("capacityReservationGroups")
  name: string;
}

@armResourceOperations
interface CapacityReservationGroups {
  @doc("The operation that retrieves information about a capacity reservation group.")
  get is ArmResourceRead<
    CapacityReservationGroup,
    {
      ...BaseParameters<CapacityReservationGroup>;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' will retrieve
the list of instance views of the capacity reservations under the capacity
reservation group which is a snapshot of the runtime properties of a capacity
reservation that is managed by the platform and can change outside of control
plane operations.
""")
      @query("$expand")
      $expand?: CapacityReservationGroupInstanceViewTypes;
    }
  >;
  @doc("""
The operation to create or update a capacity reservation group. When updating a
capacity reservation group, only tags may be modified. Please refer to
https://aka.ms/CapacityReservation for more details.
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CapacityReservationGroup>;
  @doc("""
The operation to update a capacity reservation group. When updating a capacity
reservation group, only tags may be modified.
""")
  update is ArmResourcePatchSync<
    CapacityReservationGroup,
    CapacityReservationGroupProperties
  >;
  @doc("""
The operation to delete a capacity reservation group. This operation is allowed
only if all the associated resources are disassociated from the reservation
group and all capacity reservations under the reservation group have also been
deleted. Please refer to https://aka.ms/CapacityReservation for more details.
""")
  delete is ArmResourceDeleteAsync<CapacityReservationGroup>;
  @doc("""
Lists all of the capacity reservation groups in the specified resource group.
Use the nextLink property in the response to get the next page of capacity
reservation groups.
""")
  listByResourceGroup is ArmResourceListByParent<
    CapacityReservationGroup,
    {
      ...BaseParameters<CapacityReservationGroup>;

      @doc("""
The expand expression to apply on the operation. Based on the expand param(s)
specified we return Virtual Machine or ScaleSet VM Instance or both resource
Ids which are associated to capacity reservation group in the response.
""")
      @query("$expand")
      $expand?: ExpandTypesForGetCapacityReservationGroups;
    }
  >;
  @doc("""
Lists all of the capacity reservation groups in the subscription. Use the
nextLink property in the response to get the next page of capacity reservation
groups.
""")
  listBySubscription is ArmListBySubscription<
    CapacityReservationGroup,
    {
      ...BaseParameters<CapacityReservationGroup>;

      @doc("""
The expand expression to apply on the operation. Based on the expand param(s)
specified we return Virtual Machine or ScaleSet VM Instance or both resource
Ids which are associated to capacity reservation group in the response.
""")
      @query("$expand")
      $expand?: ExpandTypesForGetCapacityReservationGroups;
    }
  >;
}
