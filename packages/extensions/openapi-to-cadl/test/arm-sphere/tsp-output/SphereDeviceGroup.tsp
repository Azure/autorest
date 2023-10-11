import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./SphereProduct.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An device group resource belonging to a product resource.")
@parentResource(SphereProduct)
model SphereDeviceGroup is ProxyResource<DeviceGroupProperties> {
  @doc("Name of device group.")
  @pattern("^[A-Za-z0-9]{1,2}$|^[A-Za-z0-9][A-Za-z0-9\\s]{1,48}[A-Za-z0-9]$|^\\.default$|^\\.unassigned$")
  @path
  @key("deviceGroupName")
  @segment("deviceGroups")
  name: string;
}

@armResourceOperations
interface SphereDeviceGroups {
  @doc("""
Get a DeviceGroup. '.default' and '.unassigned' are system defined values and
cannot be used for product or device group name.
""")
  get is ArmResourceRead<SphereDeviceGroup>;
  @doc("""
Delete a DeviceGroup. '.default' and '.unassigned' are system defined values
and cannot be used for product or device group name.
""")
  delete is ArmResourceDeleteAsync<SphereDeviceGroup>;
  @doc("""
Update a DeviceGroup. '.default' and '.unassigned' are system defined values
and cannot be used for product or device group name.
""")
  update is ArmResourcePatchAsync<SphereDeviceGroup, DeviceGroupProperties>;
  @doc("""
Bulk claims the devices. Use '.unassigned' or '.default' for the device group
and product names when bulk claiming devices to a catalog only.
""")
  claimDevices is ArmResourceActionAsync<
    SphereDeviceGroup,
    {
      ...ClaimDevicesRequest;
    },
    SphereDeviceGroup
  >;
  @doc("""
Counts devices in device group. '.default' and '.unassigned' are system defined
values and cannot be used for product or device group name.
""")
  countDevices is ArmResourceActionSync<
    SphereDeviceGroup,
    {},
    CountDeviceResponse
  >;
  @doc("""
Create a DeviceGroup. '.default' and '.unassigned' are system defined values
and cannot be used for product or device group name.
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<SphereDeviceGroup>;
  @doc("""
List DeviceGroup resources by Product. '.default' and '.unassigned' are system
defined values and cannot be used for product name.
""")
  listBySphereProduct is ArmResourceListByParent<
    SphereDeviceGroup,
    {
      @doc("Filter the result list using the given expression")
      @query("$filter")
      filter?: string;

      @doc("The number of result items to return.")
      @query("$top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("$skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
}
