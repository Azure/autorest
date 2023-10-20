import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("""
Specifies information about the availability set that the virtual machine
should be assigned to. Virtual machines specified in the same availability set
are allocated to different nodes to maximize availability. For more information
about availability sets, see [Availability sets
overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview).
For more information on Azure planned maintenance, see [Maintenance and updates
for Virtual Machines in
Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates).
Currently, a VM can only be added to an availability set at creation time. An
existing VM cannot be added to an availability set.
""")
model AvailabilitySet is TrackedResource<AvailabilitySetProperties> {
  @doc("The name of the availability set.")
  @path
  @key("availabilitySetName")
  @segment("availabilitySets")
  name: string;
}

@armResourceOperations
interface AvailabilitySets {
  @doc("Retrieves information about an availability set.")
  get is ArmResourceRead<AvailabilitySet>;
  @doc("Create or update an availability set.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<AvailabilitySet>;
  @doc("Update an availability set.")
  update is ArmResourcePatchSync<AvailabilitySet, AvailabilitySetProperties>;
  @doc("Delete an availability set.")
  delete is ArmResourceDeleteAsync<AvailabilitySet>;
  @doc("Lists all availability sets in a resource group.")
  list is ArmResourceListByParent<AvailabilitySet>;
  @doc("Lists all availability sets in a subscription.")
  listBySubscription is ArmListBySubscription<AvailabilitySet>;
}
