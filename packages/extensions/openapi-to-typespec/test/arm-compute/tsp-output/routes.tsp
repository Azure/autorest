// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;

interface UsageOperations {
  /**
   * Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Usage_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages")
  @get
  list(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<ListUsagesResult> | ErrorResponse;
}

interface VirtualMachineSizesOperations {
  /**
   * This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/rest/api/compute/resourceskus/list)
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineSizes_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes")
  @get
  list(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineSizeListResult> | ErrorResponse;
}

interface VirtualMachineScaleSetsOperations {
  /**
   * Gets all the VM scale sets under the specified subscription for the specified location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSets_ListByLocation")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachineScaleSets")
  @get
  listByLocation(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<ResourceListResult<VirtualMachineScaleSet>> | ErrorResponse;
}

interface VirtualMachinesOperations {
  /**
   * Gets all the virtual machines under the specified subscription for the specified location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachines_ListByLocation")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines")
  @get
  listByLocation(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<ResourceListResult<VirtualMachine>> | ErrorResponse;
}

interface VirtualMachineImagesOperations {
  /**
   * Gets a virtual machine image.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_Get")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  get(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    /**
     * A valid image publisher offer.
     */
    @path
    offer: string,

    /**
     * A valid image SKU.
     */
    @path
    skus: string,

    /**
     * A valid image SKU version.
     */
    @path
    version: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineImage> | ErrorResponse;

  /**
   * Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  list(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    /**
     * A valid image publisher offer.
     */
    @path
    offer: string,

    /**
     * A valid image SKU.
     */
    @path
    skus: string,

    /**
     * The expand expression to apply on the operation.
     */
    @query("$expand")
    $expand?: string,

    @query("$top")
    $top?: int32,

    @query("$orderby")
    $orderby?: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets a list of virtual machine image offers for the specified location and publisher.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListOffers")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  listOffers(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets a list of virtual machine image publishers for the specified Azure location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListPublishers")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers")
  @get
  listPublishers(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListSkus")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  listSkus(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    /**
     * A valid image publisher offer.
     */
    @path
    offer: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets a list of all virtual machine image versions for the specified edge zone
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListByEdgeZone")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/vmimages")
  @get
  listByEdgeZone(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * The name of the edge zone.
     */
    @path
    edgeZone: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VmImagesInEdgeZoneListResult> | ErrorResponse;
}

interface VirtualMachineImagesEdgeZoneOperations {
  /**
   * Gets a virtual machine image in an edge zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_Get")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  get(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * The name of the edge zone.
     */
    @path
    edgeZone: string,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    /**
     * A valid image publisher offer.
     */
    @path
    offer: string,

    /**
     * A valid image SKU.
     */
    @path
    skus: string,

    /**
     * A valid image SKU version.
     */
    @path
    version: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineImage> | ErrorResponse;

  /**
   * Gets a list of all virtual machine image versions for the specified location, edge zone, publisher, offer, and SKU.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  list(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * The name of the edge zone.
     */
    @path
    edgeZone: string,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    /**
     * A valid image publisher offer.
     */
    @path
    offer: string,

    /**
     * A valid image SKU.
     */
    @path
    skus: string,

    /**
     * The expand expression to apply on the operation.
     */
    @query("$expand")
    $expand?: string,

    /**
     * An integer value specifying the number of images to return that matches supplied values.
     */
    @query("$top")
    $top?: int32,

    /**
     * Specifies the order of the results returned. Formatted as an OData query.
     */
    @query("$orderby")
    $orderby?: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets a list of virtual machine image offers for the specified location, edge zone and publisher.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_ListOffers")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  listOffers(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * The name of the edge zone.
     */
    @path
    edgeZone: string,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets a list of virtual machine image publishers for the specified Azure location and edge zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_ListPublishers")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers")
  @get
  listPublishers(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * The name of the edge zone.
     */
    @path
    edgeZone: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;

  /**
   * Gets a list of virtual machine image SKUs for the specified location, edge zone, publisher, and offer.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_ListSkus")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  listSkus(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * The name of the edge zone.
     */
    @path
    edgeZone: string,

    /**
     * A valid image publisher.
     */
    @path
    publisherName: string,

    /**
     * A valid image publisher offer.
     */
    @path
    offer: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<void> | ErrorResponse;
}

