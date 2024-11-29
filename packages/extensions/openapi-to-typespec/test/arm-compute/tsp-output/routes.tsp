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

@armResourceOperations
interface UsageOperations {
  /**
   * Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Usage_List")
  @get
  @action("usages")
  list is ArmProviderActionAsync<
    Response = ListUsagesResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

@armResourceOperations
interface VirtualMachineSizesOperations {
  /**
   * This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/rest/api/compute/resourceskus/list)
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineSizes_List")
  @get
  @action("vmSizes")
  list is ArmProviderActionAsync<
    Response = VirtualMachineSizeListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

@armResourceOperations
interface VirtualMachineScaleSetsOperations {
  /**
   * Gets all the VM scale sets under the specified subscription for the specified location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSets_ListByLocation")
  @get
  @action("virtualMachineScaleSets")
  listByLocation is ArmProviderActionAsync<
    Response = VirtualMachineScaleSetListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

@armResourceOperations
interface VirtualMachinesOperations {
  /**
   * Gets all the virtual machines under the specified subscription for the specified location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachines_ListByLocation")
  @get
  @action("virtualMachines")
  listByLocation is ArmProviderActionAsync<
    Response = VirtualMachineListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

@armResourceOperations
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
  @get
  @action("versions")
  list is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * A valid image publisher.
       */
      @path
      @segment("publishers")
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      @segment("offers")
      offer: string;

      /**
       * A valid image SKU.
       */
      @path
      @segment("skus")
      skus: string;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;

      #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
      @query("$top")
      $top?: int32;

      #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
      @query("$orderby")
      $orderby?: string;
    }
  >;
  /**
   * Gets a list of virtual machine image offers for the specified location and publisher.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListOffers")
  @get
  @action("artifacttypes/vmimage/offers")
  listOffers is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * A valid image publisher.
       */
      @path
      @segment("publishers")
      publisherName: string;
    }
  >;
  /**
   * Gets a list of virtual machine image publishers for the specified Azure location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListPublishers")
  @get
  @action("publishers")
  listPublishers is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
  /**
   * Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListSkus")
  @get
  @action("skus")
  listSkus is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * A valid image publisher.
       */
      @path
      @segment("publishers")
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      @segment("offers")
      offer: string;
    }
  >;
  /**
   * Gets a list of all virtual machine image versions for the specified edge zone
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListByEdgeZone")
  @get
  @action("vmimages")
  listByEdgeZone is ArmProviderActionAsync<
    Response = VmImagesInEdgeZoneListResult,
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * The name of the edge zone.
       */
      @path
      @segment("edgeZones")
      edgeZone: string;
    }
  >;
}

@armResourceOperations
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
  @get
  @action("versions")
  list is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * The name of the edge zone.
       */
      @path
      @segment("edgeZones")
      edgeZone: string;

      /**
       * A valid image publisher.
       */
      @path
      @segment("publishers")
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      @segment("offers")
      offer: string;

      /**
       * A valid image SKU.
       */
      @path
      @segment("skus")
      skus: string;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;

      /**
       * An integer value specifying the number of images to return that matches supplied values.
       */
      @query("$top")
      $top?: int32;

      /**
       * Specifies the order of the results returned. Formatted as an OData query.
       */
      @query("$orderby")
      $orderby?: string;
    }
  >;
  /**
   * Gets a list of virtual machine image offers for the specified location, edge zone and publisher.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_ListOffers")
  @get
  @action("artifacttypes/vmimage/offers")
  listOffers is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * The name of the edge zone.
       */
      @path
      @segment("edgeZones")
      edgeZone: string;

      /**
       * A valid image publisher.
       */
      @path
      @segment("publishers")
      publisherName: string;
    }
  >;
  /**
   * Gets a list of virtual machine image publishers for the specified Azure location and edge zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_ListPublishers")
  @get
  @action("publishers")
  listPublishers is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * The name of the edge zone.
       */
      @path
      @segment("edgeZones")
      edgeZone: string;
    }
  >;
  /**
   * Gets a list of virtual machine image SKUs for the specified location, edge zone, publisher, and offer.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImagesEdgeZone_ListSkus")
  @get
  @action("skus")
  listSkus is ArmProviderActionAsync<
    Response = {
      @bodyRoot _: VirtualMachineImageResource[];
    },
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * The name of the edge zone.
       */
      @path
      @segment("edgeZones")
      edgeZone: string;

      /**
       * A valid image publisher.
       */
      @path
      @segment("publishers")
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      @segment("offers")
      offer: string;
    }
  >;
}

@armResourceOperations
interface LogAnalyticsOperations {
  /**
   * Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("LogAnalytics_ExportRequestRateByInterval")
  @post
  @action("logAnalytics/apiAccess/getRequestRateByInterval")
  exportRequestRateByInterval is ArmProviderActionAsync<
    Response = LogAnalyticsOperationResult | void,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter,
    Request = RequestRateByIntervalInput
  >;
  /**
   * Export logs that show total throttled Api requests for this subscription in the given time window.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("LogAnalytics_ExportThrottledRequests")
  @post
  @action("logAnalytics/apiAccess/getThrottledRequests")
  exportThrottledRequests is ArmProviderActionAsync<
    Response = LogAnalyticsOperationResult | void,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter,
    Request = ThrottledRequestsInput
  >;
}

@armResourceOperations
interface VirtualMachineRunCommandsOperations {
  /**
   * Lists all available run commands for a subscription in a location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineRunCommands_List")
  @get
  @action("runCommands")
  list is ArmProviderActionAsync<
    Response = RunCommandListResult,
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationParameter;

      /**
       * Accept header
       */
      @header
      accept: "application/json, text/json";
    }
  >;
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
    @bodyRoot
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
    @bodyRoot
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
  ): OkResponse | ArmAcceptedResponse | ErrorResponse;

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
  ): ArmResponse<VirtualMachineRunCommandsListResult> | ErrorResponse;
}

@armResourceOperations
interface ResourceSkusOperations {
  /**
   * Gets the list of Microsoft.Compute SKUs available for your Subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ResourceSkus_List")
  @get
  @action("skus")
  list is ArmProviderActionAsync<
    Response = ResourceSkusResult,
    Scope = SubscriptionActionScope,
    Parameters = {
      /**
       * The filter to apply on the operation. Only **location** filter is supported currently.
       */
      @query("$filter")
      $filter?: string;

      /**
       * To Include Extended Locations information or not in the response.
       */
      @query("includeExtendedLocations")
      includeExtendedLocations?: string;
    }
  >;
}
