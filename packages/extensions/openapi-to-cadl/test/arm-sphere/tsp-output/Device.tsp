import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An device resource belonging to a device group resource.")
@parentResource(DeviceGroup)
model Device is ProxyResource<DeviceProperties> {
  @doc("Device name")
  @pattern("^[a-zA-Z0-9-]{128}$")
  @key("deviceName")
  @path
  @segment("devices")
  name: string;
}

@armResourceOperations
interface Devices
  extends Azure.ResourceManager.ProxyResourceOperations<Device> {
  @autoRoute
  @doc("""
Generates the capability image for the device. Use '.unassigned' or '.default'
for the device group and product names to generate the image for a device that
does not belong to a specific device group and product.
""")
  @armResourceAction(Device)
  @post
  generateCapabilityImage(
    ...ResourceInstanceParameters<Device>,

    @doc("Name of product.")
    @path
    productName: string,

    @doc("Name of device group.")
    @path
    deviceGroupName: string,

    @doc("Generate capability image request body.")
    @body
    generateDeviceCapabilityRequest: GenerateCapabilityImageRequest
  ): ArmResponse<SignedCapabilityImageResponse | void> | ErrorResponse;
}
