import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DeviceGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An device resource belonging to a device group resource.
 */
@parentResource(DeviceGroup)
model Device is ProxyResource<DeviceProperties> {
  /**
   * Device name
   */
  @pattern("^[a-zA-Z0-9-]{128}$")
  @path
  @key("deviceName")
  @segment("devices")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Devices {
  /**
   * Get a Device. Use '.unassigned' or '.default' for the device group and product names when a device does not belong to a device group and product.
   */
  get is ArmResourceRead<Device>;

  /**
   * Create a Device. Use '.unassigned' or '.default' for the device group and product names to claim a device to the catalog only.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Device>;

  /**
   * Update a Device. Use '.unassigned' or '.default' for the device group and product names to move a device to the catalog level.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<Device, DeviceUpdate>;

  /**
   * Delete a Device
   */
  delete is ArmResourceDeleteAsync<Device>;

  /**
   * List Device resources by DeviceGroup. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  listByDeviceGroup is ArmResourceListByParent<Device>;

  /**
   * Generates the capability image for the device. Use '.unassigned' or '.default' for the device group and product names to generate the image for a device that does not belong to a specific device group and product.
   */
  generateCapabilityImage is ArmResourceActionAsync<
    Device,
    GenerateCapabilityImageRequest,
    SignedCapabilityImageResponse
  >;
}

@@doc(Devices.generateCapabilityImage::parameters.body,
  "Generate capability image request body."
);
