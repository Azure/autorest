import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Microsoft.Compute;

interface UsageOperations {
  @doc("Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The location for which resource usage is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ListUsagesResult
  >;
}

interface VirtualMachineSizesOperations {
  @doc("This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/rest/api/compute/resourceskus/list)")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which virtual-machine-sizes is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;
}

interface VirtualMachineImagesOperations {
  @doc("Gets a virtual machine image.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("A valid image SKU version.")
      @path
      version: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineImage
  >;

  @doc("Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @query $top: int32;
      @query $orderby: string;

      @query("$top")
      $top?: int32;

      @query("$orderby")
      $orderby?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine image offers for the specified location and publisher.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  ListOffers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine image publishers for the specified Azure location.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers")
  @get
  ListPublishers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  ListSkus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of all virtual machine image versions for the specified edge zone")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/vmimages")
  @get
  ListByEdgeZone is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VmImagesInEdgeZoneListResult
  >;
}

interface VirtualMachineImagesEdgeZoneOperations {
  @doc("Gets a virtual machine image in an edge zone.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("A valid image SKU version.")
      @path
      version: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineImage
  >;

  @doc("Gets a list of all virtual machine image versions for the specified location, edge zone, publisher, offer, and SKU.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;

      @doc("An integer value specifying the number of images to return that matches supplied values.")
      @query("$top")
      $top?: int32;

      @doc("Specifies the order of the results returned. Formatted as an OData query.")
      @query("$orderby")
      $orderby?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine image offers for the specified location, edge zone and publisher.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  ListOffers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine image publishers for the specified Azure location and edge zone.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers")
  @get
  ListPublishers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine image SKUs for the specified location, edge zone, publisher, and offer.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  ListSkus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface VirtualMachineExtensionImagesOperations {
  @doc("Gets a virtual machine extension image.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @path publisherName: string;
      @path type: string;
      @path version: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineExtensionImage
  >;

  @doc("Gets a list of virtual machine extension image types.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types")
  @get
  ListTypes is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @path publisherName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine extension image versions.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions")
  @get
  ListVersions is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @path publisherName: string;
      @path type: string;

      @doc("The filter to apply on the operation.")
      @query
      $filter: string;

      @query $top: int32;
      @query $orderby: string;

      @query("$top")
      $top?: int32;

      @query("$orderby")
      $orderby?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface LogAnalyticsOperations {
  @doc("Export logs that show Api requests made by this subscription in the given time window to show throttling activities.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval")
  @post
  ExportRequestRateByInterval is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which virtual-machine-sizes is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      ...RequestRateByIntervalInput;
    },
    LogAnalyticsOperationResult | void
  >;

  @doc("Export logs that show total throttled Api requests for this subscription in the given time window.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests")
  @post
  ExportThrottledRequests is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which virtual-machine-sizes is queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      ...ThrottledRequestsInput;
    },
    LogAnalyticsOperationResult | void
  >;
}

interface VirtualMachineScaleSetVMRunCommandsOperations {
  @doc("The operation to create or update the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      ...VirtualMachineRunCommand;

      @doc("Accept header")
      @header
      accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to update the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      ...VirtualMachineRunCommandUpdate;

      @doc("Accept header")
      @header
      accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to delete the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      accept: "application/json, text/json";
    },
    void
  >;

  @doc("The operation to get the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to get all run commands of an instance in Virtual Machine Scaleset.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      accept: "application/json, text/json";
    },
    VirtualMachineRunCommandsListResult
  >;
}

interface ResourceSkusOperations {
  @doc("Gets the list of Microsoft.Compute SKUs available for your Subscription.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/skus")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The filter to apply on the operation. Only **location** filter is supported currently.")
      @query("$filter")
      $filter?: string;

      @doc("To Include Extended Locations information or not in the response.")
      @query("includeExtendedLocations")
      includeExtendedLocations?: string;
    },
    ResourceSkusResult
  >;
}