interface LogAnalyticsOperations {
  /**
   * Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("LogAnalytics_ExportRequestRateByInterval")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval")
  @post
  exportRequestRateByInterval(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,

    /**
     * Parameters supplied to the LogAnalytics getRequestRateByInterval Api.
     */
    @body
    parameters: RequestRateByIntervalInput,
  ): ArmResponse<LogAnalyticsOperationResult | void> | ErrorResponse;

  /**
   * Export logs that show total throttled Api requests for this subscription in the given time window.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("LogAnalytics_ExportThrottledRequests")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests")
  @post
  exportThrottledRequests(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,

    /**
     * Parameters supplied to the LogAnalytics getThrottledRequests Api.
     */
    @body
    parameters: ThrottledRequestsInput,
  ): ArmResponse<LogAnalyticsOperationResult | void> | ErrorResponse;
}

interface VirtualMachineRunCommandsOperations {
  /**
   * Lists all available run commands for a subscription in a location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineRunCommands_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/runCommands")
  @get
  list(
    ...ApiVersionParameter,
    ...LocationResourceParameter,
    ...SubscriptionIdParameter,

    /**
     * Accept header
     */
    @header
    accept: "application/json, text/json",
  ): ArmResponse<RunCommandListResult> | ErrorResponse;

  /**
   * Gets specific run command for a subscription in a location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineRunCommands_Get")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/runCommands/{commandId}")
  @get
  get(
    ...ApiVersionParameter,
    ...LocationResourceParameter,

    /**
     * The command id.
     */
    @path
    commandId: string,

    ...SubscriptionIdParameter,

    /**
     * Accept header
     */
    @header
    accept: "application/json, text/json",
  ): ArmResponse<RunCommandDocument> | ErrorResponse;
}

interface VirtualMachineScaleSetVMRunCommandsOperations {
  /**
   * The operation to create or update the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_CreateOrUpdate")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @put
  createOrUpdate(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    /**
     * The instance ID of the virtual machine.
     */
    @path
    instanceId: string,

    /**
     * The name of the virtual machine run command.
     */
    @path
    runCommandName: string,

    ...SubscriptionIdParameter,

    /**
     * Parameters supplied to the Create Virtual Machine RunCommand operation.
     */
    @body
    runCommand: VirtualMachineRunCommand,

    /**
     * Accept header
     */
    @header
    accept: "application/json, text/json",
  ): ArmResponse<VirtualMachineRunCommand> | ErrorResponse;

  /**
   * The operation to update the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_Update")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @patch
  update(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    /**
     * The instance ID of the virtual machine.
     */
    @path
    instanceId: string,

    /**
     * The name of the virtual machine run command.
     */
    @path
    runCommandName: string,

    ...SubscriptionIdParameter,

    /**
     * Parameters supplied to the Update Virtual Machine RunCommand operation.
     */
    @body
    runCommand: VirtualMachineRunCommandUpdate,

    /**
     * Accept header
     */
    @header
    accept: "application/json, text/json",
  ): ArmResponse<VirtualMachineRunCommand> | ErrorResponse;

  /**
   * The operation to delete the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_Delete")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @delete
  delete(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    /**
     * The instance ID of the virtual machine.
     */
    @path
    instanceId: string,

    /**
     * The name of the virtual machine run command.
     */
    @path
    runCommandName: string,

    ...SubscriptionIdParameter,

    /**
     * Accept header
     */
    @header
    accept: "application/json, text/json",
  ): ArmResponse<void> | ErrorResponse;

  /**
   * The operation to get the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @get
  get(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    /**
     * The instance ID of the virtual machine.
     */
    @path
    instanceId: string,

    /**
     * The name of the virtual machine run command.
     */
    @path
    runCommandName: string,

    /**
     * The expand expression to apply on the operation.
     */
    @query("$expand")
    $expand?: string,

    ...SubscriptionIdParameter,

    /**
     * Accept header
     */
    @header
    accept: "application/json, text/json",
  ): ArmResponse<VirtualMachineRunCommand> | ErrorResponse;

  /**
   * The operation to get all run commands of an instance in Virtual Machine Scaleset.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands")
  @get
  list(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    /**
     * The instance ID of the virtual machine.
     */
    @path
    instanceId: string,

    /**
     * The expand expression to apply on the operation.
     */
    @query("$expand")
    $expand?: string,

    ...SubscriptionIdParameter,

    /**
     * Accept header
     */
    @header
    accept: "application/json, text/json",
  ): ArmResponse<ResourceListResult<VirtualMachineRunCommand>> | ErrorResponse;
}

interface ResourceSkusOperations {
  /**
   * Gets the list of Microsoft.Compute SKUs available for your Subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ResourceSkus_List")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/skus")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    /**
     * The filter to apply on the operation. Only **location** filter is supported currently.
     */
    @query("$filter")
    $filter?: string,

    /**
     * To Include Extended Locations information or not in the response.
     */
    @query("includeExtendedLocations")
    includeExtendedLocations?: string,
  ): ArmResponse<ResourceSkusResult> | ErrorResponse;
}
