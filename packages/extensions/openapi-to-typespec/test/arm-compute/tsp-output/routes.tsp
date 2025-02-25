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

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface UsageOperations {
  /**
   * Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Usage_List")
  @autoRoute
  @get
  @action("usages")
  list is ArmProviderActionSync<
    Response = ListUsagesResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface VirtualMachineSizesOperations {
  /**
   * This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/rest/api/compute/resourceskus/list)
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineSizes_List")
  @autoRoute
  @get
  @action("vmSizes")
  list is ArmProviderActionSync<
    Response = VirtualMachineSizeListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface VirtualMachineScaleSetsOperations {
  /**
   * Gets all the VM scale sets under the specified subscription for the specified location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSets_ListByLocation")
  @autoRoute
  @get
  @action("virtualMachineScaleSets")
  listByLocation is ArmProviderActionSync<
    Response = ResourceListResult<VirtualMachineScaleSet>,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface VirtualMachinesOperations {
  /**
   * Gets all the virtual machines under the specified subscription for the specified location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachines_ListByLocation")
  @autoRoute
  @get
  @action("virtualMachines")
  listByLocation is ArmProviderActionSync<
    Response = ResourceListResult<VirtualMachine>,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
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
  @autoRoute
  @get
  @action("versions")
  list is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
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
  @autoRoute
  @get
  @action("artifacttypes/vmimage/offers")
  listOffers is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
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
  @autoRoute
  @get
  @action("publishers")
  listPublishers is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
  /**
   * Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineImages_ListSkus")
  @autoRoute
  @get
  @action("skus")
  listSkus is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
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
  @autoRoute
  @get
  @action("vmimages")
  listByEdgeZone is ArmProviderActionSync<
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

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
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
  @autoRoute
  @get
  @action("versions")
  list is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
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
  @autoRoute
  @get
  @action("artifacttypes/vmimage/offers")
  listOffers is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
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
  @autoRoute
  @get
  @action("publishers")
  listPublishers is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
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
  @autoRoute
  @get
  @action("skus")
  listSkus is ArmProviderActionSync<
    Response = Azure.Core.Page<VirtualMachineImageResource>,
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

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface LogAnalyticsOperations {
  /**
   * Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("LogAnalytics_ExportRequestRateByInterval")
  @autoRoute
  @action("logAnalytics/apiAccess/getRequestRateByInterval")
  exportRequestRateByInterval is ArmProviderActionAsync<
    Request = RequestRateByIntervalInput,
    Response = LogAnalyticsOperationResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter,
    LroHeaders = ArmAsyncOperationHeader &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  /**
   * Export logs that show total throttled Api requests for this subscription in the given time window.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("LogAnalytics_ExportThrottledRequests")
  @autoRoute
  @action("logAnalytics/apiAccess/getThrottledRequests")
  exportThrottledRequests is ArmProviderActionAsync<
    Request = ThrottledRequestsInput,
    Response = LogAnalyticsOperationResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter,
    LroHeaders = ArmAsyncOperationHeader &
      Azure.Core.Foundations.RetryAfterHeader
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface VirtualMachineRunCommandsOperations {
  /**
   * Lists all available run commands for a subscription in a location.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineRunCommands_List")
  @autoRoute
  @get
  @action("runCommands")
  list is ArmProviderActionSync<
    Response = RunCommandListResult & {
      @header
      contentType: "application/json" | "text/json";
    },
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
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
  ): ArmResponse<RunCommandDocument & {
    @header
    contentType: "application/json" | "text/json";
  }> | ErrorResponse;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface ResourceSkusOperations {
  /**
   * Gets the list of Microsoft.Compute SKUs available for your Subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ResourceSkus_List")
  @autoRoute
  @get
  @action("skus")
  list is ArmProviderActionSync<
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
