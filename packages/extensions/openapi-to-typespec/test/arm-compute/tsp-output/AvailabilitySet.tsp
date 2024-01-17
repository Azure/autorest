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

namespace Microsoft.Compute;
@doc("Specifies information about the availability set that the virtual machine should be assigned to. Virtual machines specified in the same availability set are allocated to different nodes to maximize availability. For more information about availability sets, see [Availability sets overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview). For more information on Azure planned maintenance, see [Maintenance and updates for Virtual Machines in Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates). Currently, a VM can only be added to an availability set at creation time. An existing VM cannot be added to an availability set.")
model AvailabilitySet is TrackedResource<AvailabilitySetProperties> {
  @doc("The name of the availability set.")
  @path
  @key("availabilitySetName")
  @segment("availabilitySets")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface AvailabilitySets {
  @doc("Retrieves information about an availability set.")
  get is ArmResourceRead<AvailabilitySet>;

  @doc("Create or update an availability set.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<AvailabilitySet>;

  @doc("Update an availability set.")
  @parameterVisibility("read")
  update is ArmCustomPatchSync<AvailabilitySet, AvailabilitySetUpdate>;

  @doc("Delete an availability set.")
  delete is ArmResourceDeleteSync<AvailabilitySet>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all availability sets in a resource group.")
  @operationId("AvailabilitySets_List")
  list is ArmResourceListByParent<AvailabilitySet>;

  @doc("Lists all availability sets in a subscription.")
  listBySubscription is ArmListBySubscription<AvailabilitySet>;

  @doc("Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.")
  // FIXME: AvailabilitySets_ListAvailableSizes could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes")
  @get
  listAvailableSizes is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the availability set.")
      @path
      availabilitySetName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;
}

@@projectedName(AvailabilitySets.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(AvailabilitySets.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(AvailabilitySets.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Availability Set operation."
);
@@projectedName(AvailabilitySets.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(AvailabilitySets.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(AvailabilitySets.update::parameters.properties,
  "Parameters supplied to the Update Availability Set operation."
);
