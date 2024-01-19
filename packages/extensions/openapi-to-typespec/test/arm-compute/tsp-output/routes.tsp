import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.Compute;

interface UsageOperations {
  /**
   * Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The location for which resource usage is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ListUsagesResult
  >;
}

interface VirtualMachineSizesOperations {
  /**
   * This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/rest/api/compute/resourceskus/list)
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The location upon which virtual-machine-sizes is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;
}

interface VirtualMachineImagesOperations {
  /**
   * Gets a virtual machine image.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      offer: string;

      /**
       * A valid image SKU.
       */
      @path
      skus: string;

      /**
       * A valid image SKU version.
       */
      @path
      version: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    VirtualMachineImage
  >;

  /**
   * Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      offer: string;

      /**
       * A valid image SKU.
       */
      @path
      skus: string;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;

      @query("$top")
      $top?: int32;

      @query("$orderby")
      $orderby?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets a list of virtual machine image offers for the specified location and publisher.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  listOffers is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets a list of virtual machine image publishers for the specified Azure location.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers")
  @get
  listPublishers is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  listSkus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      offer: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets a list of all virtual machine image versions for the specified edge zone
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/vmimages")
  @get
  listByEdgeZone is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * The name of the edge zone.
       */
      @path
      edgeZone: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    VmImagesInEdgeZoneListResult
  >;
}

interface VirtualMachineImagesEdgeZoneOperations {
  /**
   * Gets a virtual machine image in an edge zone.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * The name of the edge zone.
       */
      @path
      edgeZone: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      offer: string;

      /**
       * A valid image SKU.
       */
      @path
      skus: string;

      /**
       * A valid image SKU version.
       */
      @path
      version: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    VirtualMachineImage
  >;

  /**
   * Gets a list of all virtual machine image versions for the specified location, edge zone, publisher, offer, and SKU.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * The name of the edge zone.
       */
      @path
      edgeZone: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      offer: string;

      /**
       * A valid image SKU.
       */
      @path
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

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets a list of virtual machine image offers for the specified location, edge zone and publisher.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  listOffers is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * The name of the edge zone.
       */
      @path
      edgeZone: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets a list of virtual machine image publishers for the specified Azure location and edge zone.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers")
  @get
  listPublishers is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * The name of the edge zone.
       */
      @path
      edgeZone: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;

  /**
   * Gets a list of virtual machine image SKUs for the specified location, edge zone, publisher, and offer.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  listSkus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      /**
       * The name of the edge zone.
       */
      @path
      edgeZone: string;

      /**
       * A valid image publisher.
       */
      @path
      publisherName: string;

      /**
       * A valid image publisher offer.
       */
      @path
      offer: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface VirtualMachineExtensionImagesOperations {
  /**
   * Gets a list of virtual machine extension image versions.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions")
  @get
  listVersions is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of a supported Azure region.
       */
      @path
      location: string;

      @path
      publisherName: string;

      @path
      type: string;

      /**
       * The filter to apply on the operation.
       */
      @query("$filter")
      $filter?: string;

      @query("$top")
      $top?: int32;

      @query("$orderby")
      $orderby?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface LogAnalyticsOperations {
  /**
   * Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval")
  @post
  exportRequestRateByInterval is Azure.Core.Foundations.Operation<
    {
      /**
       * The location upon which virtual-machine-sizes is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Parameters supplied to the LogAnalytics getRequestRateByInterval Api.
       */
      @body
      parameters: RequestRateByIntervalInput;
    },
    LogAnalyticsOperationResult | void
  >;

  /**
   * Export logs that show total throttled Api requests for this subscription in the given time window.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests")
  @post
  exportThrottledRequests is Azure.Core.Foundations.Operation<
    {
      /**
       * The location upon which virtual-machine-sizes is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Parameters supplied to the LogAnalytics getThrottledRequests Api.
       */
      @body
      parameters: ThrottledRequestsInput;
    },
    LogAnalyticsOperationResult | void
  >;
}

interface VirtualMachineScaleSetVMRunCommandsOperations {
  /**
   * The operation to create or update the VMSS VM run command.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @put
  createOrUpdate is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * The instance ID of the virtual machine.
       */
      @path
      instanceId: string;

      /**
       * The name of the virtual machine run command.
       */
      @path
      runCommandName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Parameters supplied to the Create Virtual Machine RunCommand operation.
       */
      @body
      runCommand: VirtualMachineRunCommand;

      /**
       * Accept header
       */
      @header
      accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  /**
   * The operation to update the VMSS VM run command.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @patch
  update is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * The instance ID of the virtual machine.
       */
      @path
      instanceId: string;

      /**
       * The name of the virtual machine run command.
       */
      @path
      runCommandName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Parameters supplied to the Update Virtual Machine RunCommand operation.
       */
      @body
      runCommand: VirtualMachineRunCommandUpdate;

      /**
       * Accept header
       */
      @header
      accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  /**
   * The operation to delete the VMSS VM run command.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * The instance ID of the virtual machine.
       */
      @path
      instanceId: string;

      /**
       * The name of the virtual machine run command.
       */
      @path
      runCommandName: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Accept header
       */
      @header
      accept: "application/json, text/json";
    },
    void
  >;

  /**
   * The operation to get the VMSS VM run command.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * The instance ID of the virtual machine.
       */
      @path
      instanceId: string;

      /**
       * The name of the virtual machine run command.
       */
      @path
      runCommandName: string;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Accept header
       */
      @header
      accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  /**
   * The operation to get all run commands of an instance in Virtual Machine Scaleset.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * The instance ID of the virtual machine.
       */
      @path
      instanceId: string;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

      /**
       * Accept header
       */
      @header
      accept: "application/json, text/json";
    },
    ResourceListResult<VirtualMachineRunCommand>
  >;
}

interface ResourceSkusOperations {
  /**
   * Gets the list of Microsoft.Compute SKUs available for your Subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/skus")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;

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
    },
    ResourceSkusResult
  >;
}
