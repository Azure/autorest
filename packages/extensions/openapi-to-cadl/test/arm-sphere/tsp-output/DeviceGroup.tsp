import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@doc("An device group resource belonging to a product resource.")
@parentResource("Product")
model DeviceGroup is ProxyResource<DeviceGroupProperties> {
  @doc("Name of device group.")
  @pattern("^[A-Za-z0-9]{1,2}$|^[A-Za-z0-9][A-Za-z0-9\\s]{1,48}[A-Za-z0-9]$|^\\.default$|^\\.unassigned$")
  @key("deviceGroupName")
  @path
  @segment("deviceGroups")
  name: string;
}

@armResourceOperations
interface DeviceGroups
  extends Azure.ResourceManager.ProxyResourceOperations<
      DeviceGroup,
      DeviceGroupProperties
    > {
  @autoroute
  @doc("""
Bulk claims the devices. Use '.unassigned' or '.default' for the device group
and product names when bulk claiming devices to a catalog only.
""")
  @armResourceLocation(DeviceGroup)
  @post
  claimDevices(
    ...ResourceInstanceParameters<DeviceGroup>
  ): ArmResponse<void> | ErrorResponse;
  @autoroute
  @doc("""
Counts devices in device group. '.default' and '.unassigned' are system defined
values and cannot be used for product or device group name.
""")
  @armResourceLocation(DeviceGroup)
  @post
  countDevices(
    ...ResourceInstanceParameters<DeviceGroup>
  ): ArmResponse<CountDeviceResponse> | ErrorResponse;
}
