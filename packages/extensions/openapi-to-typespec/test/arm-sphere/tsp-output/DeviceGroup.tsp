import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Product.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An device group resource belonging to a product resource.
 */
@parentResource(Product)
model DeviceGroup
  is Azure.ResourceManager.ProxyResource<DeviceGroupProperties> {
  ...ResourceNameParameter<
    Resource = DeviceGroup,
    KeyName = "deviceGroupName",
    SegmentName = "deviceGroups",
    NamePattern = "^[A-Za-z0-9]{1,2}$|^[A-Za-z0-9][A-Za-z0-9\\s]{1,48}[A-Za-z0-9]$|^\\.default$|^\\.unassigned$"
  >;
}

@armResourceOperations
interface DeviceGroups {
  /**
   * Get a DeviceGroup. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  get is ArmResourceRead<DeviceGroup>;

  /**
   * Create a DeviceGroup. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DeviceGroup>;

  /**
   * Update a DeviceGroup. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<DeviceGroup, DeviceGroupUpdate>;

  /**
   * Delete a DeviceGroup. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  delete is ArmResourceDeleteAsync<DeviceGroup>;

  /**
   * List DeviceGroup resources by Product. '.default' and '.unassigned' are system defined values and cannot be used for product name.
   */
  listByProduct is ArmResourceListByParent<
    DeviceGroup,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DeviceGroup>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;

  /**
   * Bulk claims the devices. Use '.unassigned' or '.default' for the device group and product names when bulk claiming devices to a catalog only.
   */
  claimDevices is ArmResourceActionNoResponseContentAsync<
    DeviceGroup,
    ClaimDevicesRequest
  >;

  /**
   * Counts devices in device group. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  countDevices is ArmResourceActionSync<DeviceGroup, void, CountDeviceResponse>;
}

@@doc(DeviceGroup.name, "Name of device group.");
@@doc(DeviceGroups.claimDevices::parameters.body,
  "Bulk claim devices request body."
);
