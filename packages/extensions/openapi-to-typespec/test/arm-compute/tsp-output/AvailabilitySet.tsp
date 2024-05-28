import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the availability set that the virtual machine should be assigned to. Virtual machines specified in the same availability set are allocated to different nodes to maximize availability. For more information about availability sets, see [Availability sets overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview). For more information on Azure planned maintenance, see [Maintenance and updates for Virtual Machines in Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates). Currently, a VM can only be added to an availability set at creation time. An existing VM cannot be added to an availability set.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model AvailabilitySet extends Resource {
  ...ResourceNameParameter<
    Resource = AvailabilitySet,
    KeyName = "availabilitySetName",
    SegmentName = "availabilitySets",
    NamePattern = ""
  >;

  /**
   * Sku of the availability set, only name is required to be set. See AvailabilitySetSkuTypes for possible set of values. Use 'Aligned' for virtual machines with managed disks and 'Classic' for virtual machines with unmanaged disks. Default value is 'Classic'.
   */
  sku?: Sku;

  /**
   * The instance view of a resource.
   */
  @extension("x-ms-client-flatten", true)
  properties?: AvailabilitySetProperties;
}

@armResourceOperations
interface AvailabilitySets {
  /**
   * Retrieves information about an availability set.
   */
  get is ArmResourceRead<AvailabilitySet>;

  /**
   * Create or update an availability set.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<AvailabilitySet>;

  /**
   * Update an availability set.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<AvailabilitySet, AvailabilitySetUpdate>;

  /**
   * Delete an availability set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<AvailabilitySet>;

  /**
   * Lists all availability sets in a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("AvailabilitySets_List")
  list is ArmResourceListByParent<AvailabilitySet>;

  /**
   * Lists all availability sets in a subscription.
   */
  listBySubscription is ArmListBySubscription<AvailabilitySet>;

  /**
   * Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
   */
  // FIXME: AvailabilitySets_ListAvailableSizes could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes")
  @get
  listAvailableSizes(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the availability set.
     */
    @path
    availabilitySetName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineSizeListResult> | ErrorResponse;
}

@@doc(AvailabilitySet.name, "The name of the availability set.");
@@encodedName(AvailabilitySets.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(AvailabilitySets.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(AvailabilitySets.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Availability Set operation."
);
@@encodedName(AvailabilitySets.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(AvailabilitySets.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(AvailabilitySets.update::parameters.properties,
  "Parameters supplied to the Update Availability Set operation."
);
