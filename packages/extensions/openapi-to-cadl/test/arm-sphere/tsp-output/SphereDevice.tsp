import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./SphereDeviceGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An device resource belonging to a device group resource.")
@parentResource(SphereDeviceGroup)
model SphereDevice is ProxyResource<DeviceProperties> {
  @doc("Device name")
  @pattern("^[a-zA-Z0-9-]{128}$")
  @path
  @key("deviceName")
  @segment("devices")
  name: string;
}

@armResourceOperations
interface SphereDevices {
  @doc("""
Get a Device. Use '.unassigned' or '.default' for the device group and product
names when a device does not belong to a device group and product.
""")
  get is ArmResourceRead<SphereDevice>;
  @doc("Delete a Device")
  delete is ArmResourceDeleteAsync<SphereDevice>;
  @doc("""
Update a Device. Use '.unassigned' or '.default' for the device group and
product names to move a device to the catalog level.
""")
  update is ArmResourcePatchAsync<SphereDevice, DeviceProperties>;
  @doc("""
Generates the capability image for the device. Use '.unassigned' or '.default'
for the device group and product names to generate the image for a device that
does not belong to a specific device group and product.
""")
  generateCapabilityImage is ArmResourceActionAsync<
    SphereDevice,
    {
      ...GenerateCapabilityImageRequest;
    },
    SignedCapabilityImageResponse
  >;
  @doc("""
Create a Device. Use '.unassigned' or '.default' for the device group and
product names to claim a device to the catalog only.
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<SphereDevice>;
  @doc("""
List Device resources by DeviceGroup. '.default' and '.unassigned' are system
defined values and cannot be used for product or device group name.
""")
  listBySphereDeviceGroup is ArmResourceListByParent<SphereDevice>;
}
